 clear all;
 clc;

 XP = [22.4, 21.7, 24.5, 23.4, 21.6, 23.3, 22.4, 21.6, 24.8, 20];
 XR = [17.7, 14.8, 19.6, 19.6, 12.1, 14.8, 15.4, 12.6, 14, 12.2];

 n1 = length(XP);
 n2 = length(XR);

 confLevel = input("Confidence level: ");

 alpha = 1 - confLevel;

 s1 = var(XP);
 s2 = var(XR);

 sp2 = ((n1 - 1)*s1 + (n2- 1)*s2) / (n1 + n2 - 2);

 tl = mean(XP) - mean(XR) - tinv(1-(alpha/2), n1 + n2 - 2) * sqrt(1/n1 + 1/n2) * sqrt(sp2);
 tu = mean(XP) - mean(XR) + tinv(1-(alpha/2), n1 + n2 - 2) * sqrt(1/n1 + 1/n2) * sqrt(sp2);

 fprintf("a) The %2.0f%% confidence interval for the true means (sigma1 = sigma2) is (%5.3f, %5.3f)\n", 100 * confLevel, tl ,tu);
 
 c = (s1/n1) / ((s1/n1) + (s2/n2));
 n = ((c^2)/(n1-1) + ((1-c)^2)/(n2-1))^(-1);
 
 tl = mean(XP) - mean(XR) - tinv(1-(alpha/2), n) * sqrt(s1/n1 + s2/n2);
 tu = mean(XP) - mean(XR) + tinv(1-(alpha/2), n) * sqrt(s1/n1 + s2/n2);

 fprintf("b) The %2.0f%% confidence interval for the true means (sigma1 != sigma2) is (%5.3f, %5.3f)\n", 100 * confLevel, tl ,tu);
 
 tl = (1/finv(1-(alpha/2), n1-1, n2-1)) * (s1/s2);
 tu = (1/finv(alpha/2, n1-1, n2-1)) * (s1/s2);
 
 fprintf("c) The %2.0f%% confidence interval for the ratio of the variances is (%5.3f, %5.3f)\n", 100 * confLevel, tl ,tu);
 fprintf("c) The %2.0f%% confidence interval for the ratio of the std is (%5.3f, %5.3f)\n", 100 * confLevel, sqrt(tl) ,sqrt(tu));
 
 















