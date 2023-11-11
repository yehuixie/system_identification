% 课程：系统辨识
% 日期：2023-10-31
% 姓名：谢晔辉
% 学号：Y30231003
% 作业内容：选择差分方程表示的SISO线性系统，在存在噪声的情况下：
%（1）利用F检验法进行模型阶次的辨识。
%（2）利用AIC准则进行模型定阶。
% 详细描述步骤及结果。

clc; clear; close;

% Step 1：获得输入输出
load u2.mat; load z2.mat; load noise2.mat;
L = max(size(noise));

% Step 2：系统辨识
for na = 1 : 4
    for nb = 1 : 4
        uk = zeros(nb, 1);  % 输入初值：uk(i)表示u(k-i)
        zk = zeros(na, 1);  % 输出初值
        HL = zeros(L, na + nb);
        for k = 1 : L
            HL(k, :) = [-zk; uk]';
        
            for i = nb : -1 : 2
                uk(i) = uk(i - 1);
            end
            uk(1) = u(k);
        
            for i = na : -1 : 2
                zk(i) = zk(i - 1);
            end
            zk(1) = z(k);
        end
        theta_hat = (HL'*HL) \ HL'*z';  % 等价于inv(HL'*HL)*HL'*z'
        V = (1 / L) * (z' - HL * theta_hat)' * (z' - HL * theta_hat);
        AIC_(na, nb) = L * log(V) + 2 * (na + nb)
    end
end