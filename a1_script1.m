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
pause

% Question 1.2
fprintf('\n')
fprintf('Question 1.2:\n')
[Gmag, Gdir] = imgradient(A);
fprintf('The gradient magnitude at pixel[2,3] is 13.04\n')
fprintf('The gradient magnitude at pixel[4,3] is 6.32\n')
fprintf('The gradient magnitude at pixel[4,6] is 6.32\n')
fprintf('\n')
pause

% Question 1.3 function is at the bottom

% Question 1.4 
fprintf('\n')
fprintf('Question 1.3 and 1.4:\n')
fprintf('Matrix S using MyConv function and Matrix U using imfilter \n')  

% 2D Gaussian kernel with hsize = 13 and sigma = 2
hsize = 13;
sigma = 2;
kernel = fspecial('gaussian',hsize,sigma)

img = imread('sample.png');
img2 = imread('sample.png');

imshow(img)
imfilter_image = imfilter(img,kernel);
figure, imshow(imfilter_image)

%Absolute difference
absolute_difference = imfilter_image - MyConv_image;
fprintf('There is difference in values between imfilter and MyConv\n');
fprintf('The image turns black. However, with a smaller hsize less than 6, the image is viewable\n');
pause

% Question 1.5
% 2D Gaussian kernel with hsize = 3 and sigma = 8
hsize = 3;
sigma = 8;
kernel1 = fspecial('gaussian',hsize,sigma)
img3 = imread('mountain.png');
img4=im2double(imread('mountain.png'));
imshow(img3)
tic
imfilter_image1 = imfilter(img3,kernel1);
figure, imshow(imfilter_image1)
toc

% 1D Gaussian kernel 
Filter=[3 5]

% 1D Gaussians
X=fspecial('gaussian',[1 Filter(2)]);
Y=fspecial('gaussian',[Filter(1) 1]);
tic
%X-direction
imgX=imfilter(img4,X);

%Y-direction
imgY=imfilter(imgX,Y); 
toc
pause

% Question 3
image = imread('ryerson.jpg');
horizontal = input('Horizontal Seams to remove : ');
vertical = input('Vertical Seams to remove : ');
imshow(image)
img = image;
size = size(image);
if (vertical < size(2)) && (horizontal < size(1))
    
    for k = 1:vertical
        dp = MySeamCarving(img);
        img= CarvingHelper(dp, img);
    end

    img = rot90(img);
    for k = 1:horizontal
        dp = MySeamCarving(img);
        img = CarvingHelper(dp, img);
    end
    img = rot90(img,3);
    figure;
    imshow(img);
else
    disp('Invalid Input');
end



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




function [dp] = MySeamCarving(img)
    I = rgb2gray(img); % Greyscale Conversion
    e = entropyfilt(I); % Entropy Conversion
    %imshow(e,[])
    dp=e;
    sz = size(dp);
    for i = 2:sz(1)
        for j = 1:sz(2)
            if j == 1
                dp(i,j) = dp(i,j) + min(dp(i-1,j),dp(i-1,j+1));
            elseif j == sz(2)
                dp(i,j) = dp(i,j) + min(dp(i-1,j-1),dp(i-1,j));
            else
                dp(i,j) = dp(i,j) + min(dp(i-1,j-1),min(dp(i-1,j),dp(i-1,j+1)));
            end
        end
    end
end

function [new] = CarvingHelper(dp, img)
    sz = size(img);
    sz(2) = sz(2) - 1;
    new = zeros(sz,'uint8');
    sz = size(img);
    arr = dp(sz(1),:);
    [~, index] = min(arr);
    %disp(index);
    count = 1;
    for j = 1:sz(2)
        if j==index
            % PASS 
        else
            new(sz(1),count,1) = img(sz(1),j,1);
            new(sz(1),count,2) = img(sz(1),j,2);
            new(sz(1),count,3) = img(sz(1),j,3);
            count = count + 1;
        end
    end
    for i = (sz(1)-1):-1:1
        if index == sz(2)
            if dp(i,index) < dp(i,index-1)
                % PASS
            else
                index = index - 1;
            end
        elseif index==1
            if dp(i,index) < dp(i,index+1)
                % PASS
            else
                index = index + 1;
            end
        else
            if dp(i,index-1) < dp(i,index)
                if dp(i,index-1) < dp(i,index+1)
                    index = index - 1; 
                else
                    index = index + 1;
                end
            else
                if dp(i,index) < dp(i,index+1)
                    % PASS 
                else
                    index = index + 1;
                end
            end
        end
        %disp(index);
        count = 1;
        %imshow(new);
        for j = 1:sz(2)
            if j==index
            else
                new(i,count,1) = img(i,j,1);
                new(i,count,2) = img(i,j,2);
                new(i,count,3) = img(i,j,3);
                count = count + 1;
            end
        end
    end
end


