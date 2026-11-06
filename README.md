# 🧰 vexstd

Small standard helpers for the [Vex language](https://github.com/cybercoretech/vexlang):
integer math and `Result` utilities. It's the first package in the
[Vex package index](https://github.com/cybercoretech/vex-index).

## 📥 Install

```sh
vexlang add vexstd          # adds vexstd = "0.1.0" to vex.toml and installs it
```

```vex
use vexstd;

println(clamp(150, 0, 100));          // 100
println(gcd(48, 18));                 // 6
println(unwrap_or(err("nope"), 7));   // 7
```

## 📚 API (0.1.0)

All integer helpers take and return `i32` and use Vex's checked arithmetic,
so overflow and division by zero trap instead of wrapping.

| Function | Returns |
|---|---|
| `abs(x)` | absolute value (`abs(i32::MIN)` traps) |
| `min(a, b)`, `max(a, b)` | the smaller / larger value |
| `clamp(x, lo, hi)` | `x` limited to `lo..=hi` |
| `sign(x)` | `-1`, `0` or `1` |
| `between(x, lo, hi) -> bool` | `lo <= x <= hi` |
| `rem(a, b)` | remainder with the sign of `a` (like Rust's `%`) |
| `is_even(x)`, `is_odd(x) -> bool` | parity |
| `pow(base, exp)` | `base^exp`; a negative `exp` gives `0` |
| `gcd(a, b)`, `lcm(a, b)` | always `>= 0`; `gcd(0, 0) == 0`, `lcm(x, 0) == 0` |
| `unwrap_or(r: Result, otherwise)` | the `Ok` value, or `otherwise` |
| `is_ok(r)`, `is_err(r) -> bool` | which variant `r` is |

## ⚠️ Notes

- **Shared namespace:** Vex modules currently share one namespace, so if your
  program declares its own `min` or `abs`, `use vexstd;` reports a clash
  (`E1104`) that names both. Rename yours, or don't import vexstd into that file.
- **Interpreter only for `Result` helpers:** the `rust` backend can't
  express Vex's untyped `Result` parameters yet, so programs using
  `unwrap_or`/`is_ok`/`is_err` don't transpile to Rust. The integer helpers do.

## 🛠️ Development

```sh
scripts/test.sh             # vexlang check + 27 runtime checks (tests/smoke.vex)
vexlang package             # dist/vexstd-VERSION.tar.gz (reproducible)
```

Releasing a version: bump `version` in `vex.toml`, then `vexlang package`,
then `gh release create vVERSION dist/vexstd-VERSION.tar.gz`. Finally, run
`vexlang publish --index ../vex-index --url <asset URL>` and open a PR
against vex-index.

## 📜 License

MIT. Report security issues to security@cybercoretech.net.

---

👻 Code & Design by Darkstardevx
