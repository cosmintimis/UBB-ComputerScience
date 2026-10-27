clear all;
clc;

p = input("Probability of success: ");

while p <= 0 || p >= 1 
    p = input("Probability of success: ");
end

s = input("Number of simulations: ");

U = rand(1, s);

X = U < p;

U_X = unique(X);

n_X = hist(X, length(U_X));

relFreq = n_X / s;

[U_X; relFreq]