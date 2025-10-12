clear all;
clc;
clf;

p = input("Probability of success: ");

while p <= 0 || p >= 1 
    p = input("Probability of success: ");
end

s = input("Number of simulations: ");

X = zeros(1, s);

for i = 1:s
    c = 0;
    a = 10;
    while a >= p
        a = rand(1);
        if a >= p
            c = c + 1;
        end
    end
    X(i) = c;
end


U_X = unique(X);

n_X = hist(X, length(U_X));

relFreq = n_X / s;

[U_X; relFreq];

hold on
plot(U_X, relFreq, "*");
plot(0:max(U_X), geopdf(0:max(U_X), p), "o");
title("Geometric distribution");
legend("Freq", "PDF");
hold off

