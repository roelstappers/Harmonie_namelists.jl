module Harmonie_namelists

import JSONSchema, YAML
using OrderedCollections, TOML
import Base.parse


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
const TYPE_INFO = YAML.load(open("$moduledir/namelists/type_info.yaml"))

include("dict2namelist.jl")
include("replace_env.jl")
# include("jsonschema.jl")

# Why is this not in Base? 
Base.parse(::Type{String},str::String) = str

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





end 
