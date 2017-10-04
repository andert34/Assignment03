%% CEC495A
clear all; clc; close all;

Irgb = imread('impellers/rotor10.jpg');
Ihsv = rgb2hsv(Irgb);
I = Ihsv(:,:,3);
BW = edge(I,'canny',[0.1 0.5],0.7);

SE1 = strel('line',4,90);
SE2 = strel('line',4,0);

BW = imdilate(BW,[SE1 SE2]);

BW = imfill(BW,'holes');
imshow(BW);

% Find and plot bounding box

[labels,number] = bwlabel(BW,8);
Istats = regionprops(labels,'basic','Centroid');

[maxVal, maxIndex] = max([Istats.Area]);

rectangle('Position',[Istats(maxIndex).BoundingBox],'LineWidth',2,'EdgeColor','g');

center = [Istats(maxIndex).BoundingBox(1) + Istats(maxIndex).BoundingBox(3)/2, Istats(maxIndex).BoundingBox(2) + Istats(maxIndex).BoundingBox(4)/2];
radius = max(Istats(maxIndex).BoundingBox(3)/2, Istats(maxIndex).BoundingBox(4)/2);
hold on
plot(center(1),center(2),'r*');
viscircles(center,radius);

blade = 0;
gap = 0;

for x = 1:1:480
    for y = 1:1:480
        if hypot(abs(center(1) - x), abs(center(2) - y)) < radius
            if BW(x,y) == 1
                blade = blade + 1;
            else
                gap = gap + 1;
            end
        end
    end
end

disp(blade);
disp(gap);
ratio = gap / blade;
disp(ratio);