
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