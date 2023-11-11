function m_sequence = mseq_gen(fbconnection)
%MSEQ_GEN 生成M序列
N = length(fbconnection);  % M序列的阶数
% 初始化寄存器
register = ones(1, N);
% 生成M序列
m_sequence = zeros(1, 2^N-1);
for i = 1:2^N-1
    m_sequence(i) = register(end);
    feedback = mod(sum(fbconnection.*register),2);
    register = circshift(register, [0 1]);
    register(1) = feedback;
end

