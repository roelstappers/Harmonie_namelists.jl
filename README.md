# Harmonie_namelists.jl

[![Build Status](https://travis-ci.com/roelstappers/Harmonie_namelists.jl.svg?branch=master)](https://travis-ci.com/roelstappers/Harmonie_namelists.jl)
[![Coverage Status](https://coveralls.io/repos/github/roelstappers/Harmonie_namelists.jl/badge.svg?branch=master)](https://coveralls.io/github/roelstappers/Harmonie_namelists.jl?branch=master)

Generation of Harmonie namelists validated using [json-schema](https://json-schema.org/)  

## Download julia

```bash
JULIA_VERSION=1.0.5   # Long term support version  
JULIA_VERSION=1.3.0  

# Julia will be downloaded to $JULIADIR
# Adjust for local HPC. 
JULIADIR=$PERM/julia

############################
#  Set environment variables  
##############################

# Add julia bin directory to PATH
export PATH=$PATH:${JULIADIR}/julia-${JULIA_VERSION}/bin

#####################################
#  wget julia source and untar
##################################

mkdir -p $JULIADIR
cd $JULIADIR
wget https://julialang-s3.julialang.org/bin/linux/x64/${JULIA_VERSION:0:3}/julia-${JULIA_VERSION}-linux-x86_64.tar.gz
tar -xf julia-${JULIA_VERSION}-linux-x86_64.tar.gz
rm -f julia-${JULIA_VERSION}-linux-x86_64.tar.gz
```

## Install Harmonie_namelists.jl

```bash

# JULIA_DEPOT_PATH controls where julia looks for package registries, installed packages etc. 
# Adjust for local HPC
export JULIA_DEPOT_PATH=$PERM/.julia

# git clone will put the Harmonie_namelists.jl package in the $JULIA_PROJECT directory
export JULIA_PROJECT=$JULIA_DEPOT_PATH/dev/Harmonie

# Add Harmonie_namelists.jl bin directory to PATH
export PATH=$PATH:${JULIA_PROJECT}/bin

####################
#   Clone Harmonie.jl 
###################

git clone https://github.com/roelstappers/Harmonie_namelists.jl.git $JULIA_PROJECT

#######################################################
#  Instantiate the environment and precompile dependencies
#  Using the Manifest.toml from Harmonie_namelists.jl
########################################################

julia -e 'using Pkg; Pkg.instantiate(); Pkg.API.precompile()'

####################
# Test installation
#####################
# gen_namelist.jl args
```
