clear all;
clc;

n = 3;
p = .5;

s = input("Nr of simulations: ");

r = rand(3,s) < 0.5;

sum(r);

hist(sum(r))



