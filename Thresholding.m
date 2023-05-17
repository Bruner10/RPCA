function D_O = Thresholding(A,t)
%{
    This function handles the Shrinkage Operation from equation 5.3 in Candes et al.

    This function takes in a Matrix A and operator t and outputs a Matrix D_O

    This function also calls another function Shrinkage that outputs a Matrix S_O
    that is the same size as the input matrix
%}

  [U,Sigma,V] = svd(A, 'econ');
  D_O = U * Shrinkage(Sigma,t) * V';
