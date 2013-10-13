run('C:\Users\Rose\Downloads\vlfeat-0.9.17/toolbox/vl_setup');
% rosie_sift_extraction;

% rosie_houghcircles;

%% SIFT Feature Extraction

%Read images of front and back of $50, $20, $10, $5 and $100 respectively
fiftyf = imread('aus50front.jpg');
fiftyb = imread('aus50back.jpg');

twentyf = imread('aus20front.jpg');
twentyb = imread('aus20back.jpg');

tenf = imread('aus10front.jpg');
tenb = imread('aus10back.jpg');

fivef = imread('aus5front.jpg');
fiveb = imread('aus5back.jpg');

hundredf = imread('aus100front.jpg');
hundredb = imread('aus100back.jpg');

%Turn images of $50, $20, $10, $5  and $100 to grayscale
fiftyfg = rgb2gray(fiftyf);
fiftybg = rgb2gray(fiftyb);

twentyfg = rgb2gray(twentyf);
twentybg = rgb2gray(twentyb);

tenfg = rgb2gray(tenf);
tenbg = rgb2gray(tenb);

fivefg = rgb2gray(fivef);
fivebg = rgb2gray(fiveb);

hundredfg = rgb2gray(hundredf);
hundredbg =rgb2gray(hundredb);

%% Extract SIFT features and descriptors of $50, $20, $10, $5 and $100
[F50f D50f] = vl_sift(single(fiftyfg));
[F50b D50b] = vl_sift(single(fiftybg));

[F20f D20f] = vl_sift(single(twentyfg));
[F20b D20b] = vl_sift(single(twentybg));

[F10f D10f] = vl_sift(single(tenfg));
[F10b D10b] = vl_sift(single(tenbg));

[F5f D5f] = vl_sift(single(fivefg));
[F5b D5b] = vl_sift(single(fivebg));

[F100f D100f] = vl_sift(single(hundredfg));
[F100b D100b] = vl_sift(single(hundredbg));


%% Scale-Invariant Feature Transform (SIFT) Feature Matching

%Read images of front and back of $50(A), $20(B), $10(C), $5(D) and $100(E) respectively
testA1 = imread('aus50front.jpg');
testA2 = imread('aus50back.jpg');

testB1 = imread('aus20front.jpg');
testB2 = imread('aus20back.jpg');

testC1 = imread('aus10front.jpg');
testC2 = imread('aus10back.jpg');

testD1 = imread('aus5front.jpg');
testD2 = imread('aus5back.jpg');
% 
% testE1 = imread('aus100front.jpg');
% testE2 = imread('aus100back.jpg');

%Image of the DAY
test2 = imread('randomplate3.jpg');

%Converting to grayscale
testAg1 = rgb2gray(testA1);
testAg2 = rgb2gray(testA2);

testBg1 = rgb2gray(testB1);
testBg2 = rgb2gray(testB2);

testCg1 = rgb2gray(testC1);
testCg2 = rgb2gray(testC2);

testDg1 = rgb2gray(testD1);
testDg2 = rgb2gray(testD2);

% testEg1 = rgb2gray(testE1);
% testEg2 = rgb2gray(testE2);

test2g = rgb2gray(test2);

%% Extracting features and descriptors
%%% compute the SIFT descriptors [1] Each column of D
%%% is the descriptor of corresponding frame in F

% For $50
[Ftest1_1 Dtest1_1] = vl_sift(single(testAg1));
[Ftest2_1 Dtest2_1] = vl_sift(single(test2g));

[Ftest1_2 Dtest1_2] = vl_sift(single(testAg2));
[Ftest2_2 Dtest2_2] = vl_sift(single(test2g));

% For $20
[Ftest3_1 Dtest3_1] = vl_sift(single(testBg1));
[Ftest4_1 Dtest4_1] = vl_sift(single(test2g));

[Ftest3_2 Dtest3_2] = vl_sift(single(testBg2));
[Ftest4_2 Dtest4_2] = vl_sift(single(test2g));

% For $10
[Ftest5_1 Dtest5_1] = vl_sift(single(testCg1));
[Ftest6_1 Dtest6_1] = vl_sift(single(test2g));

[Ftest5_2 Dtest5_2] = vl_sift(single(testCg2));
[Ftest6_2 Dtest6_2] = vl_sift(single(test2g));

