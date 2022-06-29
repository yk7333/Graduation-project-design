function ret = CostRoad(plane,target,mission)
%   航程代价
%   计算无人机从起始点开始，经过各个任务点再返回的路程消耗
[num,len]=size(mission);
dis=0;           %保存每个无人机航行的距离
last=ones(1,num)*len;       %last保存每个无人机的任务数
for i=1:num
    for j=1:len
        if mission(i,j)==0
            last(i)=j-1;    %如果任务分配为0，说明此时已经无任务，任务数为j-1
            break;
        end
    end
end


for i=1:num
    if last(i)==0
        continue;
    end
    dis=dis + norm(plane.pos(i,:)-target.pos(mission(i,1),:))+norm(plane.pos(i,:)-target.pos(mission(i,last(i)),:));
    for j=2:len
        if mission(i,j)>0
            dis=dis+norm(target.pos(mission(i,j-1),:)-target.pos(mission(i,j),:)); 
            
        end
    end
end
ret = dis;

end


