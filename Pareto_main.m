clear;clc;
%% 读取数据
X=xlsread('UAV_4.xlsx');
plane=struct('pos',0,'p',0,'max',0,'v',0);
plane.pos=X(:,1:2);     %飞机的起始位置
plane.p=X(:,3);         %飞机的打击成功率
plane.num=X(:,4);       %飞机的最大任务数
plane.v=X(:,5);         %飞机的飞行速率

X=xlsread('Target_4.xlsx');
target=struct('pos',0,'val',0,'win',0,'t',0,'num',0);
target.pos=X(:,1:2);    %任务点的位置
target.val=X(:,3);      %任务的价值
target.win=X(:,4:5);    %任务的时间窗口
target.t=X(:,6);        %任务的用时
target.num=X(:,7);      %需要无人机的数量

%% 参数设定
maxgen=300;     %最大迭代次数
sizepop=100;    %种群规模
sizemem=20;     %记忆库容量
Bias=0.1;       %偏置项，让适应度函数为正
%初始化抗体
antibody_len=sum(target.num(:));
antibody=zeros(sizepop,antibody_len);
for i=1:sizepop
    antibody(i,:)=rand(1,antibody_len)*size(plane.num,1)+1;
end
affinity=zeros(1,sizepop);
best_mission=Get_mission(plane,target,antibody(1,:));
[best_road,best_bias,best_reward]=Cost_new(plane,target,best_mission);
pareto_mission=zeros(size(Get_mission(plane,target,antibody(1,:))));
pareto_antibody=zeros(size(antibody));
for i=1:sizepop
    mission=Get_mission(plane,target,antibody(i,:));
    [cost_road,cost_bias,cost_reward]=Cost_new(plane,target,mission); %获取抗体的各类代价以及任务矩阵
    if cost_road<best_road
        best_road=cost_road;
    end
    if cost_bias<best_bias
        best_bias=cost_bias;
    end
    if cost_reward<best_reward
        best_reward=cost_reward;
    end
    affinity(i)=Affinity_new(cost_road,cost_bias,cost_reward,best_road,best_bias,best_reward,Bias);
    [cost_road,cost_bias,cost_reward]=Cost_new(plane,target,best_mission);
    best_fit=Affinity_new(cost_road,cost_bias,cost_reward,best_road,best_bias,best_reward,Bias);
    if affinity(i)>best_fit
        best_mission=mission;
        best_fit=affinity(i);
        [pareto_mission,pareto_antibody]=FreshPareto(pareto_mission,pareto_antibody,mission,antibody(i,:),plane,target );
    end
end

