function  disparity = path2disparity(labels, nPixel)
% map from left image to right image
    hascut = zeros(nPixel, 1);
    disparity = zeros(1, nPixel);
    for i = 1 : nPixel
        for j = 1 : nPixel
            idx_u = uv2node('u', i, j, nPixel, nPixel);
            idx_v = uv2node('v', i, j, nPixel, nPixel);
            if labels(idx_u) ~= labels(idx_v)
                hascut(i, 1) = 1;
                disparity(i) = i - j;
                break;
            end
        end
        if hascut(i, 1) == 0
            disparity(i) = inf; % this means occlusion!!
        end
    end
end











