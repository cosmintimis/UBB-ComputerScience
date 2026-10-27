clear all;
clc;
clf;

p = input("Probability of success: ");

while p <= 0 || p >= 1 
    p = input("Probability of success: ");
end

r = input("Number of required successes: ");

while r <= 0 
    r = input("Number of required successes: ");
end

s = input("Number of simulations: ");

X = zeros(1, s);

for i = 1:s
    success_count = 0;
    trial_count = 0;
    while success_count < r
        trial = rand(1);
        trial_count = trial_count + 1;
        if trial <= p
            success_count = success_count + 1;
        end
    end
    X(i) = trial_count;
end

U_X = unique(X);

n_X = hist(X, length(U_X));

relFreq = n_X / s;

[U_X; relFreq];

hold on
plot(U_X, relFreq, "*");
plot(0:max(U_X), nbinpdf(0:max(U_X), r, p), "o");
title("Pascal distribution");
legend("Freq", "PDF");
hold off
