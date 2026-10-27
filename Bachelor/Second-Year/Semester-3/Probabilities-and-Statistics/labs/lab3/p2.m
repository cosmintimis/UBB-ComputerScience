clear all;
clc;
clf;

p = input("Enter a value between 0.05 and 0.95: ");

while p < 0.05 || p > 0.95
    p = input("Enter a value between 0.05 and 0.95: ");
end


for n=1:100
    clf;
    k = 0:n;
    b = binopdf(k, n, p);
    no = normpdf(k, n*p, sqrt(n*p*(1-p)));

    hold on
    plot(k, b);
    plot(k, no);
    title("n = " + n);
    legend("bino", "norm");
    hold off

    pause(0.5);

end

