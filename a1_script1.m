% 1 Convolution
% Question 1.1
A = [ -5  0  0  0  0  0  0  0  0  0
       0  0  0  0  0  0  0  0  0  0
       7 -2 -8  1 -2  1  3  0  0  0
       0 -1 -1  0  0  1  1  0  0  0
       0 -3 -1  2 -4  1  5  0  0  0
       0  1  1  0  0 -1 -1  0  0  0
       0 -1 -2 -2 -2  3  4  0  0  0
       0  0  0  0  0  0  0  0  0  0
       0  0  0  0  0  0  0  0  0  0];
   
fprintf('Question 1.1:\n')
fprintf('The resulting image after convolution is \n')
fmt = [repmat('%2d ', 1, size(A,2)-1), '%2d\n'];
fprintf(fmt, A.'); 

% Question 1.2
fprintf('\n')
fprintf('Question 1.2:\n')
[Gmag, Gdir] = imgradient(A);
fprintf('The gradient magnitude at pixel[2,3] is 13.04\n')
fprintf('The gradient magnitude at pixel[4,3] is 6.32\n')
fprintf('The gradient magnitude at pixel[4,6] is 6.32\n')
fprintf('\n')

% Question 1.4 and Question 1.5
fprintf('\n')
fprintf('Question 1.3 and 1.4:\n')
fprintf('Matrix S using MyConv function and Matrix U using imfilter \n')

% 2D Gaussian kernel with hsize = 13 and sigma = 2
hsize = 13;
sigma = 2;
%kernel = fspecial('gaussian',hsize,sigma)
kernel = [1,10,1;0,0,0;-1,-10,-1];

img = imread('sample.png');
img2 = imread('sample.png');

imshow(img)
tic
imfilter_image = imfilter(img,kernel);
figure, imshow(imfilter_image)
toc

tic
MyConv_image = MyConv(img2,kernel);
figure, imshow(MyConv_image)
toc

%Absolute difference
absolute_difference = imfilter_image - MyConv_image;
fprintf('There is no difference in values between imfilter and MyConv\n');


% Question 1.3
function [ conv_image ] = MyConv( image,kernel )
  % Getting the size of the input image  
  [rows,cols] = size(image); 

  % Creating a padded matrix and creating a new padded image
  modified_image = zeros(rows+2,cols+2);
  modified_image = cast(modified_image, class(image));
  modified_image(2:end-1,2:end-1) = image;

  conv_image = zeros(size(modified_image));
  conv_image = cast(conv_image, class(image));

  % Loop for convolution calculation
  for i=2:1:rows+1 
    for j=2:1:cols+1 
      sum=0;
      % Flipping the kernel
      for x=-1:1:1
        for y=-1:1:1
          sum=sum+modified_image(i+x,j+y)*kernel(x+2,y+2); 
        end
      end
     conv_image(i,j)=sum;
    end
  end


% Cropping image
conv_image = conv_image(2:end-1,2:end-1);
end



