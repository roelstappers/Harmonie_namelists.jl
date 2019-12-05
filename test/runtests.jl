
using Harmonie_namelists
using Test


# These are very basic test. Once we have JSONSchema files for namelists 
# we could validate the namelists much better

# Check that the mechanism where we  take variables from the ENVironment works
@testset "ENV" begin 
    dicts = read_namelists(["global"])
    totdict = merge_namelists(dicts)
    # ENV["ENSMBR"] is not defined so replace_env! throws an error
    @test_throws ErrorException replace_env!(totdict)

    # After setting ENV["ENSMBR"] the same call should succeeds (returns nothing)
    ENV["ENSMBR"] = 1
    @test replace_env!(totdict) === nothing

end 


BINDIR="../bin"
@testset "Namelists " begin
    # This should be improved we only test that Gen_namelist produces output
    @test !isempty(read(`$BINDIR/gen_namelist.jl args`))
    @test !isempty(read(`$BINDIR/Get_namelist.jl`))
end

run_with__env(cmd) = run(Cmd(cmd,env=ODBENV))




