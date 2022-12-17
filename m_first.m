function summation = m_first(ds, nu)
    % given guess of individual mean utilities and complementarity
    % construct first moments

    % ds: N*1
    % nu: 1*1
    
    global df N T;
    s_pred = zeros(N, 1);
    
    for t = 1:T
        ds_t = ds(df(:, 4) == t);
        J_t = size(ds_t, 1);
        s_tilde = zeros(J_t, 1);
        
        e_sum = sum(exp(ds_t));
        e_nu = exp(nu);
        for j = 1:J_t
            e_j = exp(ds_t(j));
            s_tilde(j) = e_j + e_j * e_nu * (e_sum - e_j);
        end
        s_pred(df(:, 4) == t) = s_tilde / (1 + sum(s_tilde));
    end
    
    % scale by 100 for 1e-3 accuracy
    summation = 100 * sum((s_pred - df(:, 11)).^2);
end