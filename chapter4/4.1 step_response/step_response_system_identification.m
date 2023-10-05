% 课程：系统辨识
% 日期：2023-9-29
% 姓名：谢晔辉
% 学号：Y30231003
% 作业内容：选择一个传递函数（二阶以上过程），以其作为真实系统，分别采用非参数辨识方法：阶跃响应法、脉冲响应法、相关分析法。设计程序进行系统辨识，并将其转化为传递函数形式。

clc
clear

% Step 1：生成输入信号
t = 0:0.01:50; % 时间范围
u = [ones(max(size(t)), 1)];  % 阶跃输入信号

% Step 2：定义真实系统的参数
num = 1;
den = [10 7 4];

% Step 3：生成输出信号
sys = tf(num, den);  % 构建传递函数模型
y = lsim(sys, u, t);  % 通过系统模型模拟输出信号

% Step 4：添加噪声
mean_val = 0;  % 均值
variance = 0;  % 方差
noise = sqrt(variance) * randn(max(size(t)), 1) + mean_val;  % 生成随机噪声
y = y + noise;  % 添加噪声到输出信号

% Step 5：系统辨识
n = 2;  % 分母阶次
m = 0;  % 分子阶次
M0 = FuncM(t, y / y(end), 0);  % 对应书P88 公式(4.2.18)
A = zeros(1, n + m);
A(1) = M0;
for i = 2:(n + m)
    A(i) = FuncA(t, y / y(end), A(1:i-1), i);
end

% 求b 对应书P89 公式(4.2.24)
b = 0;
if m >= 1
    t1 = zeros(m, m);
    for i = 1:m
        for j = 1:m
            t1(i, j) = A(i + n - j);
        end
    end
    b = -inv(t1) * A(n + 1:n + m)';
end

b_extended = zeros(1, n);
b_extended(1:length(b)) = b;
b = b_extended;

% 求a 对应书P89 公式(4.2.25)
t3 = eye(n, n);
for i = 1:n
    for j = 1:i-1
        t3(i, j) = A(i - j);
    end
end
a = t3 * b' + A(1:n)';

estimated_num = zeros(1, m + 1);
for i = 1:m
    estimated_num(i) = b(m + 1 - i);
end
estimated_num(end) = y(end);
estimated_den = ones(1, n + 1);
for i = 1:n
    estimated_den(i) = a(n + 1 - i);
end
estimated_sys = tf(estimated_num, estimated_den);

% Step 6：绘制结果
figure;
step(sys, 'b--', estimated_sys, 'r');  % 绘制辨识结果和真实系统的阶跃响应
legend('真实系统', '辨识结果');
grid on, grid minor;

sys
estimated_sys