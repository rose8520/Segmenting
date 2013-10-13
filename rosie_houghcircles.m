
%% Capture images from kinect
% Kinect_images;

colorcalibrose_hough;

%% Detecting canny edges

% Read the image
RGB = imread('randomplate3.jpg');

%Scaling down image by 50%
RGB = imresize(RGB,0.5);

%Converting image to grayscale
gray = rgb2gray(RGB);

%Obtain a Gaussian kernal
K = fspecial('gaussian');

%Apply the gaussian filter
grayf = imfilter(gray,K);
grayf = imfilter(grayf,K);
grayf = imfilter(grayf,K);

%Performing canny edge (detecting edges)
E = edge(gray, 'canny');

% grayf = gray;

% imshow(E)

%% HOUGHCIRCLES

% imtool(grayf);

% Range dimensions of the plate
min_radius = 70;
max_radius = 110;

%Detect and show circles
circles = houghcircles(grayf, min_radius, max_radius);

%Calculate plate parameters (plate radius and plate x-y pos)
plate_radius = max(circles(:,3));

plate_xy=[];

for i=1:size(circles,1)
    if circles(i,3) == plate_radius
        plate_xy = [circles(i,1) circles(i,2)];
        break
    end
end

fprintf('The plate centre position is: (%d,%d)\r\n',plate_xy(1),plate_xy(2))


%Circles dimensions only within the plate area
min_radius = 6;
max_radius = 17;

%Detect and show circles within the plate area. 
circles = houghcircles(grayf, min_radius, max_radius,0.5);
houghcircles(grayf, min_radius, max_radius,0.5);


%% Printing the number of coins within plate

valid_circles = [];

for k=1:size(circles,1)
    if circles(k,1) < (plate_xy(1)+plate_radius) && circles(k,1) > (plate_xy(1)-plate_radius)
        if circles(k,2) < (plate_xy(2)+plate_radius) && circles(k,2) > (plate_xy(2)-plate_radius)
            valid_circles = [valid_circles; circles(k,1),circles(k,2),circles(k,3)];
        end
    end
end


fprintf('There are %d coins\r\n',size(valid_circles,1))

valid_circles;

%% Printing the number of $2, $1, 50c, 20c, 10c and 5c. 


%%% FIX the coins radius and add RGB values%%%

no_1dollar = [];
dollar1posx=[];
dollar1posy=[];
% gold_threshold = 100;
% gold_cthreshold = 1;


for n=1:size(valid_circles,1)
    if valid_circles(n,3) >= 9 && valid_circles(n,3) <=11
       no_1dollar = [no_1dollar valid_circles(n,3)];
    end
end

% for n=1:size(valid_circles,1)
%     if valid_circles(n,3) >= 9 && valid_circles(n,3) <=11
%         Ratcircle = RGB(valid_circles(n,1),valid_circles(n,2),1);
%        Gatcircle = RGB(valid_circles(n,1),valid_circles(n,2),2);
%        Batcircle = RGB(valid_circles(n,1),valid_circles(n,2),3);
%        RGBatcircle = [Ratcircle Gatcircle Batcircle];
%        if Ratcircle(1) <= RGBValuesGold(1) + gold_threshold && Ratcircle(1) >= RGBValuesGold(1) - gold_threshold           
%             if Gatcircle(1) <= RGBValuesGold(2) + gold_threshold && Gatcircle(1) >= RGBValuesGold(2) - gold_threshold           
%                 if Batcircle(1) <= RGBValuesGold(3) + gold_threshold && Batcircle(1) >= RGBValuesGold(3) - gold_threshold          
%                     no_1dollar = [no_1dollar  valid_circles(n,3)];
%                     dollar1posx= [dollar1posx valid_circles(n,1)];
%                     dollar1posy = [dollar1posy valid_circles(n,2)];
%                 end 
%             end
%        end
%     end
% end
no_1dollar ;

fprintf('There are %d $1 \r\n', size(no_1dollar,2))


no_2dollar = [];
dollar2posx=[];
dollar2posy=[];
gold_threshold = 80;
gold_cthreshold = 1;
for n=1:size(valid_circles,1)
    if valid_circles(n,3) <= min(valid_circles(:,3)) + gold_cthreshold && valid_circles(n,3) >= min(valid_circles(:,3)) - gold_cthreshold ; 
       Ratcircle = RGB(valid_circles(n,1),valid_circles(n,2),1);
       Gatcircle = RGB(valid_circles(n,1),valid_circles(n,2),2);
       Batcircle = RGB(valid_circles(n,1),valid_circles(n,2),3);
       RGBatcircle = [Ratcircle Gatcircle Batcircle];
       if Ratcircle(1) <= RGBValuesGold(1) + gold_threshold && Ratcircle(1) >= RGBValuesGold(1) - gold_threshold           
            if Gatcircle(1) <= RGBValuesGold(2) + gold_threshold && Gatcircle(1) >= RGBValuesGold(2) - gold_threshold           
                if Batcircle(1) <= RGBValuesGold(3) + gold_threshold && Batcircle(1) >= RGBValuesGold(3) - gold_threshold          
                    no_2dollar = [no_2dollar valid_circles(n,3)];
                    dollar2posx = [dollar2posx valid_circles(n,1)];
                    dollar2posy = [dollar2posy valid_circles(n,2)];
                end 
            end 
       end
    end
