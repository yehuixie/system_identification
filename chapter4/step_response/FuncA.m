function [A] = FuncA(st, hstar, Alist, i)
%FUNCM 计算Mi
%   param st:       采样时间序列
%   param hstar:    系统响应序列
%   param alist:    1~i-1的A序列
%   param i:        下标(i>3)
%   return A:       输出

T = length(st);             % 采样数量
lenA = length(Alist);       % 先前A序列数量
deltaT = (st(end))/(T-1);   % 积分转求和
a1 = 0;                     % 前半部分
a2 = 0;                     % 后半部分

if i < 2 || lenA < 1
    error("只能从A2开始求，并且需要提供A1");
end

for t=1:T-1
    a11 = (1-hstar(t))*((-st(t)).^(i-1))/(factorial(i-1));
    a12 = (1-hstar(t+1))*((-st(t+1)).^(i-1))/(factorial(i-1));
    a1 = a1 + ((a11 + a12)/2) * deltaT;
end

for j=0:i-2
    for t=1:T-1
        a21 = (1-hstar((t)))*((-st(t)).^j)/(factorial(j));
        a22 = (1-hstar((t+1)))*((-st(t+1)).^j)/(factorial(j));
        a2 = a2 + ((a21 + a22)/2 )* deltaT;
    end
    a2 = Alist(i-j-1) * a2;
end

A = a1 + a2;