for gen=1:maxgen
    disp(['迭代次数:',num2str(gen)]);
    antibody_new=[];    
    if gen<=1
        a = 1;
    end
    if gen>1
        a = exp((best_fit-Affinity_old(best_fit_gen,gen))/Affinity_old(best_fit_gen,gen));
    end
    b=2-gen/maxgen;
    memory=bestselect(antibody,affinity,sizemem);                %将最佳的个体保存在记忆库中
    antibody_select=select(antibody,affinity,sizepop-sizemem);           %对种群进行繁衍选择
    antibody_cross=cross(antibody_select,best_fit,affinity,plane);       %交叉操作
    
    for i=1:sizepop-sizemem
        mission=Get_mission(plane,target,antibody_cross(i,:));
        [cost_road,cost_bias,cost_reward]=Cost_new(plane,target,mission);
        new_fitness(i)=Affinity_new(cost_road,cost_bias,cost_reward,best_road,best_bias,best_reward,Bias);
        if affinity(i)>new_fitness(i) && rand>exp(-a*b*(affinity(i)-new_fitness(i))/affinity(i))  %模拟退火
            antibody_cross(i,:)=antibody_select(i,:);
            continue;
        end
        if cost_road<best_road
            best_road=cost_road;
            [pareto_mission,pareto_antibody]=FreshPareto(pareto_mission,pareto_antibody,mission,antibody_cross(i,:),plane,target);
        end
        if cost_bias<best_bias
            best_bias=cost_bias;
            [pareto_mission,pareto_antibody]=FreshPareto(pareto_mission,pareto_antibody,mission,antibody_cross(i,:),plane,target);
        end
        if cost_reward<best_reward
            best_reward=cost_reward;
            [pareto_mission,pareto_antibody]=FreshPareto(pareto_mission,pareto_antibody,mission,antibody_cross(i,:),plane,target);
        end
        affinity(i)=Affinity_new(cost_road,cost_bias,cost_reward,best_road,best_bias,best_reward,Bias);
        [cost_road,cost_bias,cost_reward]=Cost_new(plane,target,best_mission);
        best_fit=Affinity_new(cost_road,cost_bias,cost_reward,best_road,best_bias,best_reward,Bias);
        if affinity(i)>best_fit
            best_mission=mission;
            best_fit=affinity(i);
            [pareto_mission,pareto_antibody]=FreshPareto(pareto_mission,pareto_antibody,mission,antibody_cross(i,:),plane,target);
        end
    end
    antibody_reverse=reverse(antibody_cross);                 %反转操作
    for i=1:sizepop-sizemem
        mission=Get_mission(plane,target,antibody_cross(i,:));
        [cost_road,cost_bias,cost_reward]=Cost_new(plane,target,mission);
        new_fitness(i)=Affinity_new(cost_road,cost_bias,cost_reward,best_road,best_bias,best_reward,Bias);
        if affinity(i)>new_fitness(i) && rand>exp(-a*b*(affinity(i)-new_fitness(i))/affinity(i))  %模拟退火
            antibody_reverse(i,:)=antibody_cross(i,:);
            continue;
        end
        if cost_road<best_road
            best_road=cost_road;
            [pareto_mission,pareto_antibody]=FreshPareto(pareto_mission,pareto_antibody,mission,antibody_reverse(i,:),plane,target);
        end
        if cost_bias<best_bias
            best_bias=cost_bias;
            [pareto_mission,pareto_antibody]=FreshPareto(pareto_mission,pareto_antibody,mission,antibody_reverse(i,:),plane,target);
        end
        if cost_reward<best_reward
            best_reward=cost_reward;
            [pareto_mission,pareto_antibody]=FreshPareto(pareto_mission,pareto_antibody,mission,antibody_reverse(i,:),plane,target);
        end
        affinity(i)=Affinity_new(cost_road,cost_bias,cost_reward,best_road,best_bias,best_reward,Bias);
        [cost_road,cost_bias,cost_reward]=Cost_new(plane,target,best_mission);
        best_fit=Affinity_new(cost_road,cost_bias,cost_reward,best_road,best_bias,best_reward,Bias);
        if affinity(i)>best_fit
            best_mission=mission;
            best_fit=affinity(i);
           [pareto_mission,pareto_antibody]=FreshPareto(pareto_mission,pareto_antibody,mission,antibody_reverse(i,:),plane,target);
        end
    end
    
    antibody_mutate=mutate(antibody_reverse,plane);                   %变异操作
    for i=1:sizepop-sizemem
        mission=Get_mission(plane,target,antibody_reverse(i,:));
        [cost_road,cost_bias,cost_reward]=Cost_new(plane,target,mission);
        new_fitness(i)=Affinity_new(cost_road,cost_bias,cost_reward,best_road,best_bias,best_reward,Bias);
        if affinity(i)>new_fitness(i) && rand>exp(-a*b*(affinity(i)-new_fitness(i))/affinity(i))  %模拟退火
            antibody_mutate(i,:)=antibody_reverse(i,:);
            continue;
        end
        if cost_road<best_road
            best_road=cost_road;
            [pareto_mission,pareto_antibody]=FreshPareto(pareto_mission,pareto_antibody,mission,antibody_mutate(i,:),plane,target);
        end
        if cost_bias<best_bias
            best_bias=cost_bias;
            [pareto_mission,pareto_antibody]=FreshPareto(pareto_mission,pareto_antibody,mission,antibody_mutate(i,:),plane,target);
        end
        if cost_reward<best_reward
            best_reward=cost_reward;
            [pareto_mission,pareto_antibody]=FreshPareto(pareto_mission,pareto_antibody,mission,antibody_mutate(i,:),plane,target);
        end
        affinity(i)=Affinity_new(cost_road,cost_bias,cost_reward,best_road,best_bias,best_reward,Bias);
        [cost_road,cost_bias,cost_reward]=Cost_new(plane,target,best_mission);
        best_fit=Affinity_new(cost_road,cost_bias,cost_reward,best_road,best_bias,best_reward,Bias);
        if affinity(i)>best_fit
            best_mission=mission;
            best_fit=affinity(i);
            [pareto_mission,pareto_antibody]=FreshPareto(pareto_mission,pareto_antibody,mission,antibody_mutate(i,:),plane,target);
        end
    end
    antibody=[antibody_mutate;memory];
    best_fit_gen(gen)=best_fit;
    best_mission_gen(:,:,gen)=best_mission;
    fprintf("最短航程:%.4f\t任务路程代价:%.4f\t偏差:%.4f%%\n",best_road,CostRoad(plane,target,best_mission),(CostRoad(plane,target,best_mission)-best_road)/best_road*100);
    fprintf("最小偏差:%.4f  \t任务偏差代价:%.4f  \t偏差:%.4f%%\n",best_bias,CostBias(plane,target,best_mission),(CostBias(plane,target,best_mission)-best_bias)/best_bias*100);
    fprintf("最大奖励:%.4f\t任务奖励    :%.4f\t偏差:%.4f%%\n",-best_reward,Reward(plane,target,best_mission),-(-Reward(plane,target,best_mission)-best_reward)/best_reward*100);
