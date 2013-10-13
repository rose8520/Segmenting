%% SIFT CODING 

run('C:\Users\Rose\Downloads\vlfeat-0.9.17/toolbox/vl_setup')

%% Template Matching

%Read images of $50(A), $20(B), $10(C), $5(D) respectively 
A = imread('aus50front.jpg');
A1 = imread('fifty_text.jpg');

B = imread('aus20front.jpg');
B1 = imread('twenty_text.jpg');

C = imread('aus10back.jpg');
C1 = imread('ten_text.jpg');

D = imread('aus5front.jpg');
D1 = imread('five_text.jpg');

%Converting image to grayscale
Ag = rgb2gray(A); 
A1g = rgb2gray(A1);

Bg = rgb2gray(B);
B1g = rgb2gray(B1);

Cg = rgb2gray(C);
C1g = rgb2gray(C1);

Dg = rgb2gray(D);
D1g = rgb2gray(D1);

%%Isimilarity function within the vision folder of RVCTOOLS
%Find correlations using Zero Normalized Cross Correlation

S1 = isimilarity(A1g,Ag);
S2 = isimilarity(B1g,Bg);
S3 = isimilarity(C1g,Cg);
S4 = isimilarity(D1g,Dg);

%Find index of best match
indices1 = find(S1 == max(max(S1)));
indices2 = find(S2 == max(max(S2)));
indices3 = find(S3 == max(max(S3)));
indices4 = find(S4 == max(max(S4)));

%Convert the (1D) index to (2D) matrix subscript values
[y1 x1] = ind2sub(size(S1),indices1);
[y2 x2] = ind2sub(size(S2),indices2);
[y3 x3] = ind2sub(size(S3),indices3);
[y4 x4] = ind2sub(size(S4),indices4);

%Plotting the images corresponding to the text of the image
figure;

%Comparison plot for $50 note
subplot(4,2,1);
imshow(Ag);
hold on;
plot(x1,y1,'rx');
title('Test image');

subplot(4,2,2);
imshow(S1);
hold on;
plot(x1,y1,'rx');
title('Similarity image');

%Comparison plot for $20 note
subplot(4,2,3);
imshow(Bg);
hold on;
plot(x2,y2,'rx');
title('Similarity image');

subplot(4,2,4);
imshow(S2);
hold on;
plot(x2,y2,'rx');
title('Similarity image');

%Comparison plot for $10 note
subplot(4,2,5);
imshow(Cg);
hold on;
plot(x3,y3,'rx');
title('Similarity image');

subplot(4,2,6);
imshow(S3);
hold on;
plot(x3,y3,'rx');
title('Similarity image');

%Comparison plot for $5 note
subplot(4,2,7);
imshow(Dg);
hold on;
plot(x4,y4,'rx');
title('Similarity image');

subplot(4,2,8);
imshow(S4);
hold on;
plot(x4,y4,'rx');
title('Similarity image');