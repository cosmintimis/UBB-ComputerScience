clear all;
clc;

X = [7, 7, 4, 5, 9, 9, 4, 12, 8, 1, 8, 7, 3, 13, 2, 1, 17, 7, 12, 5, 6, 2, 1, 13, 14, 10, 2, 4, 9, 11, 3, 5, 12, 6, 10, 7];

sigma = 5;
alpha = input("Significance level: ");

tta = norminv(alpha);

[h,p,ci,zval] = ztest(X, 8.5, sigma, alpha, -1);

fprintf("\na)\n\n")

fprintf("h is %d\n", h);
if h == 1
    fprintf("So the hyphotesis is rejected\n");
else
    fprintf("So the hyphotesis is NOT rejected\n");
end
fprintf("The rejection region is (%5.4f, %5.4f)\n", -Inf, tta);
fprintf("The value of the test statistic is %5.4f\n", zval);
fprintf("P value is %5.4f\n", p);



tta = tinv(1-alpha, length(X) - 1);

[h,p,ci,stats] = ttest(X, 5.5, alpha, 1);

fprintf("\nb)\n\n")

fprintf("h is %d\n", h);
if h == 1
    fprintf("So the hyphotesis is rejected\n");
else
    fprintf("So the hyphotesis is NOT rejected\n");
end
fprintf("The rejection region is (%5.4f, %5.4f)\n", tta, Inf);
fprintf("The value of the test statistic is %5.4f\n", stats.tstat);
fprintf("P value is %5.4f\n", p);


