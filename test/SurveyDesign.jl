@testset "SurveyDesign.jl" begin
    ##### SimpleRandomSample tests
    # Load API datasets
    apisrs_original   = load_data("apisrs")
    apistrat_original = load_data("apistrat")
    apiclus1_original = load_data("apiclus1")
    apiclus2_original = load_data("apiclus2")
    # Work on copy, keep original
    apisrs   = copy(apisrs_original)
    apistrat = copy(apistrat_original)
    apiclus1 = copy(apiclus1_original)
    apiclus2 = copy(apiclus2_original)

    srs = SimpleRandomSample(apisrs, popsize = apisrs.fpc)
    @test srs.data.weights == 1 ./ srs.data.probs # weights should be inverse of probs
    @test srs.sampsize > 0

    srs_freq = SimpleRandomSample(apisrs; popsize = apisrs.fpc , weights = fill(0.3, size(apisrs_original, 1)))
    @test srs_freq.data.weights[1] == 30.97
    @test srs_freq.data.weights == 1 ./ srs_freq.data.probs

    ##### TODO: needs change; this works but isn't what the user is expecting
    srs_prob = SimpleRandomSample(apisrs; probs = fill(0.3, size(apisrs_original, 1)))
    @test srs_prob.data.probs[1] == 0.3

    # TODO: StratifiedSample tests
    # ... @sayantika @iulia @shikhar
    # apistrat examples from R, check the main if-else cases

    # Test with probs = , weight = , and popsize = arguments, as vectors and sybols

    ##### SurveyDesign tests
    
    # Case 1: Simple Random Sample

    # Case 1b: SRS 'with replacement' approximation ie ignorefpc = true

    # Case 2: Stratified Random Sample
    # strat_design = SurveyDesign(apistrat,strata = :stype, popsize =:fpc, ignorefpc = false)

    # Case: Arbitrary weights

    # Case: One-stage cluster sampling, no strata

    # Case: One-stage cluster sampling, with one-stage strata

    # Case: Two cluster, two strata
    
    # Case: Multi stage stratified design
end
