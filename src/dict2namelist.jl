
tofortran(val::Bool) =  val ? ".TRUE."  :  ".FALSE."
tofortran(val::Number) = val

# In Harmonie we support two patterns for strings in the YAML files
# 1) a string starting with $ is taken from the  enviroment and errors if the ENV variable is not set
# 2) a string starting with $ and containing a ? will use the ENV variable or the default value 
#     after the ? 
#  e.g. LAT0 : $LAT0?5 in a YAML file means take LAT0 from the ENVironment or set it equal to 5
function tofortran(val::String)  
    if startswith(val, '$')
        str = lstrip(val, '$')
        if occursin("?", str)
            temp = split(str, '?')
            key = temp[1]
            default = temp[2]
            haskey(ENV, key) ? ENV[key]  : default  
        else
            haskey(ENV, str) ? ENV[str]  : error("No ENV[$str]")
        end
         
    else
        return "'$val'"
    end
end

function dict2namelist(io::IO, dict::AbstractDict)
    println(io, "# this file has been generated automatically")
    for (groupname, group) in dict
        println(io, "&$groupname")    
        if !(group === nothing) 
            for (key, value) in group 
                println(io, "  $key = $(tofortran(value)),")
            end
        end    
        println(io, "/")
    end
end 
