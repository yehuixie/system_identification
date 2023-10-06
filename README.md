# 系统辨识课程代码

参考课本：方崇智, 萧德云. 过程辨识: 清华大学出版社, 1988

## Chapter4 经典辨识方法

### 4.1 阶跃响应法（面积法）

- code：`./chapter4/4.1 step_response/step_response_system_identification.m`
- 添加噪声后就无法辨识，需要将噪声的均值和方差改为0
- 超过2阶的暂时还不行

### 4.2 脉冲响应法（Hankel矩阵）

- code：`./chapter4/4.2 impulse_response/impulse_response_system_identification.m`
- 参考代码：http://t.csdnimg.cn/rXCcY
- 可以辨识任意阶次系统

### 4.3 相关分析法

- code：`./chapter4/4.3 correlation_analysis/correlation_analysis_system_identification.m`
- 参考代码：http://t.csdnimg.cn/Ugr5G
