% 课程：系统辨识
% 日期：2023-10-10
% 姓名：谢晔辉
% 学号：Y30231003
% 作业内容： 1）选择一个传递函数表示的对象，分别采用最小二乘法的一次完成法和递推法进行参数模型辨识，详细描述辨识步骤，并给出matlab程序和运行结果。
%           2）针对上述模型，考虑存在有色噪声的情形，运用改进最小二乘法进行辨识建模，并针对不同信噪比情形进行测试，详细描述辨识步骤，并给出matlab程序和运行结果。

clc; clear; close;

% Step 1：定义真实系统的参数
a = [1, -1.5, 0.7]'; b=[1, 0.5]'; c=[1, -1, 0.2]'; d = 3;  % 对象参数
na = length(a) - 1; nb = length(b) - 1; nc = length(c) - 1;  % 模型阶次
theta = [a(2 : na + 1); b; c(2 : nc + 1)];  % 对象参数真值

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
uk = zeros(d + nb, 1);  % 输入初值：uk(i)表示u(k-i)
zk = zeros(na, 1);  % 输出初值
xik = zeros(nc, 1);  % 噪声初值
xiek = zeros(nc, 1);  % 噪声估计初值
theta_hat_1 = zeros(na + nb + 1 + nc, 1);  % theta_hat初值 参考教材P149 式(5.8.20)
P = 10^6 * eye(na + nb + 1 + nc);  % 参考教材P149 式(5.8.20)
for k = 1 : L
    h = [-zk; uk(d : d + nb); xik];
    y(k) = h' * theta + noise(k);  % 得到输出
    
    h_hat = [-zk; uk(d : d + nb); xiek];  % 组建h_hat
    
    % 递推增广最小二乘法 参考教材P173 式(6.4.8)
    K = P * h_hat / (1 + h_hat' * P * h_hat);
    theta_hat(:, k) = theta_hat_1 + K * (y(k) - h_hat' * theta_hat_1);
    P = (eye(na + nb + 1 + nc) - K * h_hat') * P;
    
    xie = y(k) - h_hat' * theta_hat(:, k);  % 噪声的估计值 参考教材P173 式(6.4.7)
    
    % 更新数据
    theta_hat_1 = theta_hat(:, k);
    
    for i = d + nb : -1 : 2
        uk(i) = uk(i - 1);
    end
    uk(1) = m_sequence(k);
    
    for i = na : -1 : 2
        zk(i) = zk(i - 1);
    end
    zk(1) = y(k);
    
    for i = nc : -1 : 2
        xik(i) = xik(i - 1);
        xiek(i) = xiek(i - 1);
    end
    xik(1) = noise(k);
    xiek(1) = xie;
end
d_v = var(noise);  % 噪声方差
d_y = var(y);  % 过程输出方差
ratio_vy = sqrt(d_v / d_y);  % 噪信比

% Step 5：绘制参数估计值的变化过程
theta_hat(:, end)
figure;
plot(1 : L, theta_hat, LineWidth=0.8);
xlabel(sprintf("k")); ylabel(sprintf("参数估计a、b、d"));
legend("a_1", "a_2", "b_0", "b_1", "d_0", "d_1", Location="best"); grid on; grid minor;
title(sprintf("参数估计值的变化过程，噪信比 = %.2f%%", ratio_vy * 100))