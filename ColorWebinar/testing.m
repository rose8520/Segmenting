% a=imread('macbeth.jpg');
% c=size(a)
% for i = 1:1:c(1)
%     for j = 1:1:c(2)
%     b(i,c(2)+1-j)=a(i,j);
%     end
% end
% figure()
% imshow(a)
% figure()
% imshow(flipdim(a,2))
% size(b)



RGB=imread('macbeth.jpg');
% c=size(RGB)
% for i = 1:1:size(RGB(1))
%     for j = 1:1:size(RGB(2))
%     b(i,size(RGB(2))+1-j)=RGB(i,j);
%     end
% end
figure();
imshow(RGB);
figure();hold on;
imshow(flipdim(RGB,1))
imshow(flipdim(RGB,2))
size(b)


subplot(2,2,1);

imshow(RGB);
title('Original image');

subplot(2,2,2);

imshow(flipdim(RGB,2));
title('Tilted by Y');


subplot(2,2,3);

imshow(flipdim(RGB,1));
title('Tilted by x');

% % Image=imread('fog1.bmp');
% if size(b,3)==3
%     b=rgb2gray(b);
% end
% [m n r]=size(b);
% rgb=zeros(m,n,3); 
% rgb(:,:,1)=b;
% rgb(:,:,2)=rgb(:,:,1);
% rgb(:,:,3)=rgb(:,:,1);
% b=rgb/255; 
% figure,imshow(b);


RGB = imread('Colorchart2.jpg');

%Mirror flipping the image
subplot(2,2,1);
imshow(RGB);
title('Original image');

subplot(2,2,2);
imshow(flipdim(RGB,2));
title('Tilted by Y');

subplot(2,2,3);
imshow(flipdim(RGB,1));
title('Tilted by x');