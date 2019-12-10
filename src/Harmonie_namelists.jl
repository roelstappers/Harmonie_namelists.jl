module Harmonie_namelists

import JSONSchema, YAML
using OrderedCollections, TOML
import Base.parse


# import Base.isvalid

# export schema, isvalid, diagnose
export NAMELIST_DIR
export dict2namelist, read_namelist, merge_namelists, replace_env!

const moduledir=@__DIR__ 
# const schemafile="$moduledir/namelists.schema.json"
#const schema = JSONSchema.Schema(read(schemafile,String),parentFileDirectory="$moduledir/") 
# const schema = JSONSchema.Schema(read(schemafile,String)) 
# const NAMELIST_DIR = "$moduledir/namelists/ifs"
const NAMELIST_DIR = "$moduledir/namelists/"
const TYPE_INFO = YAML.load(open("$NAMELIST_DIR/type_info.yaml"))
const DEFAULTS  = YAML.load(open("$NAMELIST_DIR/defaults.yaml"))  
const MYENV =  merge((env, def) -> env, ENV,DEFAULTS)  

include("dict2namelist.jl")
include("replace_env.jl")
# include("jsonschema.jl")

# Why is this not in Base? 
Base.parse(::Type{String},str::String) = str
Base.parse(::Type{Int64}, int::Int64)  = int
Base.parse(::Type{Bool}, bool::Bool)  = bool

read_namelist(name) = YAML.load(open("$NAMELIST_DIR/yaml/ifs/$name.yaml"))
# read_namelist(name) = TOML.parsefile("$NAMELIST_DIR/toml/ifs/$name.toml")

"""
    merge_namelists(dicts)

Returns a dictionary based on an arrays of dicts 
"""
merge_namelists(dicts) = merge!(merge,OrderedDict{String,Any}(),dicts...) 








end 
