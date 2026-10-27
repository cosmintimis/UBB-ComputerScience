clear all;
clc;
clf;

p = input("Enter a value for p <= 0.05: ");

while p > 0.05
    p = input("Enter a value for p <= 0.05: ");
end

n = input("Enter a value for n >= 30: ");

while n < 30
    n = input("Enter a value for n >= 30: ");
end



k = 0:n;
b = binopdf(k, n, p);
no = poisspdf(k, n*p);

hold on
plot(k, b);
plot(k, no);
title("n = " + n);
legend("bino", "norm");
hold off

pause(0.5);


