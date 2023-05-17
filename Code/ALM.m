function [L, S] = ALM(Z)
%{
    This function houses the Augmented Lagrange Multiplier Algorithm
    INPUT:
      Matrix Z
        This matrix is a combination of vectorized matrices of multiple "noisy" imagesc

    OUTPUT:
      Low Rank Matrix (L)
      Sparse Matrix (S)
%}

%{
  Declare variables used in the algorithm
    [m, n]: Size of Original Matrix
    mu: Augmented Lagrangian Parameter (Incoherence Parameter)
    lambda: Regularization Parameter
    delta: Termination Parameter
    L: Low Rank Approximation of Orignial Matrix (Defaulted as empty)
    S: Sparse Matrix containing the outliers of the original Matrix (Defaulted as empty)
    Y: Lagrangian Multiplier (Defaulted as empty)
    Count: Number of iterations the algorithm needs to hit the tolerance threshold
%}
  [m, n] = size(Z);
  mu = (m * n) / (4 * sum(abs(Z(:))));
  lambda = 1 / sqrt((max(m,n)));
  delta = 1e-7;
  L = S = Y = zeros(m,n);
  Count = 0;

  % Algorithm 1 from Candes et al.
  while norm(Z - L - S,'fro') > (delta * norm(Z,'fro'))
    L = Thresholding((Z - S + ((mu^-1) * Y)),(1 / mu));
    S = Shrinkage((Z - L + ((mu^-1) * Y)),(lambda / mu));
    Y = Y + (mu * (Z - L - S));
    Count = Count + 1
  endwhile
