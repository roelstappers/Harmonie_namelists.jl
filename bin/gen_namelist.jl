#!/usr/bin/env julia

using Harmonie_namelists

io = stdout   # io = open("fort.4")

dicts = read_namelists(ARGS)
totdict = merge_namelists(dicts)
dict2namelist(io,totdict)
