基于人工免疫算法的多无人机协同任务分配方法研究
西安交大自动化84班杨恺 毕设代码

基本:
UAV.xlsl:无人机的参数信息
Target.xlsx:任务目标的参数信息
result.xlsm 论文中的一些数据

单目标：
main:单目标SIA算法(把第55、69、83、98行的&&改成#&& 即为单目标IA算法)
InitialSolution:抗体解码为初始解
ModifiedSolution:初始解转化为修正解
Graph:根据任务矩阵返回邻接矩阵
DFS:深度优先算法，返回死锁回路
Lock:以邻接矩阵形式返回死锁次数矩阵
Unlock:去除死锁的函数
Get_mission:抗体经过上述解码修正操作 获得任务分配矩阵
CostRoad:计算航程代价
CostBias:计算偏差代价
Reward:计算任务收益
Cost:计算抗体的目标代价
similar:计算两个抗体的相似度
concentration:计算抗体浓度
fitness:计算抗体适应度
bestselect:将优秀抗体储存到记忆库
select:根据轮盘赌选择繁衍的抗体
mutate:变异
cross:交叉
reverse:反转
exchange:交换
Test:判断抗体的值是否合理
Affinity_old:返回前50次迭代的平均亲和度

多目标:
main_bias:最小偏差子问题求解
main_road:最小航程子问题求解
main_reward:最大收益子问题求解 
(ps 采用分组进化则需把上述3个算法求解的抗体群保存，导入到Pareto_main中，并且将随机初始化代码注释)
Pareto_main:多目标SIA算法 (把第74、104、135行的&&改成#&&即为多目标IA算法) 
Cost_Road:多目标航程代价
Cost_Bias:多目标时间偏差
Cost_Reward:多目标任务收益
Cost_new:多目标问题的代价函数
FreshPareto:更新Pareto最优解集
Affinity_new:计算多目标任务亲和度

其他(毕设没用到)：
PSO:粒子群算法求解MTAP
Time_array:返回到达指定任务地点的时间矩阵
Active:根据张的文章 编写的解决有新目标出现的局部重分配算法
New_target.xlsx:临时发现的新任务目标
Draw:画甘特图的 太丑了

ps.未知原因会导致算法报错,跑10次代码会可能遇到一次 重新运行即可

