function mu = get_penalty_val(matching_err, contrast)
% the penalty vals (little gray lines in figure) should be some 
% values that between good matches and very bad matches
%   input: 
%           matching_err: matching error got by scattered network
%           contrast    : pixel-wise contrast
%   output: penalty values
%
    contrast = contrast ./ max(contrast);
    mu = (1.0 - contrast);

    [nelements, xcenters] = hist(matching_err(:), 100);
    cumulative_hist = cumsum(nelements);
    lower_bound = xcenters(1);
    for i = 1 : length(cumulative_hist)
        energy = cumulative_hist(i) / cumulative_hist(end);
        if energy <= 0.05
            lower_bound = xcenters(i);
        elseif energy >= 0.8
            upper_bound = xcenters(i);
            break;
        end
    end
    mu = mu / max(mu) * upper_bound;
    mu = max(mu, lower_bound) / 200;  
end






