function [ output ] = scattered_network_layer( input, sigma, theta, k,...
                                            hori, vert, npeaks, pooling_method )
% Build one layer of scattered network
% inputs:
%       input:          input image (if multi-images, just use 3rd dimension)
%       theta:          theta
%       sigma:          controls the size of the kernel
%       k:              parameter uses in pooling process
%       hori:           horizontal grid point amount
%       vert:           vertical grid point amount
%       npeaks:         number of significant peaks appearing in the kernel 
%       pooling_method: there are currently 3 methods to choose
%                       max:    choose max pixel value
%                       mean:   choose average pixel value
%                       simple: choose first value
% output:
%       output:         one layer of scattered network
%
    % if the input image has too small size, the results after convolution
    % maybe wierd, so do nothing and return.
    %{
    if size(input, 1) < vert || size(input, 2) < hori
        fprintf('Input images are too small...\n');
        output = input;
        return;
    end
    %}
    % use 6 as the sigma of gaussian kernels.
    gaussian = gaussian_2d(hori, vert, 6);
    counter = 1;
    for s = 1 : size(input, 3)
        image = input(:, :, s);
        for i = 1 : size(sigma, 2)
            for j = 1 : size(theta, 2)
                psi = morlet_2d(hori, vert, theta(j), sigma(i), npeaks);
                re = conv2(image, real(psi), 'same');
                im = conv2(image, imag(psi), 'same');
                magnitude = (re .^ 2.0 + im .^ 2.0) .^ 0.5;
                conved = conv2(magnitude, gaussian, 'same');
                pooled = pooling(conved, 2 ^ k, 2 ^ k, pooling_method);  
                output(:, :, counter) = pooled; 
                counter = counter + 1;
            end
        end
    end
end

