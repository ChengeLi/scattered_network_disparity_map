function [G] = gaussian_2d(hori, vert, sigma)
% 2d Gaussian kernel generator
% input:
%       hori:   horizontal grid point amount
%       vert:   vertical grid point amount
%       sigma:  sigma
% output:
%       G: a 2d Gaussian kernel
%
    width = sigma * 6;
    height = width;
    x = linspace(- width / 2, width / 2, hori);
    y = linspace(- height / 2, height / 2, vert);
    [X, Y] = meshgrid(x, y);
    u2 = X .^ 2 + Y .^ 2;
    G = exp(-0.5 * u2 / (sigma .^ 2)); 
    G = G ./ (sigma .* ((2 * pi) .^ 0.5));
end

