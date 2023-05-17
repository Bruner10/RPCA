function S_O = Shrinkage(A,t)
%{
    This function handles the Shrinkage Operation from equation 5.2 in Candes et al.

    This function takes in a Matrix A and an operator t and outputs a Matrix S_O
%}

  S_O = sign(A) .* max(abs(A) - t,0);
