% 课程：系统辨识
% 日期：2023-10-17
% 姓名：谢晔辉
% 学号：Y30231003
% 作业内容：针对三阶以上系统，采用梯度校正法进行系统辨识，要求原理描述清晰、程序完整，说明程序执行结果。

clc; clear; close;

% Step 1：定义真实系统的参数
a = [1, -1.5, 0.7]'; b=[1, 0.5]'; d = 3;  % 对象参数
na = length(a) - 1; nb = length(b) - 1;  % 模型阶次
theta = [a(2 : na + 1); b];  % 对象参数真值

% Step 2：生成M序列
L = 200;  % 数据长度
fbconnection = [1 0 0 1];
m_sequence = mseq_gen(fbconnection); m_sequence(m_sequence == 0) = -1;
m_sequence = repmat(m_sequence, 1, ceil(L / length(m_sequence)));

% Step 3：系统辨识
uk = zeros(d + nb, 1);  % 输入初值：uk(i)表示u(k - i)
yk = zeros(na, 1);  % 输出初值
theta_hat_1 = zeros(na + nb + 1, 1);  % theta_hat初值
alpha = 1;
c = 0.01;  % 修正因子
for k = 1 : L
    h = [-yk ; uk(d : d + nb)];
    y(k) = h' * theta;  % 采集输出数据
    
    theta_hat(:, k) = theta_hat_1 + alpha * h * (y(k) - h' * theta_hat_1) / (h' * h + c);  % 递推梯度校正算法 对应教材P202 (7.2.12)和P205 (7.2.39)
    
    % 更新数据
    theta_hat_1 = theta_hat(:, k);
    
    for i = d + nb : -1 : 2
        uk(i) = uk(i - 1);
    end
    uk(1) = m_sequence(k);
    
    for i = na : -1 : 2
        yk(i) = yk(i - 1);
    end
    yk(1) = y(k);
end

% Step 4：绘制参数估计值的变化过程
theta_hat(:, end)
figure;
plot(1 : L, theta_hat, LineWidth=0.8);
xlabel(sprintf("k")); ylabel(sprintf("参数估计a、b"));
legend("a_1", "a_2", "b_0", "b_1"); grid on; grid minor;
title(sprintf("参数估计值的变化过程"))