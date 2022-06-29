clear;clc;
%% 读取数据
X=xlsread('UAV.xlsx');
plane=struct('pos',0,'p',0,'num',0,'v',0);
plane.pos=X(:,1:2);     %飞机的起始位置
plane.p=X(:,3);         %飞机的打击成功率
plane.num=X(:,4);       %飞机的最大任务数
plane.v=X(:,5);         %飞机的飞行速率

X=xlsread('Target.xlsx');
target=struct('pos',0,'val',0,'win',0,'t',0,'num',0);
target.pos=X(:,1:2);    %任务点的位置
target.val=X(:,3);      %任务的价值
target.win=X(:,4:5);    %任务的时间窗口
target.t=X(:,6);        %任务的用时
target.num=X(:,7);      %需要无人机的数量

%% 参数设定
maxgen=100;     %最大迭代次数
sizepop=100;    %种群规模
sizemem=20;     %记忆库容量
Bias=200;       %偏置项，让适应度函数为正
%初始化抗体
antibody_len=sum(target.num(:));
antibody=zeros(sizepop,antibody_len);

for i=1:sizepop
    antibody(i,:)=rand(1,antibody_len)*size(plane.num,1)+1;
end
affinity=zeros(1,sizepop);   
%注意:此处应该为亲和度,不是适应度 免疫算法的适应度还要考虑抗体浓度

for i=1:sizepop
    [cost,~]=Cost_Road(plane,target,antibody(i,:));
    affinity(i)=1/(cost+Bias);
end
best_aff=max(affinity);

for gen=1:maxgen
    disp(['迭代次数:',num2str(gen)]);  
    if gen<=1
        a = 1;
    end
    if gen>1
        a = exp((best_aff-Affinity_old(best_aff_gen,gen))/Affinity_old(best_aff_gen,gen));
    end
    b=3-2*gen/maxgen;
    c=10;
    memory=bestselect(antibody,affinity,sizemem);                %将最佳的个体保存在记忆库中
    antibody_select=select(antibody,affinity,sizepop-sizemem);           %对种群进行繁衍选择
    antibody_exchange=exchange(antibody_select);                %内部交换
    for i=1:sizepop-sizemem
        [cost_sel,~]=Cost_Road(plane,target,antibody_select(i,:));
        [cost_exc,~]=Cost_Road(plane,target,antibody_exchange(i,:));
        if cost_exc>cost_sel && rand>exp(-a*b*(cost_exc-cost_sel)/cost_sel)  %模拟退火(exp里值绝对值越小越接受新解)
            antibody_exchange(i,:)=antibody_select(i,:);
        end
        [cost_exc,mission]=Cost_Road(plane,target,antibody_exchange(i,:));
        affinity(i)=1./(cost_exc+Bias);
        if affinity(i)>best_aff
            best_mission=mission;
            best_aff=affinity(i);
        end
    end
    antibody_cross=cross(antibody_exchange,best_aff,affinity,plane);       %交叉操作
    for i=1:sizepop-sizemem
        [cost_exc,~]=Cost_Road(plane,target,antibody_exchange(i,:));
        [cost_cro,~]=Cost_Road(plane,target,antibody_cross(i,:));
        if cost_cro>cost_exc && rand>exp(-a*b*(cost_cro-cost_exc)/cost_exc)  %模拟退火(exp里值绝对值越小越接受新解)
            antibody_cross(i,:)=antibody_exchange(i,:);
        end
        [cost_cro,mission]=Cost_Road(plane,target,antibody_cross(i,:));
        affinity(i)=1./(cost_cro+Bias);
        if affinity(i)>best_aff
            best_mission=mission;
            best_aff=affinity(i);
        end
    end
    antibody_reverse=reverse(antibody_cross);                 %反转操作
    for i=1:sizepop-sizemem
        [cost_cro,~]=Cost_Road(plane,target,antibody_cross(i,:));
        [cost_rev,~]=Cost_Road(plane,target,antibody_reverse(i,:));
        if cost_rev>cost_cro && rand>exp(-a*b*(cost_rev-cost_cro)/cost_cro)  %模拟退火
            antibody_reverse(i,:)=antibody_cross(i,:);
        end
        [cost_rev,mission]=Cost_Road(plane,target,antibody_reverse(i,:));
        affinity(i)=1./(cost_rev+Bias);
        if affinity(i)>best_aff
            best_mission=mission;
            best_aff=affinity(i);
        end
    end
    
    antibody_mutate=mutate(antibody_reverse,plane);                   %变异操作
    for i=1:sizepop-sizemem
        [cost_rev,~]=Cost_Road(plane,target,antibody_reverse(i,:));
        [cost_mut,~]=Cost_Road(plane,target,antibody_mutate(i,:));
        if cost_mut>cost_rev && rand>exp(-a*b*(cost_mut-cost_rev)/cost_rev)  %模拟退火
            antibody_mutate(i,:)=antibody_reverse(i,:);
        end
        [cost_mut,mission]=Cost_Road(plane,target,antibody_mutate(i,:));
        affinity(i)=1./(cost_mut+Bias);
        if affinity(i)>best_aff                                  %搜寻最佳的个体
            best_mission=mission;
            best_aff=affinity(i);
        end
    end
    antibody=[antibody_mutate;memory];
    for i=1:sizepop
        [cost,mission]=Cost_Road(plane,target,antibody(i,:));
        affinity(i)=1/(cost+Bias);
        if affinity(i)>best_aff
            best_mission=mission;
            best_aff=affinity(i);
        end
    end

    result(gen)=1./best_aff-Bias;    %Cost后加了Bias偏置 为了处理代价为负情况 此处将其减去
    best_aff_gen(gen)=best_aff;
    res=1./best_aff-Bias
end
plot(result,'-r','LineWidth',2)
xlabel("迭代次数")
ylabel("代价函数值")

disp('最佳任务分配');
disp(best_mission);
disp(['最小代价:',num2str(Cost_Road(plane,target,best_mission)+CostBias(plane,target,best_mission)-Reward(plane,target,best_mission))])
