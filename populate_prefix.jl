using Pkg;
using Base.BinaryPlatforms;
Pkg.activate(; temp=true);
Pkg.add(url="https://github.com/JuliaPackaging/JLLPrefixes.jl");

using JLLPrefixes

prefix=ARGS[1]
arch=ARGS[2]

platform=Platform(arch, "macos")
artifact_paths = collect_artifact_paths(["polymake_jll"]; platform=platform)
deploy_artifact_paths(prefix, artifact_paths; strategy=:copy)

println("For sources see:")
println("   ".join(map(x->"https://github.com/JuliaBinaryWrappers/$(x.name).jl",collect(keys(artifact_paths))),"\n   "))
println();

