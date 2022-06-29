clear;clc;
%% 读取数据
X=xlsread('UAV.xlsx');
plane=struct('pos',0,'p',0,'max',0,'v',0);
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
%% 粒子群算法
maxgen=800;      %最大迭代次数
par_num=100;    %粒子的数目
Bias=100;       %偏置项，让适应度函数为正
c1=2;
c2=2;
w_max=0.5;
w_min=0;
v_max=size(plane.num,1);
v_min=-v_max;
pos_max=size(plane.num,1)+1;
pos_min=1;

for i=1:par_num
    par_len=sum(target.num(:));                  %要产生的粒子长度
    par_max=size(plane.num,1);              
    par_pos(i,:)=rand(1,par_len)*par_max+1;      %par_pos记录粒子位置
    par_v(i,:)=rand(1,par_len)*2*par_max-par_max;        %par_v记录粒子速度
    [cost,~]=Cost(plane,target,par_pos(i,:));
    affinity(i)=1/(cost+Bias);
end
par_i=par_pos;                          %par_i记录个体粒子的历史最佳
best_fit_i=affinity;
[best_fit_g,best_index]=max(affinity);     
par_g=par_pos(best_index,:);            %par_g记录群体粒子的历史最佳
best_fit_gen=zeros(1,maxgen);             %best_fit_gen记录gen代最优粒子适应度

for gen=1:maxgen
    disp(['迭代次数:',num2str(gen)]);
    if gen==1
        affinity_old=best_fit_g;
    end
    if gen>1
        affinity_old=Affinity_old(best_fit_gen,gen);
    end
    w=w_max-gen/maxgen*(w_max-w_min)+0.5*exp((best_fit_g-affinity_old)/best_fit_g);
    for i=1:par_num
            par_v(i,:)=w.*par_v(i,:)+c1*rand.*(par_i(i,:)-par_pos(i,:))+c2*rand.*(par_g-par_pos(i,:));
            par_v(i,find(par_v(i,:)>v_max))=v_max;
            par_v(i,find(par_v(i,:)<v_min))=v_min;
            par_pos(i,:)=par_pos(i,:)+par_v(i,:);
            ok=Test(plane,par_pos(i,:));
            while ok==0
                par_v(i,:)=w.*par_v(i,:)+c1*rand.*(par_i(i,:)-par_pos(i,:))+c2*rand.*(par_g-par_pos(i,:));
                par_v(i,find(par_v(i,:)>v_max))=v_max;
                par_v(i,find(par_v(i,:)<v_min))=v_min;
                par_pos(i,:)=par_pos(i,:)+par_v(i,:);
                ok=Test(plane,par_pos(i,:));
            end
            [cost,mission]=Cost(plane,target,par_pos(i,:));
            affinity(i)=1/(cost+Bias);
            if affinity(i)>best_fit_i(i)
                par_i(i,:)=par_pos(i,:);
                best_fit_i(i)=affinity(i);
                if affinity(i)>best_fit_g
                    par_g=par_pos(i,:);
                    best_fit_g=affinity(i);
                    best_mission=mission;
                end
            end
    end
    best_fit_gen(gen)=best_fit_g;
    res=1./best_fit_g-Bias
end
plot(1./best_fit_gen-Bias)
xlabel("迭代次数")
ylabel("适应度值")

disp('最佳任务分配');
disp(best_mission);
disp(['最小代价:',num2str(CostRoad(plane,target,best_mission)+CostBias(plane,target,best_mission)-Reward(plane,target,best_mission))])
