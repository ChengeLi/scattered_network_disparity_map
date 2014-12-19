function mu = get_penalty_val(matching_err, contrast)


    contrast = contrast / max(contrast);
    mu = (1 - contrast);

    [nelements, xcenters] = hist(matching_err(:), 100);
    cumulative_hist = cumsum(nelements);
    lower_bound = 1;
    for i = 1 : length(cumulative_hist)
        energy = cumulative_hist(i) / cumulative_hist(end);
        if energy <= 0.05
            lower_bound = xcenters(i);
        elseif energy >= 0.8
            thresh_from_black = xcenters(i);
            break;
        end
    end
    mu = mu / max(mu) * thresh_from_black;
    mu = max(mu, lower_bound) / 200;   % little gray is between lower_bound and thresh_from_black
end






