% 课程：系统辨识
% 日期：2023-9-29
% 姓名：谢晔辉
% 学号：Y30231003
% 作业内容：选择一个传递函数（二阶以上过程），以其作为真实系统，分别采用非参数辨识方法：阶跃响应法、脉冲响应法、相关分析法。设计程序进行系统辨识，并将其转化为传递函数形式。

clc
clear

% Step 1：设置采样时间
T = 0.01;  % 采样周期
t = 0:T:50; % 时间范围

% Step 2：定义真实系统
num = 1;
den = [10 7 4 1];

% Step 3：生成输出信号
sys = tf(num, den);  % 构建传递函数模型
discrete_sys = c2d(sys, T);  % 离散化
[y, ~] = impulse(discrete_sys);

% Step 4：系统辨识
n = 3;  % 系统阶次
H = zeros(n, n);
for i = 1:n  % 构造Hankel矩阵
    for j = 1:n
        H(i, j) = y(i + j);
    end
end
if det(H) == 0
    disp('Hankel矩阵奇异，无法求逆');
else
    A = -H \ y(2 + n:2 + n + n - 1);  % 对应书P98 公式(4.3.45) 等价于 -inv(H) * y(2 + n:2 + n + n - 1);
    tm = eye(n, n);
    for i = 1:n
        for j = 1:i-1
            tm(i, j) = A(n + j - i + 1);
        end
    end
    B = tm * y(2:2 + n - 1);  % 对应书P98 公式(4.3.46)
    discrete_num = B';
    discrete_den = ones(1, n + 1);
    for i = 2:n + 1
        discrete_den(i) = A(n + 2 - i);
    end
    estimated_discrete_sys = tf(discrete_num, discrete_den, T);  % 创建1个采样时间为T的离散时间传递函数
end
estimated_sys = d2c(estimated_discrete_sys, 'tustin');  % 辨识出的传递函数

% Step 5：绘制结果
figure;
step(sys, 'b--', T * estimated_sys, 'r');  % 绘制辨识结果和真实系统的阶跃响应
legend('真实系统', '辨识结果');
grid on, grid minor;

sys
estimated_sys