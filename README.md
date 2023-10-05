# 系统辨识课程代码

参考课本：方崇智, 萧德云. 过程辨识: 清华大学出版社, 1988

## Chapter4 经典辨识方法

### 4.1 阶跃响应法（面积法）

- code：`./chapter4/step_response/step_response_system_identification.m`
- 添加噪声后就无法辨识，需要将噪声的均值和方差改为0
- 超过2阶的暂时还不行