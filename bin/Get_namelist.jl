#!/usr/bin/env julia

using Harmonie_namelists, YAML
import Base.ENV

# Usage:
#    Get_namemlist.jl 
# Will create the namelists defined in configs (see below) 
# Currently output is written to stdout


# Harmonie requires $ENSMBR to be exported. We set it here explicitly. 
# ENSMBR is not part of defaults.yaml     
Harmonie_namelists.MYENV["ENSMBR"] =1   


# Extract some values from ENV
alaro_version = Harmonie_namelists.MYENV["ALARO_VERSION"] 
dynamics = Harmonie_namelists.MYENV["DYNAMICS"]
physics  = Harmonie_namelists.MYENV["PHYSICS"] 
vert_disc = Harmonie_namelists.MYENV["VERT_DISC"] 
domain = Harmonie_namelists.MYENV["DOMAIN"] 
mass_flux_scheme = Harmonie_namelists.MYENV["MASS_FLUX_SCHEME"] 
simulation_type = Harmonie_namelists.MYENV["SIMULATION_TYPE"] 
cisba = Harmonie_namelists.MYENV["CISBA"] 

e927_dynamics =  dynamics == "nh" ? "e927_nh" : "empty"
pp_dynamics =  dynamics  == "nh" ? "pp_nh" : "empty"

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
Harmonie_namelists.MYENV["GNSS_OBS"] == "1" && Harmonie_namelists.MYENV["LVARBC_GNSS"] == "T" && push!(varbc_nam, "varbc_gnss")


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
    dicts = read_namelist.(configs[key])
    totdict = merge_namelists(dicts)    
    replace_env!(totdict)
    dict2namelist(io,totdict)


end




