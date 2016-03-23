function [J grad] = nnCostFunction(nn_params, ...
                                   input_layer_size, ...
                                   hidden_layer_size, ...
                                   num_labels, ...
                                   X, y, lambda)
%NNCOSTFUNCTION Implements the neural network cost function for a two layer
%neural network which performs classification
%   [J grad] = NNCOSTFUNCTON(nn_params, hidden_layer_size, num_labels, ...
%   X, y, lambda) computes the cost and gradient of the neural network. The
%   parameters for the neural network are "unrolled" into the vector
%   nn_params and need to be converted back into the weight matrices.
%
%   The returned parameter grad should be a "unrolled" vector of the
%   partial derivatives of the neural network.
%

% Reshape nn_params back into the parameters Theta1 and Theta2, the weight matrices
% for our 2 layer neural network
Theta1 = reshape(nn_params(1:hidden_layer_size * (input_layer_size + 1)), ...
                 hidden_layer_size, (input_layer_size + 1));

Theta2 = reshape(nn_params((1 + (hidden_layer_size * (input_layer_size + 1))):end), ...
                 num_labels, (hidden_layer_size + 1));

% Setup some useful variables
m = size(X, 1);

% You need to return the following variables correctly
J = 0;
Theta1_grad = zeros(size(Theta1));
Theta2_grad = zeros(size(Theta2));

% ====================== YOUR CODE HERE ======================
% Instructions: You should complete the code by working through the
%               following parts.
%
% Part 1: Feedforward the neural network and return the cost in the
%         variable J. After implementing Part 1, you can verify that your
%         cost function computation is correct by verifying the cost
%         computed in ex4.m
%
% Part 2: Implement the backpropagation algorithm to compute the gradients
%         Theta1_grad and Theta2_grad. You should return the partial derivatives of
%         the cost function with respect to Theta1 and Theta2 in Theta1_grad and
%         Theta2_grad, respectively. After implementing Part 2, you can check
%         that your implementation is correct by running checkNNGradients
%
%         Note: The vector y passed into the function is a vector of labels
%               containing values from 1..K. You need to map this vector into a
%               binary vector of 1's and 0's to be used with the neural network
%               cost function.
%
%         Hint: We recommend implementing backpropagation using a for-loop
%               over the training examples if you are implementing it for the
%               first time.
%
% Part 3: Implement regularization with the cost function and gradients.
%
%         Hint: You can implement this around the code for
%               backpropagation. That is, you can compute the gradients for
%               the regularization separately and then add them to Theta1_grad
%               and Theta2_grad from Part 2.
%

% Part1
ones=ones(m,1);
X_bias = [ones,X];
image_by_theta1 = sigmoid(Theta1*X_bias');
image_by_theta1 = [ones, image_by_theta1'];
image_by_theta2 = sigmoid(Theta2*image_by_theta1');
% 10 par 5000

y_k = zeros(m,num_labels);
for i=1:m
  y_k(i,y(i))=1;
end

cost = -y_k.*log(image_by_theta2')-(1-y_k).*log(1-image_by_theta2');
% Unregularized cost
J = 1/m * sum(sum(cost,2));
% Regularization term
squared_theta1 = Theta1.**2;
squared_theta2 = Theta2.**2;
reg = lambda/(2*m)*(sum(sum(squared_theta1,2))-sum(squared_theta1(:,1)) + sum(sum(squared_theta2,2))-sum(squared_theta2(:,1)));
% we don't regularize for terms that correspond to bias
J = J + reg;


% Part2
capital_delta_two = zeros(num_labels,hidden_layer_size+1);
capital_delta_one = zeros(hidden_layer_size,input_layer_size+1);
for t = 1:m
  % step 1: feedforward
  a_one = [1,X(t,:)];
  z_two = Theta1*a_one';
  a_two = sigmoid(z_two);
  a_two = [1, a_two'];
  z_three = Theta2*a_two';
  a_three = sigmoid(z_three);
  % step 2: error term in output layer
  delta_three = zeros(num_labels,1);
  y_t = zeros(num_labels,1);
  y_t(y(t))=1;
  delta_three = a_three-y_t;%10 by 1
  % step 3: error term in hidden layer
  delta_two = Theta2'*delta_three.*[0;sigmoidGradient(z_two)];%26 by 1
  % step 4
  capital_delta_two = capital_delta_two + delta_three*a_two;
  capital_delta_one = capital_delta_one + delta_two(2:end)*[1,X(t,:)];
end
% step 5
Theta2_grad = 1/m * capital_delta_two;
Theta1_grad = 1/m * capital_delta_one;

% Regularized Neural Network
Theta2_grad = Theta2_grad + lambda/m*[zeros(num_labels,1),Theta2(:,2:end)];
Theta1_grad = Theta1_grad + lambda/m*[zeros(hidden_layer_size,1),Theta1(:,2:end)];
% -------------------------------------------------------------

% =========================================================================

% Unroll gradients
grad = [Theta1_grad(:) ; Theta2_grad(:)];


end
