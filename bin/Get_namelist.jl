#!/usr/bin/env julia

using Harmonie_namelists


# We set ENV here. Could run `export LMPOFF=".TRUE."` etc  before calling this script.  
ENV["LMPOFF"] = ".TRUE."
ENV["ENSMBR"] = 1
ENV["L_GATHERV_WRGP"] = ".TRUE." 
ENV["NPROMA"]  = 1
ENV["NPROC_IO"] = 1
ENV["CIFDIR"] = "1"
ENV["TEFRCL"] = 1

default = ["global", "host_specific", "mpp","file"]
dynamics = "arome"

# These are not consistent with Get_namelist yet
# should read this from yaml/toml file
configs = Dict("e927" => [default; "dynamics"; "dfi"; "args"],
               "e401" => [default; "e401"; "args"],
               "pp"  => [default; "fullpos"; "pp_default"; "pp_surfex"; "pp_arome"  ],    # -r NAMFPC
               "oulan" => ["oulan"],
               "screening" => [default; "screening"; "arome_screening"; "args"],
               "minimization" => [default; "arome_minimization"])

io =stdout
for key in keys(configs) 
    println(key)
    dicts = read_namelists(configs[key])
    totdict = merge_namelists(dicts)
    dict2namelist(io,totdict)


end




