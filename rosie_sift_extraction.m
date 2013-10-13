run('C:\Users\Rose\Downloads\vlfeat-0.9.17/toolbox/vl_setup');
% rosie_sift_moneytext;

%% Definitions

%%%  The DETECTOR extracts from an image a number of frames (attributed
%%%  regions) in a way which is consistent with (some) variations of the
%%%  ilumination, viewpoints and other viewing conditions

%%%  The DESCRIPTOR associates to the regions a signature which
%%%  identifies their appearance compactly and robustly.


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

% $ Show features and descriptors for FRONT image $ %

% figure(1);
% imshow(fiftyfg);
% 
% figure(2);
% imshow(twentyfg);
% 
% figure(3);
% imshow(tenfg);
% 
% figure(4);
% imshow(fivefg);
% 
% figure(5);
% imshow(hundredfg);

%Where matrix F50f / F50d has a column for each frame
%A frame is a disk of center f(1:2), scale f(3), orientation f(4)

%% Visualizing a random selection of 50 features:
% figure(1);
perm1 = randperm(size(F50f,2)) ;
sel1 = perm1(1:50) ;
h1_1 = vl_plotframe(F50f(:,sel1)) ;
h2_1 = vl_plotframe(F50f(:,sel1)) ;
set(h1_1,'color','k','linewidth',3) ;
set(h2_1,'color','y','linewidth',2) ;

% figure(2);
perm2 = randperm(size(F20f,2)) ;
sel2 = perm2(1:50) ;
h1_2 = vl_plotframe(F20f(:,sel2)) ;
h2_2 = vl_plotframe(F20f(:,sel2)) ;
set(h1_2,'color','k','linewidth',3) ;
set(h2_2,'color','y','linewidth',2) ;

% figure(3);
perm3 = randperm(size(F10f,2)) ;
sel3 = perm3(1:50) ;
h1_3 = vl_plotframe(F10f(:,sel3)) ;
h2_3 = vl_plotframe(F10f(:,sel3)) ;
set(h1_3,'color','k','linewidth',3) ;
set(h2_3,'color','y','linewidth',2) ;

% figure(4);
perm4 = randperm(size(F5f,2)) ;
sel4 = perm4(1:50) ;
h1_4 = vl_plotframe(F5f(:,sel4)) ;
h2_4 = vl_plotframe(F5f(:,sel4)) ;
set(h1_4,'color','k','linewidth',3) ;
set(h2_4,'color','y','linewidth',2) ;

% figure(5);
perm5 = randperm(size(F100f,2)) ;
sel5 = perm5(1:50) ;
h1_5 = vl_plotframe(F100f(:,sel5)) ;
h2_5 = vl_plotframe(F100f(:,sel5)) ;
set(h1_5,'color','k','linewidth',3) ;
set(h2_5,'color','y','linewidth',2) ;


%% Overlaying the descriptors 

% figure(1);
h3_1 = vl_plotsiftdescriptor(D50f(:,sel1),F50f(:,sel1)) ;
set(h3_1,'color','g') ;

% figure(2);
h3_2 = vl_plotsiftdescriptor(D20f(:,sel2),F20f(:,sel2)) ;
set(h3_2,'color','g') ;

% figure(3);
h3_3 = vl_plotsiftdescriptor(D10f(:,sel3),F10f(:,sel3)) ;
set(h3_3,'color','g') ;

% figure(4);
h3_4 = vl_plotsiftdescriptor(D5f(:,sel4),F5f(:,sel4)) ;
set(h3_4,'color','g') ;

% figure(5);
h3_5 = vl_plotsiftdescriptor(D100f(:,sel5),F100f(:,sel5)) ;
set(h3_5,'color','g') ;

close all;