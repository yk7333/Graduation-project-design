function ret = Graph(mission)
% 根据任务矩阵 返回图连接矩阵
[num,len]=size(mission);
max_num=max(mission(:));
array=zeros(max_num,max_num-1);
for i=1:num
    for j=1:len-1
        if mission(i,j)>0 && mission(i,j+1)>0
            for k=1:len-1
                if array(mission(i,j),k)==0 && sum(array(mission(i,j))==mission(i,j+1))==0   %如果没有此路径 则添加此路径
                    array(mission(i,j),k)=mission(i,j+1);
                    break;
                end
            end
        end
    end
end
ret = array;

end

