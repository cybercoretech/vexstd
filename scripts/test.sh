#!/usr/bin/env sh
# Runs the vexstd checks against this checkout.
#
# tests/smoke.vex does `use vexstd;`. Packages normally live in
# vex_modules/, so a throwaway project under target/ links vex_modules/vexstd
# to this repository and runs the checks from there.
set -eu
root=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
work="$root/target/test-project"
rm -rf "$work"
mkdir -p "$work/vex_modules"
printf '[project]\nname = "vexstd-tests"\nversion = "0.0.0"\n' > "$work/vex.toml"
ln -s "$root" "$work/vex_modules/vexstd"
cp "$root/tests/smoke.vex" "$work/smoke.vex"
vexlang check "$root/src/lib.vex"
vexlang run "$work/smoke.vex"

# The same checks through the Rust backend: transpile, compile, run.
# Needs a vexlang newer than 0.1.0-alpha.3 (Result support) and rustc.
# Set VEXSTD_SKIP_RUST=1 to skip.
if [ "${VEXSTD_SKIP_RUST:-0}" != 1 ]; then
    vexlang rust "$work/smoke.vex" > "$work/smoke.rs"
    rustc --edition 2021 -o "$work/smoke-rs" "$work/smoke.rs"
    "$work/smoke-rs"
fi
