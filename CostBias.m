function ret = CostBias(plane,target,mission)
%	时间偏差代价
%   计算未按照给定时间而到达任务点的代价
[num,len]=size(mission);
max_iter=30;
A=zeros(size(mission));   %A用来记录每个无人机到达地点的时间
E=zeros(max(mission(:)));
for i=1:num
    if mission(i,1)==0
        continue;
    end
    A(i,1)=norm(plane.pos(i,:)-target.pos(mission(i,1),:))/plane.v(i);  %第一个任务的时间
    E(mission(i,1))=A(i,1);
end

fresh=ones(size(mission));
for iter=1:max_iter            %设置最大更新次数（防止自锁导致一直循环）
    last_A=A;
    for i=1:num
        for j=2:len
            if mission(i,j)>0
                if fresh(i,j)==1
                    A(i,j)=A(i,j-1)+target.t(mission(i,j-1))+norm(target.pos(mission(i,j),:)-target.pos(mission(i,j-1),:))/plane.v(i); %第n个任务的起始时间由前一个任务的完成时间加上路程时间决定
                end
                if A(i,j)>E(mission(i,j))
                    E(mission(i,j))=A(i,j); %记录最后到达任务的无人机时间
                end
            end
        end
    end
    fresh=zeros(size(mission));
    for i=1:num
        for j=1:len
            if mission(i,j)>0 && A(i,j)~=E(mission(i,j)) %协同任务时，要根据最后一个无人机的到达时间作为任务开始时间
                    A(i,j)=E(mission(i,j));
                    for k=j+1:len
                        fresh(i,k)=1;
                    end
            end
        end
    end
    
    if A==last_A  %如果上次和这一次的任务时间没有发生更新，说明更新完毕
        break;
    end
    
end

S=target.win(:,1);  %每个任务的起始时间
C=target.win(:,2);  %每个任务的结束时间
TD=0;   %偏移时间的代价
b1=1;
b2=1;
for i=1:num
    for j=1:len
        if mission(i,j)>0
            TD=TD+b1*max(0,S(mission(i,j))-A(i,j))+b2*max(0,A(i,j)-C(mission(i,j)));
        end
    end
end
ret=TD;    
end

