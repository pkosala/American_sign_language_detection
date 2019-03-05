function [ wml ] = windowed_mean( val )
%WINDOWED_MEAN Summary of this function goes here
%   Detailed explanation goes here
val = abs(val);
max_val = max(val) + 0.0000001; %for =0 condition

val1 = val(1:11)/max_val;
val2 = val(12:20)/max_val;
val3 = val(21:30)/max_val;
val4 = val(31:39)/max_val;
val5 = val(40:48)/max_val;


wml = [mean(val1), mean(val2), mean(val3), mean(val4), mean(val5)];



