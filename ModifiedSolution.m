function ret = ModifiedSolution(plane,mission)
%   产生可行解
%   给定初始的解，将其转化为可行解
%plane.num : 单个无人机执行的最大数量 target.num: 单个任务需要的无人机数量
[num,mission_len]=size(mission);

%% 第一步 让每架飞机小于其对应的最大任务数   
while true      %一直循环直到满足条件
    Release=[];     %存放大于最大任务数，需要放出任务的无人机编号
    Receive=[];     %存放小于最大任务数，可以接收任务的无人机编号
    for i=1:num
        mission_number(i)=mission_len;     %默认长度为mission_len,若提前出现0则更新
        for j=1:mission_len
            if mission(i,j)==0
                mission_number(i)=j-1;     %每一行的任务数
                break;
            end
        end
        if mission_number(i)>plane.num(i)  %如果实际任务数大于飞机最大任务数
            Release=[Release,i];
        end
        if mission_number(i)<plane.num(i)  %如果实际任务数小于飞机最大任务数
            Receive=[Receive,i];
        end
    end
    if isempty(Release)
         break;
    end
    
    for i=1:length(Release)
        for j=1:mission_len
            if mission(i,j)==0
                mission_number(i)=j-1;     %每一行的任务数
            end
        end
        if mission_number(i)==0             %如果第一个数为0,则将0放到后面去
            for p=1:num
                for q=1:mission_len
                    if mission(p,q)==0
                        for r=q:mission_len-1
                            mission(p,r)=mission(p,r+1);
                        end
                    end
                end
            end
            continue;
        end
        delete=unidrnd(mission_number(i));          %随机选择删除的位置
        delete_num=mission(Release(i),delete);   %将删除后的数字保存
        for k=delete:mission_len-1
            mission(Release(i),k)=mission(Release(i),k+1);        
        end
        mission(Release(i),mission_len)=0;
            
        for j=1:length(Receive)
            if sum(delete_num==mission(Receive(j),:))==0    %如果删除的数字没在可接受任务中出现过
                for k=1:mission_len
                    if mission(Receive(j),k)==0
                        mission_number(Receive(j))=k-1;     %每一行的任务数
                        break;
                    end
                end
                if mission_number(Receive(j))==0    %如果一个任务都没有 则直接为第一个任务
                    mission(Receive(j),1)=delete_num;
                    break;
                end
                
                insert=unidrnd(mission_number(Receive(j))); %如果有其他任务，则随机插入
                for k=mission_len:-1:insert+1
                    mission(Receive(j),k)=mission(Receive(j),k-1);  %后续数字后移
                end
                mission(Receive(j),insert)=delete_num;  %将删除的数据插入
                break;
            end
        end
    end
end
mission=mission(:,1:max(plane.num));
[num,mission_len]=size(mission);

%% 第二步 去除每个无人机中的相同任务安排       
for i=1:num
    zero_bias=0;
    while mission_len-length(unique(mission(i,:)))+zero_bias~=0  %如果有重复的任务数字
        unique_mission=unique(mission(i,:));
        for m=1:length(unique_mission)
            if sum(mission(i,:)==unique_mission(m))==1  %sum为1，说明重复的不是该数字   0代表没有任务，允许重复
                continue;   
            end
            if unique_mission(m)==0     %若0为重复的数字，则将其忽视
                zero_bias=1-sum(mission(i,:)==0);
                continue;
            end
            first=0;                
            for j=1:mission_len
                if mission(i,j)==unique_mission(m) 
                    if first==0
                         first=1;        %判断是否为数字第一位
                         continue;
                    end
                    if first~=0
                        for k=j:mission_len-1
                            mission(i,k)=mission(i,k+1);    %后续的任务前移一格
                        end
                        mission(i,mission_len)=0;
                        for k=1:num
                            if k~=i && sum(unique_mission(m)==mission(k,:))==0 && mission_number(k)<plane.num(k) %如果第k个无人机没有任务each 并且没有排满任务 则将each随机插入
                                insert=unidrnd(mission_number(k));
                                if mission_number(k)==0         %如果一个任务也没有安排 则插入至第一个
                                    insert=1;
                                end
                                for l=length(mission(k,:)):-1:insert+1
                                    mission(k,l)=mission(k,l-1);        %插入点后面的元素后移
                                end
                                mission(k,insert)=unique_mission(m);     %将each插入
                                break;
                            end
                        end
                    end       
                end
            end
        end
    end
end
for p=1:num
    for q=1:mission_len
        if mission(p,q)==0
            for r=q:mission_len-1
                mission(p,r)=mission(p,r+1);
            end
        end
    end
end
ret = mission;      
end

