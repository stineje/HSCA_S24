% 
% Finite Difference Example
% ECEN 4233
% 

% clear memory
clear
% clear screen
clc
% format
format long eng
% initial value of Salmon
y = [1000];
% n (years)
n = 20;
% finite difference
for i = 1:n
    y = [y ((1000*(1-0.3^i))/(1-0.3) + 0.3^i * y(1))]
end
% Set up x-axis : (n+1) points
x = 1:n+1;
% plot
plot(x,y)
% axis
xlabel('Years');
ylabel('Salmon');
title('Estimated Stocked Salmon Population');
print -dpng salmon.png
