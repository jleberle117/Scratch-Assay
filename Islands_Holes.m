function BW_IM = Islands_Holes(Image, size)
% Islands_Holes assesses each image for cell masses in the mock wound area
% and holes within the cell mass outside of the mock wound. Holes are filled
% if the ratio of the hole to largest cell mass is less than the Holes_Ratio
% found in Script_WoundArea. Conversely, islands are removed if the island
% to largest void area is less than the Holes_Ratio.
% 
% DO NOT ALTER THIS CODE
%% Check for islands

[L_island, n] = bwlabel(Image);% finds the interconnected white 'chunks' (L_island) and the number of them (n)

% Pre-allocate area matrix
areas = zeros(1,n);

% Estimate area for each object in the image
for i = 1:n
    areas(i) = bwarea(L_island == i);
end

% Identify largest object in the image
Max_i = max(areas);

% Multiply by hole ratio & round down
P_i = floor(Max_i * size);

% Remove all objects smaller than P_i
IM_Island = bwareaopen(L_island, P_i);


%% Check for holes

% Invert black & white
[L_hole, n1] = bwlabel(imcomplement(IM_Island));

% Pre-allocate area matrix
areas_h = zeros(1,n1);

% If holes exist, estimate area for each object in the inverted image
if n1 ~= 0
    for i = 1:n1
        areas_h(i) = bwarea(L_hole == i);
    end
    
    % Identify largest object in the inverted image
    M_h = max(areas_h);
    
    % Multiply by hole ratio & round down
    P_h = floor(M_h * size);
    
    % Remove objects smaller than P_h, output inverted image
    BW_IM = bwareaopen(L_hole, P_h);

% If holes do not exist, output processed image from "Check for Islands"    
elseif n1 == 0
    BW_IM = L_hole;
end

end
