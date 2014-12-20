function [psi] = morlet_2d(hori, vert, theta, sigma, npeaks)
% 2d morlet kernel generator
% input:
%       hori:   horizontal grid point amount
%       vert:   vertical grid point amount
%       theta:  theta
%       sigma:  controls the size of the kernel
%       npeaks: number of significant peaks appearing in the kernel     
% output:
%       psi: a 2d Morlet wavelet kernel (psi is complex)
    xi = 1 / npeaks * 4 * sigma;
    % 3 * sigma for each side
    %width = 6 * sigma;
    width = 18;
    height = width;
    x = linspace(- width / 2, width / 2, hori);
    y = linspace(- height / 2, height / 2, vert);
    [X, Y] = meshgrid(x, y);
    
    ue0 = X * cos(theta) + Y * sin(theta);
    u2 = X .^ 2 + Y .^ 2;
    k1 = exp(1i * 2 * pi / xi * ue0);
    k2 = exp(-0.5 * u2 / (sigma ^ 2));
    
    % get C2 (zero mean)
    C2 = sum(sum(k1 .* k2)) ./ sum(k2(:)); 
    % get C1 (one norm)
    tmp = (k1 - C2) .* k2;
    product = tmp .* conj(tmp);
    C1 = 1 ./ sum(product(:)) ^ 0.5;
    C1 = C1 .* sigma;
    % result
    psi = C1 / sigma * (k1 - C2) .* k2;
end