% For $5
[Ftest7_1 Dtest7_1] = vl_sift(single(testDg1));
[Ftest8_1 Dtest8_1] = vl_sift(single(test2g));

[Ftest7_2 Dtest7_2] = vl_sift(single(testDg2));
[Ftest8_2 Dtest8_2] = vl_sift(single(test2g));

% % For $100
% [Ftest9_1 Dtest9_1] = vl_sift(single(testEg1));
% [Ftest10_1 Dtest10_1] = vl_sift(single(test2g));
% 
% [Ftest9_2 Dtest9_2] = vl_sift(single(testEg2));
% [Ftest10_2 Dtest10_2] = vl_sift(single(test2g));

% %%%vl_ubcmathc implements a basic matching algorithm. 

%% To match the SECOND test image with the 'training_back.jpg'
%%% returns the matches and the squared Euclidean distance between matches

% For $50
[matches1_1 scores1_1] = vl_ubcmatch(D50f,Dtest2_1);
[matches1_2 scores1_2] = vl_ubcmatch(D50b,Dtest2_2);

% For $20
[matches2_1 scores2_1] = vl_ubcmatch(D20f,Dtest4_1); 
[matches2_2 scores2_2] = vl_ubcmatch(D20b,Dtest4_2); 

% For $10
[matches3_1 scores3_1] = vl_ubcmatch(D10f,Dtest6_1); 
[matches3_2 scores3_2] = vl_ubcmatch(D10b,Dtest6_2); 

% For $5
[matches4_1 scores4_1] = vl_ubcmatch(D5f,Dtest8_1); 
[matches4_2 scores4_2] = vl_ubcmatch(D5b,Dtest8_2); 

% % For $100
% [matches5_1 scores5_1] = vl_ubcmatch(D100f,Dtest10_1); 
% [matches5_2 scores5_2] = vl_ubcmatch(D100b,Dtest10_2); 

%#The index of the original match and the closest descriptor is stored in
%each column MATCHES.

%#The distance between the pair is stored in SCORES.


%% DETECTOR PARAMETERS

% testAg1 = double(rand(100,500) <= .005) ;
% testAg1 = (ones(100,1) * linspace(0,1,500)) .* testAg1 ;
% testAg1(:,1) = 0 ; 
% testAg1(:,end) = 0 ;
% testAg1(1,:) = 0 ; 
% testAg1(end,:) = 0 ;
% testAg1 = 2*pi*4^2 * vl_imsmooth(testAg1,4) ;
% testAg1= single(255 * testAg1) ;
% 
% Ftest1_1 = vl_sift(testAg1, 'PeakThresh', peak_thresh) ;

%% Sorting the scores

% For $50
[scores_sorted1_1 Indices1_1] = sort(scores1_1, 'descend');
[scores_sorted1_2 Indices1_2] = sort(scores1_2, 'descend');

% For $20
[scores_sorted2_1 Indices2_1] = sort(scores2_1, 'descend');
[scores_sorted2_2 Indices2_2] = sort(scores2_2, 'descend');

% For $10
[scores_sorted3_1 Indices3_1] = sort(scores3_1, 'descend');
[scores_sorted3_2 Indices3_2] = sort(scores3_2, 'descend');

% For $5
[scores_sorted4_1 Indices4_1] = sort(scores4_1, 'descend');
[scores_sorted4_2 Indices4_2] = sort(scores4_2, 'descend');

% % For $100
% [scores_sorted5_1 Indices5_1] = sort(scores5_1, 'descend');
% [scores_sorted5_2 Indices5_2] = sort(scores5_2, 'descend');

%% Obtaining the min values in array

% For $50
[a1_1 b1_1] = sort(scores_sorted1_1);
a1_1lowest = b1_1(1:min(15,size(b1_1,2)));
low10pt1_1 = scores_sorted1_1(a1_1lowest);

[a1_2 b1_2] = sort(scores_sorted1_2);
a1_2lowest = b1_2(1:min(15,size(b1_2,2)));
low10pt1_2 = scores_sorted1_2(a1_2lowest);

% For $20
[a2_1 b2_1] = sort(scores_sorted2_1);
a2_1lowest = b2_1(1:min(15,size(b2_1,2)));
low10pt2_1 = scores_sorted2_1(a2_1lowest);

