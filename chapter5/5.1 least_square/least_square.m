% 课程：系统辨识
% 日期：2023-10-10
% 姓名：谢晔辉
% 学号：Y30231003
% 作业内容： 1）选择一个传递函数表示的对象，分别采用最小二乘法的一次完成法和递推法进行参数模型辨识，详细描述辨识步骤，并给出matlab程序和运行结果。
%           2）针对上述模型，考虑存在有色噪声的情形，运用改进最小二乘法进行辨识建模，并针对不同信噪比情形进行测试，详细描述辨识步骤，并给出matlab程序和运行结果。

clc
clear

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
variance = 0.1;  % 方差
noise = sqrt(variance) * randn(L, 1) + mean_val;  % 生成随机噪声

% Step 4：系统辨识
uk = zeros(d + nb, 1);  % 输入初值：uk(i)表示u(k-i)
zk = zeros(na, 1);  % 输出初值
for k = 1 : L
    HL(k, :) = [-zk; uk(d : d + nb)]';  % 此处HL(k, :)为行向量，便于组成phi矩阵
    z(k) = HL(k, :) * theta + noise(k);  % 得到输出
    
    u(k) = m_sequence(k);

    for i = d + nb : -1 : 2
        uk(i) = uk(i - 1);
    end
    uk(1) = u(k);
    
    for i = na : -1 : 2
        zk(i) = zk(i - 1);
    end
    zk(1) = z(k);
end

theta_hat = (HL'*HL) \ HL'*z'  % 等价于inv(HL'*HL)*HL'*z'