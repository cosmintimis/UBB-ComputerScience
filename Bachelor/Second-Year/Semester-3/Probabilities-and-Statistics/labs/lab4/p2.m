clear all;
clc;
clf;

p = input("Probability of success: ");

while p <= 0 || p >= 1 
    p = input("Probability of success: ");
end

n = input("Number of trials: ");

s = input("Number of simulations: ");

U = rand(n, s);

M = U < p;

X = sum(M);

U_X = unique(X);

n_X = hist(X, length(U_X));

relFreq = n_X / s;

[U_X; relFreq];

hold on
plot(U_X, relFreq, "*");
plot(0:n, binopdf(0:n, n, p), "o");
title("Binomial distribution");
legend("Freq", "PDF");
hold off