[a2_2 b2_2] = sort(scores_sorted2_2);
a2_2lowest = b2_2(1:min(15,size(b2_2,2)));
low10pt2_2 = scores_sorted2_2(a2_2lowest);

% For $10
[a3_1 b3_1] = sort(scores_sorted3_1);
a3_1lowest = b3_1(1:min(15,size(b3_1,2)));
low10pt3_1 = scores_sorted3_1(a3_1lowest);

[a3_2 b3_2] = sort(scores_sorted3_2);
a3_2lowest = b3_2(1:min(15,size(b3_2,2)));
low10pt3_2 = scores_sorted3_2(a3_2lowest);

% For $5
[a4_1 b4_1] = sort(scores_sorted4_1);
a4_1lowest = b4_1(1:min(15,size(b4_1,2)));
low10pt4_1 = scores_sorted4_1(a4_1lowest);

[a4_2 b4_2] = sort(scores_sorted4_2);
a4_2lowest = b4_2(1:min(15,size(b4_2,2)));
low10pt4_2 = scores_sorted4_2(a4_2lowest);

% % For $100
% [a5_1 b5_1] = sort(scores_sorted5_1);
% a5_1lowest = b5_1(1:min(15,size(b5_1,2)));
% low10pt5_1 = scores_sorted5_1(a5_1lowest);
% 
% [a5_2 b5_2] = sort(scores_sorted5_2);
% a5_2lowest = b5_2(1:min(15,size(b5_2,2)));
% low10pt5_2 = scores_sorted5_2(a5_2lowest);

%% To match up the scores with the matches coordinate

% Empty lists for $50, $20, $10, $5 and $100
lowest_matches1_1 = [];
lowest_matches1_2 = [];

lowest_matches2_1 = [];
lowest_matches2_2 = [];

lowest_matches3_1 = [];
lowest_matches3_2 = [];

lowest_matches4_1 = [];
lowest_matches4_2 = [];

% lowest_matches5_1 = [];
% lowest_matches5_2 = [];


% For $50
for i=1:size(matches1_1,2)
    for k=1:size(low10pt1_1,2)
        if scores1_1(i) == low10pt1_1(k)
            lowest_matches1_1 = [lowest_matches1_1 [matches1_1(1,i); matches1_1(2,i)]];
        end
    end
end
matches1_1 = lowest_matches1_1 ; 

for i=1:size(matches1_2,2)
    for k=1:size(low10pt1_2,2)
        if scores1_2(i) == low10pt1_2(k)
            lowest_matches1_2 = [lowest_matches1_2 [matches1_2(1,i); matches1_2(2,i)]];
        end
    end
end
matches1_2 = lowest_matches1_2;

% For $20
for i=1:size(matches2_1,2)
    for k=1:size(low10pt2_1,2)
        if scores2_1(i) == low10pt2_1(k)
            lowest_matches2_1 = [lowest_matches2_1 [matches2_1(1,i); matches2_1(2,i)]];
        end
    end
end
% matches2_1 = lowest_matches2_1 

for i=1:size(matches2_2,2)
    for k=1:size(low10pt2_2,2)
        if scores2_2(i) == low10pt2_2(k)
            lowest_matches2_2 = [lowest_matches2_2 [matches2_2(1,i); matches2_2(2,i)]];
        end
    end
end
matches2_2 = lowest_matches2_2 ;


%For $10
for i=1:size(matches3_1,2)
    for k=1:size(low10pt3_1,2)
        if scores3_1(i) == low10pt3_1(k)
            lowest_matches3_1 = [lowest_matches3_1 [matches3_1(1,i); matches3_1(2,i)]];
        end
    end
end
matches3_1 = lowest_matches3_1 ;

for i=1:size(matches3_2,2)
    for k=1:size(low10pt3_2,2)
        if scores3_2(i) == low10pt3_2(k)
            lowest_matches3_2 = [lowest_matches3_2 [matches3_2(1,i); matches3_2(2,i)]];
        end
    end
end
matches3_2 = lowest_matches3_2 ;


