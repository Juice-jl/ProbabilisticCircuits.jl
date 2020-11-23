using Test
using LogicCircuits
using ProbabilisticCircuits
using DataFrames


function test_expectation_brute_force(pc::ProbCircuit, lc::LogisticCircuit, data, CLASSES::Int)
    EPS = 1e-4;
    COUNT = size(data)[1]
    # Compute True expectation brute force
    true_exp = zeros(COUNT, CLASSES)
    for i in 1:COUNT
        row = Array(data[i, :])
        cur_data_all = generate_all(row)

        calc_p = log_likelihood_per_instance(pc, cur_data_all)
        calc_p = exp.(calc_p)

        calc_f = class_weights_per_instance(lc, CLASSES, cur_data_all)
        true_exp[i, :] = sum(calc_p .* calc_f, dims=1)
        true_exp[i, :] ./= sum(calc_p) #p_observed
    end
    # Compute Circuit Expect
    calc_exp, cache = Expectation(pc, lc, data);
    for i = 1:COUNT
        for j = 1:CLASSES
            @test true_exp[i,j] ≈ calc_exp[i,j] atol= EPS;
        end
    end    
    # Compute Bottom Up Expectation
    calc_exp_2, exp_flow = ExpectationUpward(pc, lc, data);
    for i = 1:COUNT
        for j = 1:CLASSES
            @test true_exp[i,j] ≈ calc_exp_2[i,j] atol= EPS;
        end
    end
end

function test_moment_brute_force(pc::ProbCircuit, lc::LogisticCircuit, data, CLASSES::Int, moment::Int)
    EPS = 1e-4;
    COUNT = size(data)[1]
    # Compute True moment brute force
    true_mom = zeros(COUNT, CLASSES)
    for i in 1:COUNT
        row = Vector(data[i, :])
        cur_data_all = generate_all(row)

        calc_p = log_likelihood_per_instance(pc, cur_data_all)
        calc_p = exp.(calc_p)

        calc_f = class_weights_per_instance(lc, CLASSES, cur_data_all)
        true_mom[i, :] = sum(calc_p .* (calc_f .^ moment), dims=1)
        true_mom[i, :] ./= sum(calc_p) #p_observed
    end

    # Compute Circuit Moment
    calc_mom, cache = Moment(pc, lc, data, moment);
    for i = 1:COUNT
        for j = 1:CLASSES
            @test (true_mom[i,j] / (calc_mom[i,j] )) ≈ 1.0 atol= EPS;
        end
    end    
end


@testset "Expectation Brute Force Test" begin
    #  Small (4 Var)
    psdd_file       = "little_4var.psdd"
    logistic_file   = "little_4var.circuit"
    CLASSES = 2
    N = 4

    pc = zoo_psdd(psdd_file);
    lc = zoo_lc(logistic_file, CLASSES);
    data = DataFrame([0 0 0 0; 
            0 1 1 0; 
            0 0 1 1;
            missing missing missing missing;
            missing 0 1 missing;
            0 1 missing 1;
            1 missing 0 missing;
            missing 0 1 missing;
            missing missing 0 1;
            missing missing missing 1;
            missing missing missing 0;
            ])

    test_expectation_brute_force(pc, lc, data, CLASSES)

    # Big circuit (15 Var)
    psdd_file       = "exp-D15-N1000-C4.psdd"
    logistic_file   = "exp-D15-N1000-C4.circuit"
    CLASSES = 4
    N = 15
    COUNT = 10

    pc = zoo_psdd(psdd_file);
    lc = zoo_lc(logistic_file, CLASSES);
    data = DataFrame(rand( (missing,true,false), (COUNT, N) ))
    
    test_expectation_brute_force(pc, lc, data, CLASSES)
end


@testset "Moment Brute Force Test" begin
    # Small (4 Var)
    psdd_file       = "little_4var.psdd"
    logistic_file   = "little_4var.circuit";
    CLASSES = 2
    N = 4
    COUNT = 100

    pc = zoo_psdd(psdd_file);
    lc = zoo_lc(logistic_file, CLASSES);
    data = DataFrame(rand( (missing,true,false), (COUNT, N) ))

    test_moment_brute_force(pc, lc, data, CLASSES, 1)
    test_moment_brute_force(pc, lc, data, CLASSES, 2)
    test_moment_brute_force(pc, lc, data, CLASSES, 3)
    test_moment_brute_force(pc, lc, data, CLASSES, 4)
    test_moment_brute_force(pc, lc, data, CLASSES, 10)
    test_moment_brute_force(pc, lc, data, CLASSES, 15)

    # Big Var
    psdd_file       = "exp-D15-N1000-C4.psdd"
    logistic_file   = "exp-D15-N1000-C4.circuit";
    CLASSES = 4
    N = 15
    COUNT = 10

    pc = zoo_psdd(psdd_file);
    lc = zoo_lc(logistic_file, CLASSES);
    data = DataFrame(rand( (missing,true,false), (COUNT, N) ))

    test_moment_brute_force(pc, lc, data, CLASSES, 1)
    test_moment_brute_force(pc, lc, data, CLASSES, 2)
    test_moment_brute_force(pc, lc, data, CLASSES, 3)
    test_moment_brute_force(pc, lc, data, CLASSES, 4)
    test_moment_brute_force(pc, lc, data, CLASSES, 10)
    test_moment_brute_force(pc, lc, data, CLASSES, 15)
end