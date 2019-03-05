function [ma,mi,med,avg,v] = stats(x)
ma = max(x);
mi = min(x);
med = median(x);
n = length(x);
avg = sum(x)/n;
v = var(x);
end