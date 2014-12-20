function [ output ] = pooling( input, pdim_x, pdim_y, pooling_method )
% Pooling / sub-sampling
% input:
%       input:          input image
%       pdim_x:         horizontal pooling dimension
%       pdim_y:         vertical pooling dimension
%       pooling_method: there are currently 3 methods to choose
%                       max:        choose max pixel value
%                       mean:       choose average pixel value
%                       simple:     choose first value
%                       imresize:   using matlab imresize method
% output:
%       output:         sub-sampled image
%
    if strcmp(pooling_method, 'imresize') == true
        output = imresize(input, 1 ./ pdim_x);
        return; 
    end
    image = input;
    [height, width] = size(image);
    if height < pdim_y && width < pdim_x
       output = input;
       return;
    end
    if height < pdim_y pdim_y = 1; end
    if width < pdim_x pdim_x = 1; end
    remY = rem(height, pdim_y);
    remX = rem(width, pdim_x);
    if remX ~= 0
       image = image(:, ceil(remX / 2) + 1 : width - floor(remX / 2)); 
    end
    if remY ~= 0
       image = image(ceil(remY / 2) + 1 : height - floor(remY / 2), :); 
    end
    [height, width] = size(image);
    output = zeros(height / pdim_y, width / pdim_x);
    [height, width] = size(output);
 
    for i = 1 : height
        for j = 1 : width
           tmp = image((i - 1) * pdim_y + 1: i * pdim_y, ...
                       (j - 1) * pdim_x + 1: j * pdim_x);
           if strcmp(pooling_method, 'max') == true
              output(i, j) = max(tmp(:));
           elseif strcmp(pooling_method, 'mean') == true
              output(i, j) = mean(tmp(:));
           else
              output(i, j) = tmp(1, 1);
           end    
        end
    end
end

