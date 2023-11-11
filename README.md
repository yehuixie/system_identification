# 系统辨识课程代码

参考课本：方崇智, 萧德云. 过程辨识[M]. 清华大学出版社, 1988.

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

## Chapter5 最小二乘辨识方法

### 5.1 最小二乘一次完成法

- code：`./chapter5/5.1 least_square/least_square.m`

### 5.2 最小二乘递推法

- code：`./chapter5/5.2 recursive_least_square/recursive_least_square.m`

### 5.3 增广最小二乘递推法（考虑有色噪声）

- code：`./chapter5/5.3 recursive_extended_least_square/recursive_extended_least_square.m`

## Chapter7 梯度校正参数辨识

### 7.1 梯度校正参数辨识

- code：`./chapter7/7.1 recursive_gradient_correction/recursive_gradient_correction.m`

## Chapter8 极大似然估计法参数辨识

### 8.1 newton-raphson法

- 没找到可以抄的，随便弄了个随机牛顿法

### 8.2 递推的极大似然估计法

- code：`./chapter8/8.2 recursive_maximum_likelihood/recursive_maximum_likelihood.m`

## Chapter13 模型阶次的确定

### 13.1 F检验法

- code：`./chapter13/13.1 F_test/F_test.m`

### 13.2 AIC定阶准则

- code：`./chapter13/13.2 AIC/AIC.m`
