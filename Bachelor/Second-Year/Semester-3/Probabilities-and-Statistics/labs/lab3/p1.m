clear all;
clc;

s = input("1. Normal\n2. Student\n3. Chi2\n4. Fisher\nSelect the model: ", "s");
alpha = input("alpha = ");
beta = input("beta = ");

switch s
    case "1"
        fprintf("Normal model\n");
        
        mu = input("mu = ");
        sigma = input("sigma = ");
        
        a1 = normcdf(0, mu, sigma);
        a2 = 1 - a1;

        b1 = normcdf(1, mu, sigma) - normcdf(-1, mu, sigma);
        b2 = 1 - b1;

        c = norminv(alpha, mu, sigma);

        d = norminv(1 - beta, mu, sigma);

    case "2"
        fprintf("Student model\n");
        
        n = input("n = ");
        
        a1 = tcdf(0, n);
        a2 = 1 - a1;

        b1 = tcdf(1, n) - tcdf(-1, n);
        b2 = 1 - b1;

        c = tinv(alpha, n);

        d = tinv(1 - beta, n);

    case "3"
        fprintf("Chi2 model\n");
        
        n = input("n = ");
        
        a1 = chi2cdf(0, n);
        a2 = 1 - a1;

        b1 = chi2cdf(1, n) - chi2cdf(-1, n);
        b2 = 1 - b1;

        c = chi2inv(alpha, n);

        d = chi2inv(1 - beta, n);

    case "4"  
        fprintf("Fisher model\n");
       
        m = input("m = ");
        n = input("n = ");
        
        a1 = fcdf(0, m, n);
        a2 = 1 - a1;

        b1 = fcdf(1, m, n) - fcdf(-1, m, n);
        b2 = 1 - b1;

        c = finv(alpha, m , n);
        
        d = finv(1 - beta, m , n);

    otherwise
        fprintf("No model selected\n");
end

fprintf("P(x <= 0) = %9.5f\n", a1);
fprintf("P(x >= 0) = %9.5f\n", a2);

fprintf("P(-1 <= x <= 1) = %9.5f\n", b1);
fprintf("P(x <= -1 or x >= 1) = %9.5f\n", b2);

fprintf("P(x < xa) = P(x <= xa) = alpha\nxa = %9.5f\n", c)

fprintf("P(x > xb) = P(x >= xb) = beta\nxb = %9.5f\n", d)