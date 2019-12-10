
using Harmonie_namelists
using Test


# These are very basic test. Once we have JSONSchema files for namelists 
# we could validate the namelists much better

# Check that the mechanism where we take variables from the ENVironment works
@testset "ENV" begin 
    dicts = read_namelist.(["global", "canari"])
    totdict = merge_namelists(dicts)
    # ENV["ENSMBR"] is not defined so replace_env! throws an error
    @test_throws ErrorException replace_env!(totdict)

    # After setting ENV["ENSMBR"] the same call should succeed (returns nothing)
    Harmonie_namelists.MYENV["ENSMBR"] = 123
    @test replace_env!(totdict) === nothing

    # Check that substitution worked 
    @test totdict["NAMGRIB"]["NENSFNB"] == 123

    # Check that call to dict2namelist succeeds
    @test dict2namelist(stdout,totdict) === nothing

   
end 

# Check that the mechanism where we optionally take variables from the ENVironment works
@testset "ENV?default" begin
    dicts = read_namelist.(["arome_screening"])
    totdict = merge_namelists(dicts)
    @test replace_env!(totdict)=== nothing
    @test totdict["NAMMKODB"]["NTBMAR"]  == -90
    @test totdict["NAMMKODB"]["NTFMAR"]  == 90

    # After setting ENV 
    Harmonie_namelists.MYENV["NTBMAR"] = 1
    Harmonie_namelists.MYENV["NTFMAR"] = 1
    dicts = read_namelist.(["arome_screening"])
    totdict = merge_namelists(dicts)
    @test replace_env!(totdict)=== nothing
    @test totdict["NAMMKODB"]["NTBMAR"]  == 1
    @test totdict["NAMMKODB"]["NTFMAR"]  == 1
end


BINDIR="../bin"
@testset "Namelists " begin
    # This should be improved we only test that gen_namelist and 
    # Get_namelist produce output
    @test !isempty(read(`$BINDIR/gen_namelist.jl args`))
    @test !isempty(read(`$BINDIR/Get_namelist.jl`))
end