function scattered_features = get_scattered_features_vectors(img, kSample, layernum)

    %% parameters setting.
    vert = 35;
    hori = 35;
    k = kSample;
    % pooling method could be mean/max/simple/imresize
    pooling_method = 'imresize';

    %% 0th layer.
    sigma = 6;
    gaussian = gaussian_2d(hori, vert, sigma);
    conved = conv2(img, gaussian, 'same');
    pooled = pooling(conved, 2 ^ k, 2 ^ k, pooling_method);
    output_layer_0 = pooled;

    %% 1st layer.
    sigma = [1 3 6];
    theta = [0 pi/6 pi/3 pi/2 2*pi/3 5*pi/6];
    output_layer_1 = scattered_network_layer( img, sigma, theta, k,...
                                      hori, vert, 1, pooling_method );     

    %% 2nd layer.
    if layernum == 3
        sigma = 6;
        theta = [0 pi/6 pi/3 pi/2 2*pi/3 5*pi/6];
        output_layer_2 = scattered_network_layer( output_layer_1, sigma, theta, k,...
                                          hori, vert, 1, pooling_method );
    end
    %% reshape images into cell.
    vector_size = 19;
    if layernum == 3
        % vector_size = how many vectors should it be?
    end
    scattered_features = cell(1, vector_size);
    scattered_features{1, 1} = output_layer_0;
    for i = 2 : 19
        scattered_features{1, i} = output_layer_1(:, :, i - 1);
    end
    if layernum == 3
       % put the third layer vectors into cell
    end
end

