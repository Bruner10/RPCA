% load necessary packages
pkg load image
pkg load communications
clear
%{
  Load the Buddy Image and Plot it in a window
  This code was taken from Homework 6
%}
% Load image to approximate
load('Buddy_Images/buddyfig.mat','buddyfig'); % Figure adapted from https://twitter.com/UCOBronchos/status/1273249045822267401/photo/1
A = buddyfig;

% Plot the original image
figure;
imshow(mat2gray(A));
title('Original Image','fontsize',14,'interpreter','latex')

%{
  Add in some Gaussian White Noise using the built in function awgn(Signal, Signal-Noise ratio)
  https://octave.sourceforge.io/communications/function/awgn.html

  must run "pkg load communications" before this function can work

  I have different M's as I am playing with how to "Mess up" the data
%}

[x, y] = size(A);

%{
  1%, 5%, 10%, 25%, Target of 50%: 674 iterations
  10%, 25%, 40%, 55%, Target of 75%: 1696 iterations

  1722 iterations / 507.732 seconds
%}

B = A .* (sprand(x,y,0.15)+ 1);
C = A .* (sprand(x,y,0.30)+ 1);
D = A .* (sprand(x,y,0.45)+ 1);
E = A .* (sprand(x,y,0.60)+ 1);
M = A .* (sprand(x,y,0.75)+ 1);


%{
  Didn't get a very good Low Rank Approximation but it was a lot better

B = awgn(A, 15, 'measured');
C = awgn(A, 10, 'measured');
D = awgn(A, 5, 'measured');
E = awgn(A, 1, 'measured');
M = awgn(A, 0.5, 'measured');
%}

%{
  373 iterations / 103.944 seconds

B = mat2gray(A);
randBx = randi([1,x]);
randBy = randi([1,y]);
randB2 = randi([50,200]);
for i = randBy:min(randBy+randB2,y)
  for j = randBx:min(randBx+randB2,x)
    B(j,i) = 1;
  endfor
endfor

C = mat2gray(A);
randCx = randi([1,x]);
randCy = randi([1,y]);
randC2 = randi([50,200]);
for i = randCy:min(randCy+randC2,y)
  for j = randCx:min(randCx+randC2,x)
    C(j,i) = 1;
  endfor
endfor

D = mat2gray(A);
randDx = randi([1,x]);
randDy = randi([1,y]);
randD2 = randi([50,200]);
for i = randDy:min(randDy+randD2,y)
  for j = randDx:min(randDx+randD2,x)
    D(j,i) = 1;
  endfor
endfor

E = mat2gray(A);
randEx = randi([1,x]);
randEy = randi([1,y]);
randE2 = randi([50,200]);
for i = randEy:min(randEy+randE2,y)
  for j = randEx:min(randEx+randE2,x)
    E(j,i) = 1;
  endfor
endfor

M = mat2gray(A);
randMx = randi([80,500]);
randMy = randi([150,550]);
randM2 = randi([100,300]);
for i = randMy:min(randMy+randM2,y)
  for j = randMx:min(randMx+randM2,x)
    M(j,i) = 1;
  endfor
endfor
%}
% Plot the original image with noise
figure;
imshow(mat2gray(B));
%imshow(B);
title('Corrupted Image B','fontsize',14,'interpreter','latex')
imwrite(mat2gray(B),'Buddy_Images/Noise_Corruption/Corrupted_ImageB.jpg')

figure;
imshow(mat2gray(C));
%imshow(C);
title('Corrupted Image C','fontsize',14,'interpreter','latex')
imwrite(mat2gray(C),'Buddy_Images/Noise_Corruption/Corrupted_ImageC.jpg')

figure;
imshow(mat2gray(D));
%imshow(D);
title('Corrupted Image D','fontsize',14,'interpreter','latex')
imwrite(mat2gray(D),'Buddy_Images/Noise_Corruption/Corrupted_ImageD.jpg')

figure;
imshow(mat2gray(E));
%imshow(E);
title('Corrupted Image E','fontsize',14,'interpreter','latex')
imwrite(mat2gray(E),'Buddy_Images/Noise_Corruption/Corrupted_ImageE.jpg')

figure;
imshow(mat2gray(M));
%imshow(M);
title('Target Corrupted Image M','fontsize',14,'interpreter','latex')
imwrite(mat2gray(M),'Buddy_Images/Noise_Corruption/Corrupted_ImageM.jpg')

% Vectorize the images into a single matrix
Z = [B(:), C(:), D(:), E(:), M(:)];

%Call the ALM function to run the algorithm
tic();
[L, S] = ALM(Z);
toc()

% Unvectorize the matrix to get the individual images back
B = reshape(L(:,1), x, y);
C = reshape(L(:,2), x, y);
D = reshape(L(:,3), x, y);
E = reshape(L(:,4), x, y);
L = reshape(L(:,5), x, y);
S = reshape(S(:,5), x, y);

figure;
imshow(mat2gray(B));
title('Low Rank Image B','fontsize',14,'interpreter','latex')
imwrite(mat2gray(B),'Buddy_Images/Noise_Corruption/Fixed_ImageB.jpg')

figure;
imshow(mat2gray(C));
title('Low Rank Image C','fontsize',14,'interpreter','latex')
imwrite(mat2gray(C),'Buddy_Images/Noise_Corruption/Fixed_ImageC.jpg')

figure;
imshow(mat2gray(D));
title('Low Rank Image D','fontsize',14,'interpreter','latex')
imwrite(mat2gray(D),'Buddy_Images/Noise_Corruption/Fixed_ImageD.jpg')

figure;
imshow(mat2gray(E));
title('Low Rank Image E','fontsize',14,'interpreter','latex')
imwrite(mat2gray(E),'Buddy_Images/Noise_Corruption/Fixed_ImageE.jpg')

figure;
imshow(mat2gray(L));
title('Low Rank Target Image M','fontsize',14,'interpreter','latex')
imwrite(mat2gray(L),'Buddy_Images/Noise_Corruption/LowRank_ImageM.jpg')

figure;
imshow(mat2gray(S));
title('Sparse Target Image M','fontsize',14,'interpreter','latex')
imwrite(mat2gray(S),'Buddy_Images/Noise_Corruption/Sparse_ImageM.jpg')
