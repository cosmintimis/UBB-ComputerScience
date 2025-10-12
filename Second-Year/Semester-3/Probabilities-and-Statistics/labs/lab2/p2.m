clear all;
clc;
clf;

n = input("Nr of trials = ");
p = input("Probability of succes = ");
k = 0:n;

px = binopdf(k, n, p);

hold on;
plot(k ,px, "*");

x = 0:0.01:n;

fx = binocdf(x, n, p);

plot(x, fx);

title("Pdf and Cdf function");
legend("Pdf", "Cdf");
hold off;