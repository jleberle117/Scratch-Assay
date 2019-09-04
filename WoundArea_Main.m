% WOUND AREA SCRIPT FOR RUNNING MULTIPLE IMAGES
%
% CODE REQUIRES MATLAB'S IMAGE ANALYSIS TOOLBOX
%
% SCRIPT IS CURRENTLY OPTIMIZED FOR IMAGING FIBROBLASTS AT 100X MAGNIFICATION
%
% IMAGE TIMES MUST BE DONE AT EQUAL TIME INTERVALS AND SAVED USING THE WELL
% NAME FOR EACH TIME POINT (SEE BELOW)
%
% SCRIPT CURRENTLY ONLY CONFIGURED TO READ IN .jpg IMAGES
%
% Images need not be in the same folder as the scripts but must be a
% complete path to the scratch parent folder. Images must be saved as the 
% well name at each time point and saved as follows:
% Master_Folder\Plate_Number\Time_Point\Well_Name
% For example: Sept03 Scratch\Plate 1\4 hour\2a
% where 2a corresponds to the image taken of well 2a, on Plate 1, at the 4
% hour time point



% clear existing data
clear; clc;

%% Set image locations
% Values below for Parent, Plate, Time Point, an Well_Name are generic and
% can be customized to fit the users needs. Simply change the wording below
% to reflect the users needs. The number of inputs can be added to or taken
% away as needed. ALL OTHER ASPECTS OF THE CODE SHOULD REMAIN UNCHANGED

% Parent is the file path to Master_Folder
Parent = 'G:\My Drive\Scratch Assay\Sept03 Scratch';

% List plates separated by commas. Be sure to use the exact wording used in
% the file folders
Plate = {'Plate 1', 'Plate 2', 'Plate 3'};

% List the time points at which the images were taken, separated by commas,
% exactly as the folders are labeled.
Time_Point = {'0 hour', '4 hour', '8 hour', '12 hour', '16 hour', '20 hour', '24 hour'};

% List the well names separated by commas (image names) exactly as they are
% saved, without the file type
Well_Name = {'1a', '1b', '1c', '2a', '2b', '2c', '3a', '3b', '3c', '4a', '4b', '4c'};

% enter the amount of time (in hours) between images
dt=4;

%% Set processing parameters
% The processing parameters below can be adjusted per the user's needs but
% should be done with caution. The parameters are currently optimized for
% the image specifications and cell type described above.

% SE_Size is used as r in strel('disk',r,n) creates a disk-shaped structuring element, where r specifies the radius.
% n specifies the number of line structuring elements used to approximate the disk shape. 
% Morphological operations using disk approximations run much faster when the structuring element uses approximations
% has to do with image filtering, see
% https://www.mathworks.com/help/images/ref/imbothat.html for details
SE_Size = 13; % r in above description


% Thresh is used as level in im2bw(I,level) converts the grayscale image I to binary image BW, by replacing all pixels in the input image with 
% luminance greater than level with the value 1 (white) and replacing all other pixels with the value 0 (black).This range is relative 
% to the signal levels possible for the image's class. Therefore, a level value of 0.5 corresponds to an intensity value halfway 
% between the minimum and maximum value of the class.
Thresh = 0.15;

% Holes ratio defines the size of islands and holes to get rid of with
% respect to the largest mass in the image
Holes_Ratio = 0.25;

%% CONTINUE CODE
a = length(Plate);
b = length(Time_Point);
c = length(Well_Name);


T=cell(a*b*c+1,8);
T(1,1:8)={'Plate', 'Time Point', 'Well Name', 'AVG', 'STDEV', 'Time', 'Percent Closed', 'Area Under Curve'};
count=2;

area_0=zeros(a,c);
int=zeros(1,c);
lastpt=zeros(1,c);

for g = 1:a % Plate
    for h = 1:b % Time Point
        for i = 1:c % Well Name
            t = cputime;
            [avg, stdev] = Wound_Area(Parent, Plate{g}, Time_Point{h}, Well_Name{i}, SE_Size, Thresh, Holes_Ratio);
            if strcmp(Time_Point{h},'0 hour')==1
                area_0(g,i)=avg;
                int(i)=0;
                lastpt(i)=0;
            end
            A0=area_0(g,i);    
            per_close=(A0-avg)*100/A0;

            int(i)=int(i)+lastpt(i)*dt+0.5*(per_close-lastpt(i))*dt;

            lastpt(i)=per_close;
            Time = cputime - t;
            T(count,1:8)={g, (h-1)*dt, Well_Name{i}, avg, stdev, Time, per_close, int(i)};
            count=count+1;
        end
    end
end 
% convert the compiled cell to a table
T=cell2table(T);
% write the table to a csv file
writetable(T,'Scratch Assay.csv');


fclose('all');