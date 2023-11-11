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
a = [1, -1.5, 0.7]'; b=[1, 0.5]'; d = 3;  % 对象参数
na = length(a) - 1; nb = length(b) - 1;  % 模型阶次
theta = [a(2 : na + 1); b];  % 对象参数真值

% Step 2：生成M序列
L = 400;  % 数据长度
fbconnection = [1 0 0 1];
m_sequence = mseq_gen(fbconnection); m_sequence(m_sequence == 0) = -1;
m_sequence = repmat(m_sequence, 1, ceil(L / length(m_sequence)));

% Step 3：生成噪声
mean_val = 0;  % 均值
variance = 1;  % 方差
noise = sqrt(variance) * randn(L, 1) + mean_val;  % 生成随机噪声

% Step 4：系统辨识
uk = zeros(d + nb, 1);  % 输入初值：uk(i)表示u(k-i)
yk = zeros(na, 1);  % 输出初值
xik = zeros(na, 1);  % 白噪声初值ξ
etak = zeros(d + nb, 1);  % 白噪声初值η
u = randn(L, 1);  % 输入采用白噪声序列
xi = sqrt(0.1) * randn(L, 1);  % 白噪声序列ξ
eta = sqrt(0.25) * randn(L, 1);  % 白噪声序列η
theta_hat_1 = zeros(na + nb + 1, 1);  % theta_hat初值
Rk_1 = eye(na + nb + 1);
for k = 1 : L
    phi = [-yk ; uk(d : d + nb)];
    e(k) = a' * [xi(k); xik] - b' * etak(d : d + nb);
    y(k) = phi' * theta + e(k); %采集输出数据
    
    % 随机牛顿算法
    R = Rk_1 + (phi * phi' - Rk_1) / k;
    dR = det(R);
    if abs(dR) < 10^(-6)  % 避免矩阵R非奇异
        R = eye(na + nb + 1);
    end
    IR = inv(R);
    theta_hat(:, k) = theta_hat_1 + IR * phi * (y(k) - phi' * theta_hat_1) / k;
           
    % 更新数据
    theta_hat_1 = theta_hat(:, k);
    Rk_1 = R;
    
    for i = d + nb : -1 : 2
        uk(i) = uk(i - 1);
        etak(i) = etak(i - 1);
    end
    uk(1) = u(k);
    etak(1) = eta(k);  
    
    for i = na : -1 : 2
        yk(i) = yk(i - 1);
        xik(i) = xik(i - 1);
    end
    yk(1) = y(k);
    xik(1) = xi(k);
end

% Step 5：绘制参数估计值的变化过程
theta_hat(:, end)
figure;
plot(1 : L, theta_hat, LineWidth=0.8);
xlabel(sprintf("k")); ylabel(sprintf("参数估计a、b"));
legend("a_1", "a_2", "b_0", "b_1"); grid on; grid minor;
title(sprintf("参数估计值的变化过程"))