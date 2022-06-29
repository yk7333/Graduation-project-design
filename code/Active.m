function ret=Active(plane,target,init_mission)
X=xlsread('New_target.xlsx');
new_target.pos=X(:,1:2);    %任务点的位置
new_target.val=X(:,3);      %任务的价值 
new_target.win=X(:,4:5);    %任务的时间窗口
new_target.t=X(:,6);        %任务的用时
new_target.num=X(:,7);      %需要无人机的数量
A=Time_array(plane,target,init_mission); %开始任务的时间矩阵
S=21;
C=max(new_target.win(:,2));
R=[];%重分配的任务矩阵
last=zeros(1,size(A,1));%Ui任务分配的数目
N=zeros(1,size(A,1));%记录Ui重分配的任务数目
new_pos_idx=zeros(1,size(A,1));%储存无人机新分配任务的起始位置任务索引
for i=1:size(A,1)
    first=1;
    last(i)=size(A,2);
    for j=1:size(A,2)
        if A(i,j)>S && (A(i,j)+target.t(init_mission(i,j)))<C
            if first==1
                first=0;
                new_pos_idx(i)=j-1;
            end
            R=[R,init_mission(i,j)];
            N(i)=N(i)+1;
        end
        if A(i,j)==0
            last(i)=j-1;
            break;
        end
    end
    if first==1
        new_pos_idx(i)=last(i);
    end
end
R=unique(R);
new_pos=zeros(size(A,1),2);%任务重分配 无人机的起始位置
for i=1:size(A,1)
    if A(i,new_pos_idx(i)+1)==0 || A(i,new_pos_idx(i))+target.t(init_mission(i,new_pos_idx(i)))>=S
        new_pos(i,:)=target.pos(init_mission(i,new_pos_idx(i)),:);
        continue;
    end
    if A(i,new_pos_idx(i))+target.t(init_mission(i,new_pos_idx(i)))<S
        new_pos(i,:)=target.pos(init_mission(i,new_pos_idx(i)),:)+(target.pos(init_mission(i,new_pos_idx(i)+1),:)-target.pos(init_mission(i,new_pos_idx(i)),:))/norm((target.pos(init_mission(i,new_pos_idx(i)+1),:)-target.pos(init_mission(i,new_pos_idx(i)),:)))^2*plane.v(i)*(A(i,new_pos_idx(i)+1)-A(i,new_pos_idx(i)));
    end
end
plane_new=plane;
plane_new.pos=new_pos;
for i=1:size(A,1)
    plane_new.num(i)=plane.num(i)-last(i)+N(i);
end
target_new=struct('pos',zeros(1,2),'val',0,'win',zeros(1,2),'t',0,'num',0);
for i=1:length(R)
    target_new.pos(i,:)=target.pos(R(i),:);    %任务点的位置
    target_new.val(i,:)=target.val(R(i),:);
    target_new.win(i,:)=target.win(R(i),:);
    target_new.t(i,:)=target.t(R(i),:);
    target_new.num(i,:)=target.num(R(i),:);
end
for i=1:size(new_target.val,1)
    target_new.pos(i+length(R),:)=new_target.pos(i,:);
    target_new.val(i+length(R),:)=new_target.val(i,:);
    target_new.win(i+length(R),:)=new_target.win(i,:);
    target_new.t(i+length(R),:)=new_target.t(i,:);
    target_new.num(i+length(R),:)=new_target.num(i,:);
