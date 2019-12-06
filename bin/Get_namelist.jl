#!/usr/bin/env julia

using Harmonie_namelists

# Usage:
#    Get_namemlist.jl 
# Will create the namelists defined in configs (see below) 
# Currently output is written to stdout


# We set ENV here. Could run `export LMPOFF=".TRUE."` etc  before calling this script.  
ENV["LMPOFF"] = true
ENV["ENSMBR"] = 1
ENV["L_GATHERV_WRGP"] = true  
ENV["NPROMA"]  = 1
ENV["LHARATU"]  = true 
ENV["NPROC_IO"] = 1
ENV["CIFDIR"] = "a/b/c"
ENV["TEFRCL"] = 1
ENV["LSTATNW"] = true 
ENV["NXGSTPERIOD"] = 0

default = ["global", "host_specific", "mpp","file"]
dynamics = "arome"

# Note: these are not consistent with Get_namelist
# should read this from yaml/toml file
configs = Dict("e927" => [default; dynamics; "dfi"; "args"],
               "forecast" => [default; dynamics;  "surfex"; "args"],
               "e401" => [default; "e401"; "args"],
               "pp"  => [default; "fullpos"; "pp_default"; "pp_surfex"; "pp_arome"  ],    # -r NAMFPC
               "oulan" => ["oulan"],
               "screening" => [default; "screening"; "arome_screening"; "args"],
               "minimization" => [default; "arome_minimization"],
               "screen4d" => [default; "screening"; dynamics; "args"])

io =stdout
for key in keys(configs) 
    println(key)    
    dicts = read_namelists(configs[key])
    totdict = merge_namelists(dicts)
    replace_env!(totdict)
    dict2namelist(io,totdict)


end




