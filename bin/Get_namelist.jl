#!/usr/bin/env julia

using Harmonie_namelists

# Usage:
#    Get_namemlist.jl 
# Will create the namelists defined in configs (see below) 
# Currently output is written to stdout


# We set ENV here. Could run `export LMPOFF=".TRUE."` etc  before calling this script.  
# In the future we should read this from a config file and remove the default values here. 
# Cleaner here would be to create a Default::dict and use merge(Default,ENV) 
# default = Dict{String,Any}(); default["LMPOFF"] = false
ENV["LMPOFF"] = haskey(ENV,"LMPOFF") ? ENV["LMPOFF"]  : false
ENV["L_GATHERV_WRGP"] = true  
ENV["NPROC_IO"] = 1
alaro_version = haskey(ENV,"ALARO_VERSION") ? ENV["ALARO_VERSION"]  : 0 
dynamics = haskey(ENV,"DYNAMICS") ? ENV["DYNAMICS"]  : "nh" 
physics  = haskey(ENV,"PHYSICS") ? ENV["PHYSICS"]  : "arome" 
vert_disc = haskey(ENV,"VERT_DISC") ? ENV["VERT_DISC"]  : "vfd"
domain = haskey(ENV,"DOMAIN") ? ENV["DOMAIN"] : "TEST"
mass_flux_scheme = haskey(ENV,"MASS_FLUX_SCHEME") ? ENV["MASS_FLUX_SCHEME"] : "edmfm"
simulation_type = haskey(ENV,"SIMULATION_TYPE") ? ENV["SIMULATION_TYPE"] : "nwp"
cisba = haskey(ENV,"CISBA") ? ENV["CISBA"] : "3-L"

ENV["ENSMBR"] = 1
ENV["NPROMA"]  = 1
ENV["LHARATU"]  = true 
ENV["CIFDIR"] = "a/b/c"
ENV["TEFRCL"] = 1
ENV["LSTATNW"] = true 
ENV["NXGSTPERIOD"] = 0
ENV["GNSS_OBS"] = 0
ENV["LVARBC_GNSS"] = false

 

e927_dynamics = dynamics  == "nh" ? "e927_nh" : "empty"
pp_dynamics = dynamics == "nh" ? "pp_nh" : "empty"

# Misc
extra_forecast_options= vert_disc 

# Surfex 
prep_sfx="offline_prep"



default = ["global", "host_specific", "mpp","file"]




sfx_tree_drag_options = "tree_drag"

cisbal=cisba # No need for if-statement ala Harmonie here    

# Extra physics options
physics_options = [physics]
physics == "arome" && push!(physics_options, mass_flux_scheme)
physics == "alaro" && push!(physics_options,"alaro$alaro_version")

# musc
domain == "MUSC" && push!(extra_forecast_options,["musc"; "args"])

# Climate simulation
simulation_type == "climate" && push!(extra_forecast_options,["cc01_mse"; "args"])

# varbc
varbc_nam  = ["varbc"]
ENV["GNSS_OBS"] == "1" && ENV["LVARBC_GNSS"] == "T" && push!(varbc_nam, "varbc_gnss")


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




