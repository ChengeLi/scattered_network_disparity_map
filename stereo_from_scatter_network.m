clc;
clear all;
close all;
%% read image
img_left = imread('im0.png');
img_right = imread('im1.png');
img_left = double(rgb2gray(img_left));  % 0~255
img_right = double(rgb2gray(img_right));
[height, width] = size(img_left);

%% scatter network
% load scatter_vectors_full.mat; % 1*19 cell (1920*2820)
kSample = 3;
nLayer = 2;
left_feature_vector = get_scattered_features_vectors(img_left, 0, nLayer);
right_feature_vector = get_scattered_features_vectors(img_right, 0, nLayer);
%isdownsample = 0;
%left_feature_vector = loop(img_left,isdownsample);
%right_feature_vector = loop(img_right,isdownsample);
% get scattered network errors
matching_error_black = get_matching_cost(img_left, left_feature_vector, right_feature_vector, kSample);

%% down-sampling and get contrast values
template_size = 2 ^ kSample;
new_width = floor(width / template_size);
new_height = floor(height / template_size);
img_left_small = imresize(img_left, [new_height, new_width]);
img_right_small = imresize(img_right, [new_height, new_width]);
% contrust
contrast_left = abs(img_left_small(:, 1 : end - 1) - img_left_small(:, 2 : end));
contrast_right = abs(img_right_small(:, 1 : end - 1) - img_right_small(:, 2 : end));

%% maxflow mincut
disparity = zeros(new_height, new_width);
flow = zeros(new_height, 1);
for k = 1 : new_height  % row by row
% matching_error_normalized=normalize_matching_error(matching_error_black{23,1}); % % normalize the error
    matching_error = matching_error_black{k, 1};
    disp(['Building graph: ', num2str(k)]);
    [disparity(k, :), flow(k)] = graph_cut_by_line(matching_error, contrast_left(k, :), contrast_right(k, :));
end

%% Display disparity map
%[occlu_r,occlu_c]=find(disparity == inf);
disparity_show = disparity;
disparity_show(disparity_show == inf) = -1;
disparity_show(disparity_show > 0) = disparity_show(disparity_show > 0) * template_size;
disparity_show(disparity_show > 250) = 250;
occlusion = ones(size(disparity_show));
figure;
imagesc(disparity_show); 

%}




