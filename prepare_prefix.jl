using Pkg;
Pkg.activate(; temp=true);
Pkg.add(url="https://github.com/JuliaPackaging/JLLPrefixes.jl");

using JLLPrefixes

prefix=joinpath(dirname(@__FILE__),"prefix");
artifact_paths = collect_artifact_paths(["polymake_jll"])
deploy_artifact_paths(prefix, artifact_paths; strategy=:copy)

println("For sources see:")
print(join(map(x->"https://github.com/JuliaBinaryWrappers/$(x.name).jl",collect(keys(artifact_paths))),"\n"))

