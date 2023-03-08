using Survey
using Test
using CategoricalArrays

const STAT_TOL = 1e-5
const SE_TOL = 1e-1
TOTAL_REPLICATES = 4000
REPLICATES_VECTOR = [Symbol("replicate_"*string(i)) for i in 1:TOTAL_REPLICATES]
REPLICATES_REGEX = r"r*_\d"

# Simple random sample
apisrs = load_data("apisrs") # Load API dataset
srs = SurveyDesign(apisrs, weights = :pw)
unitrange = UnitRange((length(names(apisrs)) + 1):(TOTAL_REPLICATES + length(names(apisrs))))
bsrs = srs |> bootweights # Create replicate design
bsrs_direct = ReplicateDesign(bsrs.data, REPLICATES_VECTOR, weights = :pw)  # using ReplicateDesign constructor
bsrs_unitrange = ReplicateDesign(bsrs.data, unitrange, weights = :pw)  # using ReplicateDesign constructor
bsrs_regex = ReplicateDesign(bsrs.data, REPLICATES_REGEX, weights = :pw)  # using ReplicateDesign constructor

# Stratified sample
apistrat = load_data("apistrat") # Load API dataset
dstrat = SurveyDesign(apistrat, strata = :stype, weights = :pw) # Create SurveyDesign
unitrange = UnitRange((length(names(apistrat)) + 1):(TOTAL_REPLICATES + length(names(apistrat))))
bstrat = dstrat |> bootweights # Create replicate design
bstrat_direct = ReplicateDesign(bstrat.data, REPLICATES_VECTOR, strata=:stype, weights=:pw)  # using ReplicateDesign constructor
bstrat_unitrange = ReplicateDesign(bstrat.data, unitrange, strata=:stype, weights=:pw)  # using ReplicateDesign constructor
bstrat_regex = ReplicateDesign(bstrat.data, REPLICATES_REGEX, strata=:stype, weights=:pw)  # using ReplicateDesign constructor

# One-stage cluster sample
apiclus1 = load_data("apiclus1") # Load API dataset
apiclus1[!, :pw] = fill(757 / 15, (size(apiclus1, 1),)) # Correct api mistake for pw column
dclus1 = SurveyDesign(apiclus1; clusters = :dnum, weights = :pw) # Create SurveyDesign
unitrange = UnitRange((length(names(apiclus1)) + 1):(TOTAL_REPLICATES + length(names(apiclus1))))
dclus1_boot = dclus1 |> bootweights # Create replicate design
dclus1_boot_direct = ReplicateDesign(dclus1_boot.data, REPLICATES_VECTOR, clusters=:dnum, weights=:pw)  # using ReplicateDesign constructor
dclus1_boot_unitrange = ReplicateDesign(dclus1_boot.data, unitrange, clusters=:dnum, weights=:pw)  # using ReplicateDesign constructor
dclus1_boot_regex = ReplicateDesign(dclus1_boot.data, REPLICATES_REGEX, clusters=:dnum, weights=:pw)  # using ReplicateDesign constructor

# Two-stage cluster sample
apiclus2 = load_data("apiclus2") # Load API dataset
apiclus2[!, :pw] = fill(757 / 15, (size(apiclus2, 1),)) # Correct api mistake for pw column
dclus2 = SurveyDesign(apiclus2; clusters = :dnum, weights = :pw) # Create SurveyDesign
dclus2_boot = dclus2 |> bootweights # Create replicate design

# Stratified sample
apistrat = load_data("apistrat") # Load API dataset
dstrat = SurveyDesign(apistrat; strata = :stype, weights = :pw) # Create SurveyDesign
dstrat_boot = dstrat |> bootweights # Create replicate design

@testset "Survey.jl" begin
    @test size(load_data("apiclus1")) == (183, 40)
    @test size(load_data("apiclus2")) == (126, 41)
    @test size(load_data("apipop")) == ((6194, 38))
end

include("SurveyDesign.jl")
include("total.jl")
include("quantile.jl")
include("mean.jl")
include("plot.jl")
include("hist.jl")
include("boxplot.jl")
include("ratio.jl")
include("show.jl")
