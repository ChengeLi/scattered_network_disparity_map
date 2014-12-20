function  disparity = path2disparity(labels, nPixel)
% map from left image to right image
    cuthere = zeros(nPixel, nPixel);
    disparity = zeros(1, nPixel);
    for i = 1 : nPixel
        for j = 1 : nPixel
            idx_u = uv2node('u', i, j, nPixel, nPixel);
            idx_v = uv2node('v', i, j, nPixel, nPixel);
            if labels(idx_u) ~= labels(idx_v)
                cuthere(i, j) = 1;
                disparity(i) = i - j;
            end
        end
        if sum(cuthere(i,:)) == 0
            disparity(i) = inf; % this means occlusion!!
        elseif sum(cuthere(i, :)) > 1
            print error!
        end
    end
end











