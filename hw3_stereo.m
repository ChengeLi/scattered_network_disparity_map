% function disparity_map=stereo_from_scatter_network(img_left,img_right)

clear 
clc
close all
%% scatter network
% load scatter_vectors_full.mat; % 1*19 cell (1920*2820)
isdownsample=0;
left_vector_full=loop(img_left,isdownsample);
right_vector_full=loop(img_right,isdownsample);



%% Final project (17th Dec):
matching_error_black=cell(60,1);
matching_error_black=get_matching_cost(img_left,left_vector_full,right_vector_full);

% % % save matching_error_black.mat matching_error_black;
% % load matching_error_black.mat ;

img_left_small=imresize(img_left,[60 88]);
img_right_small=imresize(img_right,[60 88]);
contrast_left=zeros(60,87);
contrast_left=abs(img_left_small(:,1:end-1)-img_left_small(:,2:end));
contrast_right=zeros(60,87);
contrast_right=abs(img_right_small(:,1:end-1)-img_right_small(:,2:end));


%%
disparity=zeros(60,88);
flow=zeros(60,1);
for k=1:60  % row by row
% matching_error_normalized=normalize_matching_error(matching_error_black{23,1}); % % normalize the error
matching_error=matching_error_black{k,1};
matching_error_normalized=matching_error;
[disparity(k,:),flow(k)]=final_graph_cut(matching_error_normalized,contrast_left(k,:),contrast_right(k,:),k);

end

disparity2=disparity;
[occlu_r,occlu_c]=find(disparity2==23444);

disparity2(disparity2==23444)=1;
disparity2(disparity2>0) = disparity2(disparity2>0)*32;

disparity2(disparity2>250)=250;

occlusion=ones(size(disparity));
% figure;
% imagesc(disparity2); hold on; 
% title('disparity map /200','fonts',18); 






