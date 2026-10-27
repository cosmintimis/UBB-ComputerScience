clear all;
clc;

XP = [22.4, 21.7, 24.5, 23.4, 21.6, 23.3, 22.4, 21.6, 24.8, 20];
XR = [17.7, 14.8, 19.6, 19.6, 12.1, 14.8, 15.4, 12.6, 14, 12.2];

n1 = length(XP);
n2 = length(XR);

alpha = input("Significance level: ");

tt1 = finv(alpha/2, n1-1, n2-1);
tt2 = finv(1-(alpha/2), n1-1, n2-1);

fprintf("\na)\n\n")

[h, p, ci, stats] = vartest2(XP, XR, alpha, 0);

fprintf("h is %d\n", h);
if h == 1
    fprintf("So the hyphotesis is rejected\n");
else
    fprintf("So the hyphotesis is NOT rejected\n");
end
fprintf("The rejection region is (-Inf, %5.4f) U (%5.4f, Inf)\n", tt1, tt2);
fprintf("The value of the test statistic is %5.4f\n", stats.fstat);
fprintf("P value is %5.4f\n", p);


fprintf("\nb)\n\n")

[h, p, ci, stats] = ttest2(XP, XR, alpha, "right", "equal");

rr = tinv(1-alpha, n1+n2-2);

fprintf("h is %d\n", h);
if h == 1
    fprintf("So the hyphotesis is rejected\n");
else
    fprintf("So the hyphotesis is NOT rejected\n");
end
fprintf("The rejection region is (%5.4f, Inf)\n", rr);
fprintf("The value of the test statistic is %5.4f\n", stats.tstat);
fprintf("P value is %5.10f\n", p);