end
fprintf('There are %d $2 \r\n', size(no_2dollar,2))



no_50cent = [];

for n=1:size(valid_circles,1)
    if valid_circles(n,3) >= 14 && valid_circles(n,3) <=16
       no_50cent = [no_50cent valid_circles(n,3)];
    end
end
no_50cent;

fprintf('There are %d 50 cents \r\n', size(no_50cent,2))

no_20cent = [];
cent20posx=[];
cent20posy=[];
threshold = 100;
cthreshold = 1;
Rthreshold = 15;

for n=1:size(valid_circles,1)
    if valid_circles(n,3) >= 11 && valid_circles(n,3) <=14
       Ratcircle = RGB(valid_circles(n,1),valid_circles(n,2),1);
       Gatcircle = RGB(valid_circles(n,1),valid_circles(n,2),2);
       Batcircle = RGB(valid_circles(n,1),valid_circles(n,2),3);
       RGBatcircle = [Ratcircle Gatcircle Batcircle];
       if Ratcircle(1) <= RGBValuesGray(1) + threshold && Ratcircle(1) >= RGBValuesGray(1) - threshold           
            if Gatcircle(1) <= RGBValuesGray(2) + threshold && Gatcircle(1) >= RGBValuesGray(2) - threshold           
                if Batcircle(1) <= RGBValuesGray(3) + threshold && Batcircle(1) >= RGBValuesGray(3) - threshold           
                    if Ratcircle(1) > mean(RGBatcircle) + Rthreshold || Ratcircle(1) < mean(RGBatcircle) - Rthreshold ;
                        
                    elseif Gatcircle(1) > mean(RGBatcircle) + Rthreshold || Gatcircle(1) < mean(RGBatcircle) - Rthreshold ;
                            
                    elseif Batcircle(1) > mean(RGBatcircle) + Rthreshold || Batcircle(1) < mean(RGBatcircle) - Rthreshold ;
                                
                    else
                        no_20cent = [no_20cent valid_circles(n,3)];;
                        cent20posx = [cent20posx valid_circles(n,1)];
                        cent20posy = [cent20posy valid_circles(n,2)];
                    end
                end 
            end 
       end
    end
end
no_20cent;

fprintf('There are %d 20 cents \r\n', size(no_20cent,2))

no_10cent = [];

for n=1:size(valid_circles,1)
    if valid_circles(n,3) == 10; 
       no_10cent = [no_10cent valid_circles(n,3)];
    end
end
no_10cent;

fprintf('There are %d 10 cents \r\n', size(no_10cent,2))

no_5cent = [];
cent5posx=[];
cent5posy=[];
threshold = 100;
cthreshold = 1;
Rthreshold = 15;
for n=1:size(valid_circles,1)
    if valid_circles(n,3) <= min(valid_circles(:,3)) + cthreshold && valid_circles(n,3) >= min(valid_circles(:,3)) - cthreshold ; 
       Ratcircle = RGB(valid_circles(n,1),valid_circles(n,2),1);
       Gatcircle = RGB(valid_circles(n,1),valid_circles(n,2),2);
       Batcircle = RGB(valid_circles(n,1),valid_circles(n,2),3);
       RGBatcircle = [Ratcircle Gatcircle Batcircle];
       if Ratcircle(1) <= RGBValuesGray(1) + threshold && Ratcircle(1) >= RGBValuesGray(1) - threshold           
            if Gatcircle(1) <= RGBValuesGray(2) + threshold && Gatcircle(1) >= RGBValuesGray(2) - threshold           
                if Batcircle(1) <= RGBValuesGray(3) + threshold && Batcircle(1) >= RGBValuesGray(3) - threshold           
                    if Ratcircle(1) > mean(RGBatcircle) + Rthreshold || Ratcircle(1) < mean(RGBatcircle) - Rthreshold ;
                        
                    elseif Gatcircle(1) > mean(RGBatcircle) + Rthreshold || Gatcircle(1) < mean(RGBatcircle) - Rthreshold ;
                            
                    elseif Batcircle(1) > mean(RGBatcircle) + Rthreshold || Batcircle(1) < mean(RGBatcircle) - Rthreshold ;
                                
                    else
                        no_5cent = [no_5cent valid_circles(n,3)];
                        cent5posx = [cent5posx valid_circles(n,1)];
                        cent5posy = [cent5posy valid_circles(n,2)];
                    end
                end 
            end 
       end
    end
end
% no_5cent
% cent5posx
% cent5posy

fprintf('There are %d 5 cents \r\n', size(no_5cent,2))

% rosie_sift_featurematch