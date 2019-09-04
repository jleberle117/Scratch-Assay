function [avg, stdev] = Wound_Area(Parent, Plate, Time_Point, Well_Name, SE_Size, Thresh, Holes_Ratio)
% Function WOUND_AREA executes morphological operators, spatial filters,
% and texture operators on the image, and it returns a 1x2 array with open 
% area average value and standard deviation. 
% 
% DO NOT ALTER THIS CODE


% Set file storage locations
Well = strcat(Well_Name, '.jpg');
Source = [Parent filesep Plate filesep Time_Point filesep Well];

Treatment_Results = strcat('RESULTS_', Time_Point);
Treat_Destination = [Parent filesep Plate filesep Time_Point filesep Treatment_Results];

Well_Results = strcat('RESULTS_', Well_Name, '_', num2str(SE_Size), 'se_', num2str(Thresh), 'th_', num2str(Holes_Ratio), 'hr.jpg');
Well_Destination = [Parent filesep Plate filesep Time_Point filesep Treatment_Results filesep Well_Results];

% Create save location if necessary
if exist(Treat_Destination, 'dir') ~= 7
    mkdir(Treat_Destination);
end

% Read image from source
Image1 = imread(Source);
Image = Image1;

% Convert image to grayscale and double precision
if size(Image, 3) == 1
    Image = im2double(Image);
else
    Image = im2double(rgb2gray(Image));
end

Image2 = imadjust(Image);% saturates bottom and top 1% of grayscale
Image = squeeze(Image2);% removes singleton dimension (matrix of 2x1x3 ==> 2x3)

% Apply median filter to remove noise
temp = medfilt2(Image);% gives up some sharpness to get rid of noise

% Create flat disk-shaped structural element
SE = strel('disk', SE_Size, 0);% create structure element for use in top and bot hat filtering (needs to be roughly the size and shape of structures in the image)

% Top- and Bottom-hat filtering
bot_temp = imbothat(temp, SE);% makes black areas darker (washes out the white)
top_temp = imtophat(temp, SE);% makes white areas whiter (washes out the black)

% Sharpen filtered images
bot_temp = imadjust(bot_temp);% re-saturate upper and lower 1% of bottom hat filtered image
top_temp = imadjust(top_temp);% re-saturate upper and lower 1% top hat filtered image

% Morphologically close image to fill gaps
temp_bot = imclose(bot_temp, SE);% closes gaps between cells in bottom hat filtered image
temp_top = imclose(top_temp, SE);% closes gaps between cells in top hat filtered image

% Threshold image
temp_bot = im2bw(temp_bot, Thresh);% convert bottom hat grayscale image to binary (B&W) image
temp_top = im2bw(temp_top, Thresh);% convert top hat grayscale image to binary (B&W) image

%% Check for islands and holes
filled_bot = Islands_Holes(temp_bot, Holes_Ratio);
filled_top = Islands_Holes(temp_top, Holes_Ratio);

% Calculate image area
dim = size(Image); % [rows columns]

tot = dim(1) * dim(2);

% Invert image to find wound area
areaUP = sum(sum((filled_top)))/tot;
areaDOWN = sum(sum((filled_bot)))/tot;

%areaUP = 1 - sum(sum((temp_top)))/tot;
%areaDOWN = 1 - sum(sum((temp_bot)))/tot;

% X = [areaUP areaDOWN];

X = [filled_top filled_bot];

rows=randi([1 dim(1)], 30, 1);
w_width=zeros(2*length(rows),1);


filled_top=double(filled_top);
filled_bot=double(filled_bot);
for j =1:length(rows)
    measurements = regionprops(logical(filled_top(rows(j),:)), 'Area');
    if isempty(cell2mat(struct2cell((measurements))))==1
        w_width(j,1)=0;
    else
        w_width(j,1) = max([measurements.Area]);
    end
    measurements = regionprops(logical(filled_bot(rows(j),:)), 'Area');
    if isempty(cell2mat(struct2cell((measurements))))==1
        w_width(j,1)=0;
    else
        w_width(j,1) = max([measurements.Area]);
    end
    w_width(length(rows)+j,1) = max([measurements.Area]);
end


% Calculate average and standard deviation
stdev = std(w_width);
avg = mean(w_width);

% Outputs
% stdev = stdev';
% avg = avg';

% Display images
f=figure('visible','off');
subplot(3,2,1)
imshow(Image1)
title('Original Image')

subplot(3,2,2)
imshow(Image2)
title('Sharpened B&W Image')

subplot(3,2,3)
imshow(temp_bot)
title('Bottom-Hat Filter')

subplot(3,2,4)
imshow(temp_top)
title('Top-Hat Filter')

subplot(3,2,5)
imshow(filled_bot)
title('Filled Bottom-Hat')

subplot(3,2,6)
imshow(filled_top)
title('Filled Top-Hat')

saveas(gcf, Well_Destination, 'jpeg');

close all;

end