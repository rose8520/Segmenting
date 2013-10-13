%% Colour calibration 

%% Load in test image and select chart
clear;
clc;
close all;


% im = flipdim(RGB,2);
im = imread('demoday.jpg');
im = flipdim(im,2);


% Cropping tool for the image
% [squaresIm,cropRect] = imcrop(im);
squaresIm = im;
cropRect = [0 0 size(squaresIm,2) size(squaresIm,1)];
close; subplot(2,2,1); imshow(squaresIm); title('Selected Region')

% Convert chart image to black and white
gray = rgb2gray(squaresIm);     % Convert to grayscale

% % Histeq  enhances the contrast of images by transforming the values in an
% % intensity image, or the values in the colormap of an indexed image, so
% % that the histogram of the output image approximately matches a specified
% % histogram.
J = histeq(gray);               % Equalize the histogram

% % GRAYTHRESH(I) computes a global threshold (LEVEL) that can be
% % used to convert an intensity image to a binary image with IM2BW. LEVEL
% % is a normalized intensity value that lies in the range [0, 1].
% % GRAYTHRESH uses Otsu's method, which chooses the threshold to minimize
% % the intraclass variance of the thresholded black and white pixels.
threshold = graythresh(J);      % Threshold

bw = im2bw(J, threshold);       % Convert to B&W

subplot(2,2,2); imshow(bw); title('Thresholded Region');

% Remove white pixels along the border, then dilate and erode to fill in
% solids.
bw2 = imclearborder(bw);
se = strel('square', 25);   
bw2 = imopen(bw2, se);
subplot(2,2,3); imshow(bw2); title('Noise Removed');

%% Find all chart squares
% Automatically find the centroid of all unique objects in the image.

labeled = bwlabel(bw2); %Label connected components in 2-D binary image.

s = regionprops(labeled,'Centroid'); %Measure properties of image regions.

centroids = cat(1, s.Centroid); %Concatenate arrays.

% Use custom algorithm to find missing squares on the chart.
squareLocations = findAllChartSquares(centroids, squaresIm);

subplot(2,2,4); displayChartSquares(squaresIm,squareLocations);

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

% Now that we've identified the color chart in our photograph, let's
% compare it to the reference color chart.  We can use datatips to get a
% quantitative reading of the RGB values.

squareMeans = getMeanForEachSquare(squaresIm, squareLocations);
chartSquares = getReferenceValues('chartValues.xls');

% Calculate the difference between the original image and reference values
RMS = calculateError(squareMeans, chartSquares);
% figure; displayError(squareMeans, chartSquares, RMS);

figure;
subplot(2,1,1);imshow('colorChart.tif');title('Reference Chart')
subplot(2,1,2);imshow(squaresIm);title(['Original Image, RMS=',num2str(RMS)])

%% Reducing the error with a white point adjustment
% Adjust the whitepoint to reduce the error in the image.  This should
% show a little bit of improvement.

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
% figure; displayError(wpSquareMeans, chartSquares, wpRMS);

%% Interactively fit a curve to the grayscale row of the chart
% Get the observed values for the grayscale row in RGB
[observedRed observedGreen observedBlue] = getObservedChannels(squareMeans);
[chartRed chartGreen chartBlue] = getChartRGBValues('grayRGB.xls');

% Create new curves
[redCurve greenCurve blueCurve] = createCurves(observedRed, observedGreen, observedBlue, ...
                                               chartRed, chartGreen, chartBlue);

% figure;subplot(3,1,1); plot(redCurve,'color','r'); title('Red Channel Curve');
% subplot(3,1,2); plot(greenCurve,'color','g'); title('Green Channel Curve');
% subplot(3,1,3); plot(blueCurve,'color','b'); title('Blue Channel Curve');

%% apply curves to image
adjustedIm(:,:,1) = intlut(squaresIm(:,:,1), redCurve);
adjustedIm(:,:,2) = intlut(squaresIm(:,:,2), greenCurve);
adjustedIm(:,:,3) = intlut(squaresIm(:,:,3), blueCurve);

% Calculate error
adjustedSquareMeans = getMeanForEachSquare(adjustedIm, squareLocations);
adjustedRMS = calculateError(adjustedSquareMeans, chartSquares);

% Compare all results
figure;subplot(2,2,1);imshow('colorChart.tif');title('Reference Chart')
subplot(2,2,2);imshow(squaresIm);title(['Original Image, RMS=',num2str(RMS)])
subplot(2,2,3);imshow(wp_squaresIm);title(['Adjusted Whitepoint, RMS=',num2str(wpRMS)])
subplot(2,2,4);imshow(adjustedIm);title(['Custom Curve, RMS=',num2str(adjustedRMS)])

imhsv = rgb2hsv(squaresIm);
imycbcr = rgb2ycbcr(squaresIm);

figure;subplot(2,2,1);imshow('colorChart.tif');title('Reference Chart')
subplot(2,2,2);imshow(squaresIm);title(['Original Image, RMS=',num2str(RMS)])
subplot(2,2,3);imshow(imhsv);title('HSV color space');
subplot(2,2,4);imshow(imycbcr);title('Ycbcr color space');


%% Color coordinate & spit out RGB HSV Value

% Centroid of the Gold (1,12) = X: 448.8 , Y:131.5
% Centroid of the Silver (1,22) X: 291.2 , Y:287.9

%Find the farthest x points
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
tempimage = squaresIm;
%RGB Values
RGBValuesGray = [tempimage(floor(meanysorted(4)),floor(meanxsorted(4)),1) tempimage(floor(meanysorted(4)),floor(meanxsorted(4)),2) tempimage(floor(meanysorted(4)),floor(meanxsorted(4)),3)]
RGBValuesGold = [tempimage(floor(meanysorted(2)),floor(meanxsorted(6)),1) tempimage(floor(meanysorted(2)),floor(meanxsorted(6)),2) tempimage(floor(meanysorted(2)),floor(meanxsorted(6)),3)]
% %HSV Values
tempimage = rgb2hsv(squaresIm);
HSVValuesGray = [tempimage(floor(meanysorted(4)),floor(meanxsorted(4)),1) tempimage(floor(meanysorted(4)),floor(meanxsorted(4)),2) tempimage(floor(meanysorted(4)),floor(meanxsorted(4)),3)]
HSVValuesGold = [tempimage(floor(meanysorted(2)),floor(meanxsorted(6)),1) tempimage(floor(meanysorted(2)),floor(meanxsorted(6)),2) tempimage(floor(meanysorted(2)),floor(meanxsorted(6)),3)]
% %YCR Values
tempimage = rgb2ycbcr(squaresIm);
YCBCRValuesGray = [tempimage(floor(meanysorted(4)),floor(meanxsorted(4)),1) tempimage(floor(meanysorted(4)),floor(meanxsorted(4)),2) tempimage(floor(meanysorted(4)),floor(meanxsorted(4)),3)]
YCBCRValuesGold = [tempimage(floor(meanysorted(2)),floor(meanxsorted(6)),1) tempimage(floor(meanysorted(2)),floor(meanxsorted(6)),2) tempimage(floor(meanysorted(2)),floor(meanxsorted(6)),3)]
figure;
imshow(squaresIm);
hold on;
plot(meanxsorted(4),meanysorted(4),'rx','Linewidth',20)
plot(meanxsorted(6),meanysorted(2),'gx','Linewidth',20)

% % Create display ERROR in 3D Plot
% figure; displayError(adjustedSquareMeans, chartSquares, adjustedRMS);
                   