end


    
    
    
 
disp('最佳任务分配');
disp(best_mission);
fprintf("最短航程:%.4f\t任务路程代价:%.4f\t偏差:%.4f%%\n",best_road,CostRoad(plane,target,best_mission),(CostRoad(plane,target,best_mission)-best_road)/best_road*100);
fprintf("最小偏差:%.4f  \t任务偏差代价:%.4f  \t偏差:%.4f%%\n",best_bias,CostBias(plane,target,best_mission),(CostBias(plane,target,best_mission)-best_bias)/best_bias*100);
fprintf("最大奖励:%.4f\t任务奖励    :%.4f\t偏差:%.4f%%\n\n",-best_reward,Reward(plane,target,best_mission),-(-Reward(plane,target,best_mission)-best_reward)/best_reward*100);

disp('帕累托解集');
for i=1:size(pareto_mission,3)
    [cost_road,cost_bias,cost_reward]=Cost_new(plane,target,pareto_mission(:,:,i));
    G_road=(cost_road-best_road)/best_road;
    G_bias=(cost_bias-best_bias)/best_bias;
    G_reward=-(cost_reward-best_reward)/best_reward;
    G=max([G_road,G_bias,G_reward]);
    fprintf("\n路程代价:%.4f\t偏差代价:%.4f \t任务奖励:%.4f\t最大偏差百分比:%.4f%%\n",cost_road,cost_bias,-cost_reward,G*100);
end
for i=50:50:maxgen
    cr=CostRoad(plane,target,best_mission_gen(:,:,i));
    cb=CostBias(plane,target,best_mission_gen(:,:,i));
    r=Reward(plane,target,best_mission_gen(:,:,i));
    type=['+','o','*','.','x','s','d','^','<','>','p'];
    plot3(cr,cb,r,type(floor(i/50)));
    hold on;
    grid on;
end


