function mission = InitialSolution(plane,target,antibody)
%	初始解生成
%   根据给定的抗体，给出对应的初始解 输入为Nc维矩阵 输出为mission矩阵
target_num=size(target.num,1);
plane_num=size(plane.num,1);
index=1;
for i=1:target_num
    for j=1:target.num(i)
        task(index)=i;    %task在每一位上的值对应了input在每一位上的任务编号
        index=index+1;
    end
end
In=floor(antibody);            %整数部分(决定每个任务中飞机的编号)
De=antibody-In;                %小数部分(决定每个任务中飞机的顺序）
mission=zeros(plane_num,max(plane.num));
for i=1:plane_num
    temp=[];
    index=[];
    for j=1:length(In)
        if In(j)==i
            temp=[temp,De(j)];  
            index=[index,j];    
        end
    end
    [~,subscript]=sort(temp);
    for k=1:length(subscript)
        mission(i,k)=task(index(subscript(k)));    %mission按飞机编号以及顺序存放
    end
end

end

