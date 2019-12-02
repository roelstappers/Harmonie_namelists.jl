#!/usr/bin/env julia

using YAML, OrderedCollections, Logging

CDIR = @__DIR__
NAMELIST_DIR = "$CDIR/../src/namelist/ifs"

println(NAMELIST_DIR)

tofortran(val::Bool) =  val ? ".TRUE."  :  ".FALSE."
tofortran(val::Number) = val

# tofortran(val::String) = "'$val'"
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

io = stdout

println(io, "# this file has been generated automatically")

totdict = OrderedDict{String,Any}()
for  name in ARGS
    dict = YAML.load(open("$NAMELIST_DIR/$name.yaml"))    
    merge!(merge, totdict, dict)
end

for (groupname, group) in totdict
    println(io, "&$groupname")    
    if !(group === nothing) 
        for (key, value) in group 
            println(io, "  $key = $(tofortran(value)),")
        end
    end    
    println(io, "/")
end
