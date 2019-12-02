module Harmonie_namelists

import JSONSchema
import Base.isvalid

export schema, isvalid, diagnose

const moduledir=@__DIR__ 
const schemafile="$moduledir/namelists.schema.json"
const schema = JSONSchema.Schema(read(schemafile,String),parentFileDirectory="$moduledir/") 
# const schema = JSONSchema.Schema(read(schemafile,String)) 


"""
    isvalid(config)

Check that `config` is valid against Harmonie.schema
"""
isvalid(namelist::Dict)  = JSONSchema.isvalid(namelist,schema) 

"""
    diagnose(config)

Check that `config` is valid against Harmonie.schema. If
valid return `nothing`, and if not, return a diagnostic String containing a
selection of one or more likely causes of failure.
"""
diagnose(namelist::Dict) = JSONSchema.diagnose(namelist,schema)





end 
