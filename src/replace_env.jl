#  String starting with $ is taken from the  enviroment and errors if the ENV variable is not set

string2type = Dict("Bool"=> Bool, "String" => String, "Int" => Int64, "Float" => Float64 )

replace_val_with_env(key, val::Number) = val    
replace_val_with_env(key, val::Bool) = val

function replace_val_with_env(key,val::String)     
    if startswith(val, '$')
        str = lstrip(val, '$')
        typestring = haskey(TYPE_INFO,key) ? TYPE_INFO[key] : error("No type_info.yaml entry for key $key")        
        Type = string2type[typestring]        
        haskey(MYENV, str) ? parse(Type,MYENV[str])  : error("No Env[$str]")
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