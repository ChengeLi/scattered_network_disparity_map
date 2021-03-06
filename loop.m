function scattered_features=loop(I,isdownsample)
% % generate 19 vectors from the scatter network  (zero layer and first layer)

if size(I,3)==3
    I=rgb2gray(I);
end
%(not downsample)
% % min_dim=min(size(I,1),size(I,2));
% % n = floor(log(min_dim)/log(2));
% % I = imresize(I,[2^n 2^n]);

I=double(I)/255;

%% 0th layer
blurred_I=GaussianBlur(6,I);

% % downsample

k=5;%(32*32 template)
if isdownsample==1
    zerolyer_I = imresize(blurred_I, 2^(-k));
else zerolyer_I=blurred_I;
end
% figure;
% imagesc(zerolyer_I); title('zero layer');
% colormap('gray');
% saveas(gcf,'zero layer','jpeg');

%% other layers
result=cell(1,18); 
result{1,1}=scatterNetwork(0,1,I,isdownsample);
result{2}=scatterNetwork(pi/6,1,I,isdownsample); 
result{3}= scatterNetwork(pi/3,1,I,isdownsample);
result{4}=scatterNetwork(pi/2,1,I,isdownsample);
result{5}= scatterNetwork(2*pi/3,1,I,isdownsample);
result{6}= scatterNetwork(5*pi/6,1,I,isdownsample);

result{7}= scatterNetwork(0,3,I,isdownsample);
 result{8}=scatterNetwork(pi/6,3,I,isdownsample); 
 result{9}=scatterNetwork(pi/3,3,I,isdownsample);
 result{10}=scatterNetwork(pi/2,3,I,isdownsample);
 result{11}=scatterNetwork(2*pi/3,3,I,isdownsample);
 result{12}=scatterNetwork(5*pi/6,3,I,isdownsample);
 
 result{13}=scatterNetwork(0,6,I,isdownsample);
 result{14}=scatterNetwork(pi/6,6,I,isdownsample); 
 result{15}=scatterNetwork(pi/3,6,I,isdownsample);
 result{16}=scatterNetwork(pi/2,6,I,isdownsample);
 result{17}=scatterNetwork(2*pi/3,6,I,isdownsample);
 result{18}=scatterNetwork(5*pi/6,6,I,isdownsample);
 
 scattered_features = cell(1,19);
 scattered_features{1,1} = zerolyer_I;
 for i=2:19
     scattered_features{1,i}=result{1,i-1};
 end
 
 
 
  
 
 
 
 
 
 
 