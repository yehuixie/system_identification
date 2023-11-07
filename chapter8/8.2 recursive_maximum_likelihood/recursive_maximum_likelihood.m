% 课程：系统辨识
% 日期：2023-10-24
% 姓名：谢晔辉
% 学号：Y30231003
% 作业内容：选择二阶以上差分方程描述的系统，针对存在正态分布随机噪声且噪声协方差阵未知的情形，运用极大似然估计法进行系统辨识：
% (1)采用newton-raphson法，要求详细描述辨识步骤及相关计算式。
% (2)采用递推的极大似然估计法，详细描述所用到的递推计算式。
% 给出完整的matlab程序及运行结果。

clc; clear; close;

% Step 1：定义真实系统的参数
a = [1, -1.5, 0.7]'; b=[1, 0.5]'; c=[1, -0.5]'; d = 1;  % 对象参数
na = length(a) - 1; nb = length(b) - 1; nc = length(c) - 1;  % 模型阶次
nn = max(na, nc);  % 用于yf(k - i)、uf(k - i)更新

% Step 2：生成M序列
L = 1000;  % 数据长度
fbconnection = [1 0 0 1];
m_sequence = mseq_gen(fbconnection); m_sequence(m_sequence == 0) = -1;
m_sequence = repmat(m_sequence, 1, ceil(L / length(m_sequence)));

% Step 3：生成噪声
mean_val = 0;  % 均值
variance = 1;  % 方差
noise = sqrt(variance) * randn(L, 1) + mean_val;  % 生成随机噪声

% Step 4：系统辨识
uk = zeros(d + nb, 1);  % 输入初值：uk(i)表示u(k - i)
yk = zeros(na, 1);  % 输出初值
xik = zeros(nc, 1);  % 白噪声初值
xiek = zeros(nc, 1);  % 白噪声估计初值
yfk = zeros(nn, 1);  % yf(k-i)
ufk = zeros(nn, 1);  % uf(k-i)
xiefk = zeros(nc, 1);  % ξf(k-i)
u = randn(L, 1);  % 输入采用白噪声序列
theta_hat_1 = zeros(na + nb + 1 + nc, 1);  % theta_hat初值
P = eye(na + nb + 1 + nc);
for k = 1 : L
    y(k) = -a(2 : na + 1)' * yk + b' * uk(d : d + nb) + c' * [noise(k); xik];  % 采集输出数据
        
    % 构造向量
    phi = [-yk; uk(d : d + nb); xiek];
    xie = y(k) - phi' * theta_hat_1;
    phif = [-yfk(1 : na); ufk(d : d + nb); xiefk];
    
    % 递推极大似然参数估计算法 对应教材P246 式(8.2.106)
    K = P * phif / (1 + phif' * P * phif);
    theta_hat(:, k) = theta_hat_1 + K * xie;
    P = (eye(na + nb + 1 + nc) - K * phif') * P;    
        
    yf = y(k) - theta_hat(na + nb + 2 : na + nb + 1 + nc, k)' * yfk(1 : nc);  % yf(k)
    uf = u(k) - theta_hat(na + nb + 2 : na + nb + 1 + nc, k)' * ufk(1 : nc);  % uf(k)
    xief = xie - theta_hat(na + nb + 2 : na + nb + 1 + nc, k)' * xiefk(1 : nc);  % xief(k)
      
    % 更新数据
    theta_hat_1 = theta_hat(:, k);
    
    for i = d + nb : -1 : 2
        uk(i) = uk(i - 1);
    end
    uk(1) = u(k);
    
    for i = na : -1 : 2
        yk(i) = yk(i - 1);
    end
    yk(1) = y(k);
    
    for i = nc : -1 : 2
        xik(i) = xik(i - 1);
        xiek(i) = xiek(i - 1);
        xiefk(i) = xiefk(i - 1);
    end
    xik(1) = noise(k);
    xiek(1) = xie;
    xiefk(1) = xief;
    
    for i = nn : -1 : 2
        yfk(i) = yfk(i - 1);
        ufk(i) = ufk(i - 1);
    end
    yfk(1) = yf;
    ufk(1) = uf;
end

% Step 5：绘制参数估计值的变化过程
theta_hat(:, end)
figure;
plot(1 : L, theta_hat, LineWidth=0.8);
xlabel(sprintf("k")); ylabel(sprintf("参数估计a、b、c"));
legend("a_1", "a_2", "b_0", "b_1", "c_1"); grid on; grid minor;
title(sprintf("参数估计值的变化过程"))