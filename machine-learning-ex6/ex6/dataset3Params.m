function [C, sigma] = dataset3Params(X, y, Xval, yval)
%EX6PARAMS returns your choice of C and sigma for Part 3 of the exercise
%where you select the optimal (C, sigma) learning parameters to use for SVM
%with RBF kernel
%   [C, sigma] = EX6PARAMS(X, y, Xval, yval) returns your choice of C and
%   sigma. You should complete this function to return the optimal C and
%   sigma based on a cross-validation set.
%

% You need to return the following variables correctly.
C = 1;
sigma = 0.3;

% ====================== YOUR CODE HERE ======================
% Instructions: Fill in this function to return the optimal C and sigma
%               learning parameters found using the cross validation set.
%               You can use svmPredict to predict the labels on the cross
%               validation set. For example,
%                   predictions = svmPredict(model, Xval);
%               will return the predictions on the cross validation set.
%
%  Note: You can compute the prediction error using
%        mean(double(predictions ~= yval))
%
C_val = [0.01, 0.03,0.1,0.3,1,3,10,30];
sigma_val = [0.01, 0.03,0.1,0.3,1,3,10,30];
error= [];

for c=1:length(C_val)
  for s=1:length(sigma_val)
    model= svmTrain(X, y, C_val(c), @(x1, x2) gaussianKernel(x1, x2, sigma_val(s)));
    predictions = svmPredict(model, Xval);
    error(c,s) = mean(double(predictions ~= yval));
  end
end
error
pause;

[m,index]=min(error(:));
index
sigma_index = floor(index/length(C_val))+1
sigma = sigma_val(sigma_index);
C_index = index - floor(index/length(C_val))*length(C_val)
C = C_val(C_index);







% =========================================================================

end
