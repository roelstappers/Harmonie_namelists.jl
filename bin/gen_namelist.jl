#!/usr/bin/env julia


# Usage example:
#      gen_namelist.jl global args  > fort.4
# will merge global.toml and args.toml and convert to namelist format 

using Harmonie_namelists

io = stdout   # io = open("fort.4")

dicts = read_namelist.(ARGS)
totdict = merge_namelists(dicts)
replace_env!(totdict)
dict2namelist(io,totdict)
