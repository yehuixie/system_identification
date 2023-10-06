% 课程：系统辨识
% 日期：2023-9-29
% 姓名：谢晔辉
% 学号：Y30231003
% 作业内容：选择一个传递函数（二阶以上过程），以其作为真实系统，分别采用非参数辨识方法：阶跃响应法、脉冲响应法、相关分析法。设计程序进行系统辨识，并将其转化为传递函数形式。

clc
clear

% Step1：生成M序列
fbconnection = [1 0 0 0 0 1];
m_sequence = mseq_gen([1 0 0 0 0 1]);
m_sequence = repmat(m_sequence, 1, 4);
m_sequence(m_sequence == 0) = -1;
t = 0:length(m_sequence) - 1;  % 时间范围
T = 1;  % 采样周期
mean_value = mean(m_sequence);
variance = var(m_sequence);
figure;
stairs(m_sequence, 'b', 'LineWidth', 1);
grid on, grid minor;
xlabel(sprintf("时间(s)"));
ylabel(sprintf("幅值"));
title(sprintf("M序列，均值：%.5f，方差：%.5f", mean_value, variance));

% Step 2：定义真实系统的参数
num = 120;
den = [51.46 14.5 1];

% Step 3：生成输出信号
u = m_sequence;
sys = tf(num, den);  % 构建传递函数模型
y = lsim(sys, u, t);  % 通过系统模型模拟输出信号
figure;
plot(t, y, 'b', 'LineWidth', 1);

% Step 4：添加噪声
mean_val = 0;  % 均值
variance = 1;  % 方差
noise = sqrt(variance) * randn(max(size(t)), 1) + mean_val;  % 生成随机噪声
y_noisy = y + noise;  % 添加噪声到输出信号
d_v = var(noise);  % 噪声方差
d_y = var(y);  % 过程输出方差
ratio_vy = sqrt(d_v / d_y);  % 噪信比

% Step 5：系统辨识
g0 = calculateg0(T, 2^(length(fbconnection)) - 1);  % 计算脉冲响应理论值
g1 = calculate_z(2^(length(fbconnection)) - 1, 3, 1, u, y_noisy, T);  % 计算脉冲响应估计值
g = g0 - g1;  % 脉冲响应估计误差
temp = sqrt(sum(g.^2) / sum(g0.^2));

% Step 6：绘制结果
figure;
hold on;
grid on, grid minor;
plot(g0, 'b--', 'LineWidth', 1);
plot(g1, 'r', 'LineWidth', 1);
legend(sprintf("理论值"), sprintf("估计值"), 'Location', 'best');
title(sprintf("信噪比为 %.2f%% 时的辨识结果", ratio_vy * 100));

function g0 = calculateg0(T, Np)
    K = 120;
    T1 = 8.3;
    T2 = 6.2;
    E1 = -T / T1;
    E2 = -T / T2;
    K1 = K / (T1 - T2);
    for k = 1:Np
        temp(k) = K1 * (exp(k * E1) - exp(k * E2));
    end
    g0 = temp;
end

function g1 = calculate_z(Np, r, a, u, z, T)
    for k = 1:Np
        temp = 0;
        for i = (Np + 1):(r + 1) * Np
            temp = temp + u(i - k) * z(i);
        end
        Rmz(k) = temp / (r * Np);
    end
    c = -Rmz(Np - 1);
    for k=1:Np
        temp1(k) = Np * (Rmz(k) + c) / ((Np + 1) * a * a * T);
    end
    g1 = temp1;
end