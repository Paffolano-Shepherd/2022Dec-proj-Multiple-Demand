function summation = m_second(ds, alpha, beta)
    % given guess of individual mean utilities and parameters
    % construct second moments

    % ds: N*1
    % alpha: 1*1
    % beta: 5*1
    % c: 1*1

    global iv df;
    xi = ds - alpha * df(:, 5) - df(:, 6:10) * beta;

    summation = sum(mean(xi .* iv).^2);
end