end
target=target_new;
plane=plane_new;
maxgen=100;     %最大迭代次数
sizepop=100;    %种群规模
sizemem=20;     %记忆库容量
p_cross=1;    %交叉互换概率
p_mutate=1;   %变异概率
p_reverse=1;  %逆转概率
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
    [cost,~]=Cost(plane,target,antibody(i,:));
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
    memory=bestselect(antibody,affinity,sizemem);                %将最佳的个体保存在记忆库中
    antibody_select=select(antibody,affinity,sizepop-sizemem);           %对种群进行繁衍选择
    antibody_exchange=exchange(antibody_select);                %内部交换
    for i=1:sizepop-sizemem
        [cost_sel,~]=Cost(plane,target,antibody_select(i,:));
        [cost_exc,~]=Cost(plane,target,antibody_exchange(i,:));
        if cost_exc>cost_sel && rand>exp(-a*b*(cost_exc-cost_sel)/cost_sel)  %模拟退火(exp里值绝对值越小越接受新解)
            antibody_exchange(i,:)=antibody_select(i,:);
        end
        [cost_exc,mission]=Cost(plane,target,antibody_exchange(i,:));
        affinity(i)=1./(cost_exc+Bias);
        if affinity(i)>best_aff
            best_mission=mission;
            best_aff=affinity(i);
        end
    end
    antibody_cross=cross(antibody_exchange,best_aff,affinity,plane);       %交叉操作
    for i=1:sizepop-sizemem
        [cost_exc,~]=Cost(plane,target,antibody_exchange(i,:));
        [cost_cro,~]=Cost(plane,target,antibody_cross(i,:));
        if cost_cro>cost_exc && rand>exp(-a*b*(cost_cro-cost_exc)/cost_exc)  %模拟退火(exp里值绝对值越小越接受新解)
            antibody_cross(i,:)=antibody_exchange(i,:);
        end
        [cost_cro,mission]=Cost(plane,target,antibody_cross(i,:));
        affinity(i)=1./(cost_cro+Bias);
        if affinity(i)>best_aff
            best_mission=mission;
            best_aff=affinity(i);
        end
    end
    antibody_reverse=reverse(antibody_cross,p_reverse);                 %反转操作
    for i=1:sizepop-sizemem
        [cost_cro,~]=Cost(plane,target,antibody_cross(i,:));
        [cost_rev,~]=Cost(plane,target,antibody_reverse(i,:));
        if cost_rev>cost_cro && rand>exp(-a*b*(cost_rev-cost_cro)/cost_cro)  %模拟退火
            antibody_reverse(i,:)=antibody_cross(i,:);
        end
        [cost_rev,mission]=Cost(plane,target,antibody_reverse(i,:));
        affinity(i)=1./(cost_rev+Bias);
        if affinity(i)>best_aff
            best_mission=mission;
            best_aff=affinity(i);
        end
    end
    
    antibody_mutate=mutate(antibody_reverse,p_mutate);                   %变异操作
    for i=1:sizepop-sizemem
        [cost_rev,~]=Cost(plane,target,antibody_reverse(i,:));
        [cost_mut,~]=Cost(plane,target,antibody_mutate(i,:));
        if cost_mut>cost_rev && rand>exp(-a*b*(cost_mut-cost_rev)/cost_rev)  %模拟退火
            antibody_mutate(i,:)=antibody_reverse(i,:);
        end
        [cost_mut,mission]=Cost(plane,target,antibody_mutate(i,:));
        affinity(i)=1./(cost_mut+Bias);
        if affinity(i)>best_aff                                  %搜寻最佳的个体
            best_mission=mission;
            best_aff=affinity(i);
        end
    end
    antibody=[antibody_mutate;memory];
    for i=1:sizepop
        [cost,mission]=Cost(plane,target,antibody(i,:));
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
disp('时间窗口内的重分配');
R=[R,21,22];
for i=1:size(mission,1)
    for j=1:size(mission,2)
        if best_mission(i,j)>0
            best_mission(i,j)=R(best_mission(i,j));
        end
    end
end
disp(best_mission);
for i=1:size(best_mission,1)
    last(i)=size(best_mission,2);
    for j=1:size(best_mission,2)
        if best_mission(i,j)==0
            last(i)=j-1;
            break;
        end
    end
end
        
%更新分配矩阵
for i=1:size(A,1)
    for j=1:size(A,2)
        if new_pos_idx(i)==j && best_mission(i,1)~=0
            for k=size(A,2)-N(i):j-N(i)+last(i)+1
                init_mission(i,k)=init_mission(i,k)+N(i)-last(i);
            end
            for k=1:last(i)
                init_mission(i,j+k)=best_mission(i,k);
            end
        end
    end
end
ret= init_mission;
end

