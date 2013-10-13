rgb = imread('chess_circles.jpg');

grey = rgb2gray(rgb);

Edge = edge(grey,'canny');

[H,Theta,Rho] = hough(Edge);

N = 13;
P = houghpeaks(H,N);

lines = houghlines(grey,Theta,Rho,P);

%figure;

subplot(2,1,1);
imshow(rgb);
title('chess_circle.jpg');
hold on;

for k = 1:length(lines)
   xy = [lines(k).point1; lines(k).point2];
   plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');

   % Plot beginnings and ends of lines
   plot(xy(1,1),xy(1,2),'x','LineWidth',2,'Color','yellow');
   plot(xy(2,1),xy(2,2),'x','LineWidth',2,'Color','red');

end

subplot(2,1,2);
imshow(imadjust(mat2gray(H)), 'XData', T, 'YData', R, 'InitialMagnification', 'fit');
hold on;