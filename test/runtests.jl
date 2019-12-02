
import Harmonie_Namelist
import YAML, TOML, JSON, JSONSchema

using Test

@testset "Namelists " begin
    @test run(`../bin/gen_namelist.jl args > args.nml`)
end

end
