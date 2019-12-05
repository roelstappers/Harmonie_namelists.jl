
tofortran(val::Bool) =  val ? ".TRUE."  :  ".FALSE."
tofortran(val::Number) = val
tofortran(val::String) = "'$val'"

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
