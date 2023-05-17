% load necessary packages
pkg load image
pkg load communications
clear
%{
  Load the images from the video into separate variables
%}

files = glob('SurveillanceGIF/*.jpg');
files = strrep(files, '\', '/');
for i = 1:numel(files)
  [~, name] = fileparts(files{i});
  eval(sprintf('%s = imread("%s");', name, files{i}));
endfor

%{
  turn each frame into a column vector of Matrix Z
%}

[x, y] = size(frame_00);
Z = [];

%{
  For 20 frames: 5274 iterations
  For 40 frames: 8420 iterations / 2329.72 seconds
%}

for i = 0:39
  frame_name = sprintf('frame_%s',substr(sprintf('00%d',i),-2));
  eval(sprintf('Z = [Z, %s(:)];', frame_name));
endfor

%{
  Was getting the following error so added the line below

  "error: xfrobnorm: wrong type argument 'uint8 matrix'"
%}
Z = double(Z);

tic();
[L, S] = ALM(Z);
toc()

for i = 0:39
  frame_name = sprintf('frame_%s',substr(sprintf('00%d',i),-2));

  eval(sprintf('%s = reshape(L(:,i+1),x,y);', frame_name));
  eval(sprintf('imwrite(mat2gray(%s),"LowRank_Frames/%s.jpg");', frame_name, frame_name));

  eval(sprintf('%s = reshape(S(:,i+1),x,y);', frame_name));
  eval(sprintf('imwrite(mat2gray(%s),"Sparse_Frames/%s.jpg");', frame_name, frame_name));
endfor



