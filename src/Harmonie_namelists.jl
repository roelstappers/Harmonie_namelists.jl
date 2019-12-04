module Harmonie_namelists

import JSONSchema, YAML
using OrderedCollections, TOML
# import Base.isvalid

# export schema, isvalid, diagnose
export NAMELIST_DIR
export dict2namelist, read_namelists, merge_namelists

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
