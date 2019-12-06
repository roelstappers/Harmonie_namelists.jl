#In Harmonie we support two patterns for strings in the YAML files
#    1) a string starting with $ is taken from the  enviroment and errors if the ENV variable is not set
#    2) a string starting with $ and containing a ? will use the ENV variable or the default value 
#        after the ? 
#     e.g. LAT0 : '$LAT0?5' in a YAML file means take LAT0 from the ENVironment or set it equal to 5


replace_val_with_env(key, val::Number) = val    
replace_val_with_env(key, val::Bool) = val

string2type = Dict("Bool"=> Bool, "String" => String, "Int" => Int64, "Float" => Float64 )

function replace_val_with_env(key,val::String)     
    if startswith(val, '$')
        str = lstrip(val, '$')
        typestring = haskey(TYPE_INFO,key) ? TYPE_INFO[key] : error("No type_info.yaml entry for key $key")        
        Type = string2type[typestring]        
        if occursin("?", str)        
            temp = split(str, '?')
            key = temp[1]
            default = temp[2]
            haskey(ENV, key) ? parse(Type,ENV[key]) : parse(Type,default)
        else                    
            haskey(ENV, str) ? parse(Type,ENV[str])  : error("No Env[$str]")
        end         
    else
        val
    end
end

function replace_env!(d::AbstractDict) 
    for (name, namelist) in d
        for (key,val) in namelist
            d[name][key] = replace_val_with_env(key,val)
        end  
    end 
end 