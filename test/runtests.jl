
import Harmonie_namelists
import YAML, JSONSchema

using Test

BINDIR="$(pathof(Harmonie_namelists))/../bin"

@testset "Namelists " begin
    @test read(`$BINDIR/gen_namelist.jl args`) == 
end

end
