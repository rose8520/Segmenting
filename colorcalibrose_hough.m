%% Colour calibration CODE

%Clear off previous workspace
clear;
clc;
close all;

%Capture images off from kinect
% colorcalibrose_im;

%Read the images
im = imread('macbethchart25.jpg');
% im = imread('macbethcolorchart3.jpg');
im = flipdim(im,2); %Mirror flip the image

%% Load in test image and select chart

% Cropping tool for the image
% [squaresIm,cropRect] = imcrop(im);

squaresIm = im;
cropRect = [0 0 size(squaresIm,2) size(squaresIm,1)];
% close; subplot(2,2,1); imshow(squaresIm); title('Selected Region')

% Convert chart image to black and white

gray = rgb2gray(squaresIm);     % Convert to grayscale

J = histeq(gray);               % Equalize the histogram

threshold = graythresh(J);      % Threshold

bw = im2bw(J, threshold);       % Convert to B&W

% subplot(2,2,2); imshow(bw); title('Thresholded Region');

% Remove white pixels along the border, then dilate and erode to fill in
% solids.

bw2 = imclearborder(bw);
se = strel('square', 25);   
bw2 = imopen(bw2, se);
% subplot(2,2,3); imshow(bw2); title('Noise Removed');

%% Find all chart squares
% Automatically find the centroid of all unique objects in the image.

labeled = bwlabel(bw2); %Label connected components in 2-D binary image.

s = regionprops(labeled,'Centroid'); %Measure properties of image regions.

centroids = cat(1, s.Centroid); %Concatenate arrays.

% Use custom algorithm to find missing squares on the chart.
squareLocations = findAllChartSquares(centroids, squaresIm);

% subplot(2,2,4); displayChartSquares(squaresIm,squareLocations);

%To find the list of the centre of x and y - coord
centreofsquaresx=[];
centreofsquaresy=[];

for i=1:size(squareLocations,2)
    n=squareLocations(i);
    for k=1:size(n{1,1},1)
        x_coord = n{1,1}(k,1);
        y_coord = n{1,1}(k,2);
        centreofsquaresx = [centreofsquaresx x_coord];
        centreofsquaresy = [centreofsquaresy y_coord];
    end
end

%% Compare with reference color chart

%To obtain quantitative reading of the RGB values
squareMeans = getMeanForEachSquare(squaresIm, squareLocations);
chartSquares = getReferenceValues('chartValues.xls');

% Calculate the difference between the original image and reference values
RMS = calculateError(squareMeans, chartSquares);

% figure;
% subplot(2,1,1);imshow('colorChart.tif');title('Reference Chart')
% subplot(2,1,2);imshow(squaresIm);title(['Original Image, RMS=',num2str(RMS)])

%% Reducing the error with a white point adjustment

WP = adjustWP(squareMeans,chartSquares);

srgb2xyz = makecform('srgb2xyz');
xyz2srgb = makecform('xyz2srgb');

XYZin = applycform(squaresIm, srgb2xyz);
XYZout(:,:,1) = WP(1)* XYZin(:,:,1);    % scale the X plane
XYZout(:,:,2) = WP(2)* XYZin(:,:,2);    % scale the Y plane
XYZout(:,:,3) = WP(3)* XYZin(:,:,3);    % scale the Z plane

wp_squaresIm = im2uint8(applycform(XYZout, xyz2srgb));

wpSquareMeans = getMeanForEachSquare(wp_squaresIm, squareLocations);
wpRMS = calculateError(wpSquareMeans, chartSquares);


%% Interactively fit a curve to the grayscale row of the chart

% Get the observed values for the grayscale row in RGB
[observedRed observedGreen observedBlue] = getObservedChannels(squareMeans);
[chartRed chartGreen chartBlue] = getChartRGBValues('grayRGB.xls');

% Create new curves
[redCurve greenCurve blueCurve] = createCurves(observedRed, observedGreen, observedBlue, ...
                                               chartRed, chartGreen, chartBlue);

%% apply curves to image

adjustedIm(:,:,1) = intlut(squaresIm(:,:,1), redCurve);
adjustedIm(:,:,2) = intlut(squaresIm(:,:,2), greenCurve);
adjustedIm(:,:,3) = intlut(squaresIm(:,:,3), blueCurve);

% Calculate error
adjustedSquareMeans = getMeanForEachSquare(adjustedIm, squareLocations);
adjustedRMS = calculateError(adjustedSquareMeans, chartSquares);

%%  Compare all results

imhsv = rgb2hsv(squaresIm);
imycbcr = rgb2ycbcr(squaresIm);
%Plot of RGB, HSV and YCbCR
% figure;subplot(2,2,1);imshow('colorChart.tif');title('Reference Chart')
% subplot(2,2,2);imshow(squaresIm);title(['Original Image, RMS=',num2str(RMS)])
% subplot(2,2,3);imshow(imhsv);title('HSV color space');
% subplot(2,2,4);imshow(imycbcr);title('Ycbcr color space');


%% Color coordinate & spit out RGB HSV Value

%Find the furthest x points
centrexsorted = sort(centreofsquaresx,'ascend');
centreysorted = sort(centreofsquaresy,'ascend');

meanxsorted = [];
meanysorted = [];

for i=1:size(centrexsorted,2)
    if mod(i,4) == 0
        meanxsorted = [meanxsorted mean(centrexsorted(i-3:i))];
    end
end
for i=1:size(centreysorted,2)
    if mod(i,6) == 0
        meanysorted = [meanysorted mean(centreysorted(i-5:i))];
    end
end

%% Generating the RGB, HSV & YCbCr values

tempimage = squaresIm;
%RGB Values
RGBValuesGray = [tempimage(floor(meanysorted(4)),floor(meanxsorted(4)),1) tempimage(floor(meanysorted(4)),floor(meanxsorted(4)),2) tempimage(floor(meanysorted(4)),floor(meanxsorted(4)),3)];
RGBValuesGold = [tempimage(floor(meanysorted(2)),floor(meanxsorted(6)),1) tempimage(floor(meanysorted(2)),floor(meanxsorted(6)),2) tempimage(floor(meanysorted(2)),floor(meanxsorted(6)),3)];

%HSV Values
tempimage = rgb2hsv(squaresIm);
HSVValuesGray = [tempimage(floor(meanysorted(4)),floor(meanxsorted(4)),1) tempimage(floor(meanysorted(4)),floor(meanxsorted(4)),2) tempimage(floor(meanysorted(4)),floor(meanxsorted(4)),3)];
HSVValuesGold = [tempimage(floor(meanysorted(2)),floor(meanxsorted(6)),1) tempimage(floor(meanysorted(2)),floor(meanxsorted(6)),2) tempimage(floor(meanysorted(2)),floor(meanxsorted(6)),3)];

%YCbCr Values
tempimage = rgb2ycbcr(squaresIm);
YCBCRValuesGray = [tempimage(floor(meanysorted(4)),floor(meanxsorted(4)),1) tempimage(floor(meanysorted(4)),floor(meanxsorted(4)),2) tempimage(floor(meanysorted(4)),floor(meanxsorted(4)),3)];
YCBCRValuesGold = [tempimage(floor(meanysorted(2)),floor(meanxsorted(6)),1) tempimage(floor(meanysorted(2)),floor(meanxsorted(6)),2) tempimage(floor(meanysorted(2)),floor(meanxsorted(6)),3)];

% figure;
% imshow(squaresIm);

% hold on;
% plot(meanxsorted(4),meanysorted(4),'rx','Linewidth',20)
% plot(meanxsorted(6),meanysorted(2),'gx','Linewidth',20)