%For $5
for i=1:size(matches4_1,2)
    for k=1:size(low10pt4_1,2)
        if scores4_1(i) == low10pt4_1(k)
            lowest_matches4_1 = [lowest_matches4_1 [matches4_1(1,i); matches4_1(2,i)]];
        end
    end
end
matches4_1 = lowest_matches4_1 ;

for i=1:size(matches4_2,2)
    for k=1:size(low10pt4_2,2)
        if scores4_2(i) == low10pt4_2(k)
            lowest_matches4_2 = [lowest_matches4_2 [matches4_2(1,i); matches4_2(2,i)]];
        end
    end
end
matches4_2 = lowest_matches4_2; 

%For $100
% for i=1:size(matches5_1,2)
%     for k=1:size(low10pt5_1,2)
%         if scores5_1(i) == low10pt5_1(k)
%             lowest_matches5_1 = [lowest_matches5_1 [matches5_1(1,i); matches5_1(2,i)]];
%         end
%     end
% end
% matches4_1 = lowest_matches4_1 
% 
% for i=1:size(matches5_2,2)
%     for k=1:size(low10pt5_2,2)
%         if scores5_2(i) == low10pt5_2(k)
%             lowest_matches5_2 = [lowest_matches5_2 [matches5_2(1,i); matches5_2(2,i)]];
%         end
%     end
% end
% matches5_2 = lowest_matches5_2 


%% Visualise the matches

figure(6);
title('$50 note - front');
[input_points1_1 base_points1_1] = visualise_sift_matches(fiftyfg, test2g, F50f,Ftest2_1,matches1_1);

figure(7);
title('$50 note - back');
[input_points1_2 base_points1_2] = visualise_sift_matches(fiftybg, test2g, F50b,Ftest2_2,matches1_2);
  
figure(8);
title('$20 note - front');
[input_points2_1 base_points2_1] = visualise_sift_matches(twentyfg, test2g, F20f,Ftest4_1,matches2_1);

figure(9);
title('$20 note - back');
[input_points2_2 base_points2_2] = visualise_sift_matches(twentybg, test2g, F20b,Ftest4_2,matches2_2);

figure(10);
title('$10 note - front');
[input_points3_1 base_points3_1] = visualise_sift_matches(tenfg, test2g, F10f,Ftest6_1,matches3_1);

figure(11);
title('$10 note - back');
[input_points3_2 base_points3_2] = visualise_sift_matches(tenbg, test2g, F10b,Ftest6_2,matches3_2);

figure(12);
title('$5 note - front');
[input_points4_1 base_points4_1] = visualise_sift_matches(fivefg, test2g, F5f,Ftest8_1,matches4_1);

figure(13);
title('$5 note - back');
[input_points4_2 base_points4_2] = visualise_sift_matches(fivebg, test2g, F5b,Ftest8_2,matches4_2);

% figure(12);
% title('$100 note - front');
% [input_points5_1 base_points5_1] = visualise_sift_matches(hundredfg, test2g, F100f,Ftest10_1,matches5_1);
% 
% figure(13);
% title('$100 note - back');
% [input_points5_2 base_points5_2] = visualise_sift_matches(hundredbg, test2g, F100b,Ftest10_2,matches5_2);
% 

%% Printing the number of $50, $20, $10 and $5 dollar on plate

if(size(low10pt1_1,2)>10 || size(low10pt1_2,2)>10)
    fprintf('There is a $50 present\r\n');
end
if(size(low10pt2_1,2)>10 || size(low10pt2_2,2)>10)
    fprintf('There is a $20 present\r\n');
end
if(size(low10pt3_1,2)>10 || size(low10pt3_2,2)>10)
    fprintf('There is a $10 present\r\n');
end
if(size(low10pt4_1,2)>10 || size(low10pt4_2,2)>10)
    fprintf('There is a $5 present\r\n');
end



%% Extract the top #no matches
%%matches = matches(:, Indices(1:#));
% 
% matches1_1 = matches1_1(:, Indices1_1(1:10));
% matches1_2 = matches1_2(:, Indices1_2(1:10));
% 
% matches2_1 = matches2_1(:, Indices2_1(1:10));
% matches2_2 = matches2_2(:, Indices2_2(1:10));
% 
% matches3_1 = matches3_1(:, Indices3_1(1:10));
% matches3_2 = matches3_2(:, Indices3_2(1:10));
