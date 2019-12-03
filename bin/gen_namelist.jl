#!/usr/bin/env julia

using Harmonie_namelists  # , YAML, OrderedCollections


# 
dicts = read_namelists(ARGS)
totdict = merge_namelists(dicts)

io = stdout
dict2namelist(io,totdict)
