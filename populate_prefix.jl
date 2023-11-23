using Pkg;
using Base.BinaryPlatforms;
Pkg.activate(; temp=true);
Pkg.add("JLLPrefixes");
Pkg.add("ArgParse");

using JLLPrefixes
using ArgParse

function parse_commandline()
    s = ArgParseSettings()
    @add_arg_table s begin
        "--prefix"
            help = "starting value of array"
            arg_type = String
            default = "/tmp/pmjll"
        "--arch"
            help = "architecture (x86_64, aarch64)"
            arg_type = String
            default = "aarch64"
        "--os"
            help = "operating system (linux, macos)"
            arg_type = String
            default = "macos"
        "--pmver"
            help = "polymake version"
            arg_type = String
            default = ""
    end
    return parse_args(s)
end

parsed_args = parse_commandline()

prefix = parsed_args["prefix"]
arch = parsed_args["arch"]
os = parsed_args["os"]
pmver = parsed_args["pmver"]

platform = Platform(arch, os)
deps = [PackageSpec(; name="Ninja_jll")]
if pmver != ""
   pmver = VersionNumber(pmver)
   if pmver.major < 100
      pmver = VersionNumber(100*pmver.major, 100*pmver.minor)
   end
   push!(deps, PackageSpec(; name="polymake_jll", version=Pkg.Types.VersionSpec(pmver)))
else
   push!(deps, PackageSpec(; name="polymake_jll"))
end
artifact_paths = collect_artifact_paths(deps; platform=platform)
deploy_artifact_paths(joinpath(prefix,"$os-$arch"), artifact_paths; strategy=:copy)
println("done: ", joinpath(prefix,"$os-$arch"))

println("For sources see:")
println("   ",join(map(x->"https://github.com/JuliaBinaryWrappers/$(x.name).jl", collect(keys(artifact_paths))),"\n   "))
println();

