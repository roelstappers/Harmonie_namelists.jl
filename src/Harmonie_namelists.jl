module Harmonie_namelists

import JSONSchema, YAML
using OrderedCollections, TOML
# import Base.isvalid

# export schema, isvalid, diagnose
export NAMELIST_DIR
export dict2namelist, read_namelists, merge_namelists, replace_env!

const moduledir=@__DIR__ 
# const schemafile="$moduledir/namelists.schema.json"
#const schema = JSONSchema.Schema(read(schemafile,String),parentFileDirectory="$moduledir/") 
# const schema = JSONSchema.Schema(read(schemafile,String)) 
# const NAMELIST_DIR = "$moduledir/namelists/ifs"
const NAMELIST_DIR = "$moduledir/namelists/toml/ifs"

include("dict2namelist.jl")

"""
    read_namelists(names)   

Returns array of dictionaries 
""" 
# read_namelists(names) = [YAML.load(open("$NAMELIST_DIR/$name.yaml")) for name in names]
read_namelists(names) = [TOML.parsefile("$NAMELIST_DIR/$name.toml") for name in names]

"""
    merge_namelists(dicts)

Returns a dictionary based on an arrays of dicts 
"""
merge_namelists(dicts) = merge!(merge,OrderedDict{String,Any}(),dicts...) 


#In Harmonie we support two patterns for strings in the YAML files
#    1) a string starting with $ is taken from the  enviroment and errors if the ENV variable is not set
#    2) a string starting with $ and containing a ? will use the ENV variable or the default value 
#        after the ? 
#     e.g. LAT0 : '$LAT0?5' in a YAML file means take LAT0 from the ENVironment or set it equal to 5

""" 
    replace_val_with_env(val)   

  
"""
replace_val_with_env(val::Number)  = val
replace_val_with_env(val::Bool)  = val

function replace_val_with_env(val::String) 
    if startswith(val, '$')
        str = lstrip(val, '$')
        if occursin("?", str)
            temp = split(str, '?')
            key = temp[1]
            default = temp[2]
            haskey(ENV, key) ? ENV[key]  : default  
        else
            haskey(ENV, str) ? ENV[str]  : error("No Env[$str]")
        end         
    else
        val
    end
end

"""
    replace_env!(d::AbstractDict) 

"""
function replace_env!(d::AbstractDict) 
    for (name, namelist) in d
        for (key,val) in namelist
            d[name][key] = replace_val_with_env(val)
        end  
    end 
end 


# In the future we wil validate namelists using JSONSchema

"""
    isvalid(namelist)

Check that `namelist` is valid against Harmonie.schema
"""
isvalid(namelist::Dict)  = JSONSchema.isvalid(namelist,schema) 

"""
    diagnose(namelist)

Check that `namelist` is valid against Harmonie.schema. If
valid return `nothing`, and if not, return a diagnostic String containing a
selection of one or more likely causes of failure.
"""
diagnose(namelist::Dict) = JSONSchema.diagnose(namelist,schema)



end 
