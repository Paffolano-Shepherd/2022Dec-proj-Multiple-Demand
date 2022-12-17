function solution = gmm(nu)
    % joint gmm to solve for parameters

    global df iv;

    options = optimoptions('fmincon', ...
        'MaxFunctionEvaluations', 1e8, 'MaxIterations', 1e4);
    prob.options = options;
    prob.solver = 'fmincon';
    prob.objective = @(ds) m_first(ds, nu);
    prob.x0 = log(df(:, 11)) - log(df(:, 12));

    [solution.ds, fval] = fmincon(prob);
    solution.nu = nu;

    coef = tsls(solution.ds, df(:, 5:10), iv);
    solution.alpha = coef(1);
    solution.beta = coef(2:6);
    solution.obj = [fval, m_second(solution.ds, solution.alpha, solution.beta)];
end
