clear all;
clc;

X = [7, 7, 4, 5, 9, 9, 4, 12, 8, 1, 8, 7, 3, 13, 2, 1, 17, 7, 12, 5, 6, 2, 1, 13, 14, 10, 2, 4, 9, 11, 3, 5, 12, 6, 10, 7];

n = length(X);

sigma = 5;

confLevel = input("Confidence level: ");

alpha = 1 - confLevel;

tl = mean(X) - norminv(1-(alpha/2)) * (sigma/sqrt(n));
tu = mean(X) - norminv(alpha/2) * (sigma/sqrt(n));

fprintf("a) The %2.0f%% confidence interval for the mean (sigma known) is (%5.3f, %5.3f)\n", 100 * confLevel, tl ,tu);

s = std(X);

tl = mean(X) - tinv(1-(alpha/2), n-1) * (s/sqrt(n));
tu = mean(X) - tinv(alpha/2, n-1) * (s/sqrt(n));

fprintf("b) The %2.0f%% confidence interval for the mean (sigma unknown) is (%5.3f, %5.3f)\n", 100 * confLevel, tl ,tu);

s2 = var(X);

tl = ((n-1) * s2) / chi2inv(1-(alpha/2), n-1);
tu = ((n-1) * s2) / chi2inv(alpha/2, n-1);

fprintf("c) The %2.0f%% confidence interval for variance is (%5.3f, %5.3f)\n", 100 * confLevel, tl ,tu);

tl = sqrt(tl);
tu = sqrt(tu);
fprintf("   The %2.0f%% confidence interval for std is (%5.3f, %5.3f)\n", 100 * confLevel, tl ,tu);



