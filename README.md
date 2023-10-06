### pmjll - build polymake binaries with JLLPrefixes.jl

This uses https://github.com/JuliaBinaryWrappers/polymake_jll.jl and its dependencies to build a self-contained polymake binary tarball, using [JLLPrefixes.jl](https://github.com/JuliaPackaging/JLLPrefixes.jl).

```
./create_tarball.sh [-a arch] [-j julia] [-p prefix] [-o os]
```

- `arch`: `x86_64` or `aarch64`.
- `os`: `linux` or `macos`.
- `julia`: should point to a julia binary, this is only needed for building the tarball.
- `prefix`: temporary installation prefix (default: `/tmp/pmjll`).

Other architectures or operating systems might work as well if supported by [polymake_jll](https://github.com/JuliaBinaryWrappers/polymake_jll.jl#platforms).
