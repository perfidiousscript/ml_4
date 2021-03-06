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
X_width = size(X,2);
T1_depth = size(Theta1,1);

ascending_numbers = 1:num_labels;

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

biased_input = [ones(m,1),X];

z_2 = biased_input * Theta1';

layer_1_out = sigmoid( z_2 );

biased_layer_1 = [ones(size(layer_1_out,1),1),layer_1_out];

layer_2_out = sigmoid( biased_layer_1 * Theta2' );

for k = 1:m

  target_label = ascending_numbers == y(k);

  J = J + sum( (-target_label * log( layer_2_out(k,:)' )) - ( 1 - target_label ) * log( 1 - layer_2_out(k,:)' ));

end

inner_reg = sum(sum(Theta1(:,2:end).^2)') + sum(sum(Theta2(:,2:end).^2)');

regularization_term = lambda / (2 * m) * inner_reg;

J = 1 / m * J + regularization_term;

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

y_matrix = y == ascending_numbers;

delta_3 = layer_2_out - y_matrix;

delta_2 = (delta_3 * Theta2(:,2:end)) .* sigmoidGradient(z_2);

big_delta_1 = delta_2' * biased_input;

big_delta_2 = delta_3' * biased_layer_1;

Theta1(:,1) = 0 ;

Theta2(:,1) = 0 ;

T_1_reg = (lambda / m) * Theta1;

T_2_reg = (lambda / m) * Theta2;

Theta1_grad = (1 / m) * big_delta_1;

Theta2_grad = (1 / m) * big_delta_2;

Theta1_grad = Theta1_grad + T_1_reg;

Theta2_grad = Theta2_grad + T_2_reg;


% Part 3: Implement regularization with the cost function and gradients.
%
%         Hint: You can implement this around the code for
%               backpropagation. That is, you can compute the gradients for
%               the regularization separately and then add them to Theta1_grad
%               and Theta2_grad from Part 2.
%









% -------------------------------------------------------------

% =========================================================================

% Unroll gradients
grad = [Theta1_grad(:) ; Theta2_grad(:)];


end
