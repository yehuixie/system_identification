function [M] = FuncM(st, hstar, i)
%FUNCM 计算Mi
%   param st:       采样时间序列
%   param hstar:    系统响应序列
%   param i:        下标
%   return M:       输出

T = length(st); % 采样数量
deltaT = (st(end))/(T-1);
M = 0;
for t=1:T-1  % 对应书P88 公式(4.2.18)
    y1 = (1-hstar(t))*((-st(t)).^i)/(factorial(i));
    y2 = (1-hstar(t+1))*((-st(t+1)).^i)/(factorial(i));
    M = M + ((y1 + y2)/2 )* deltaT;
end