function lock_arr = DFS(array,road,lock_arr)
%   深度优先算法 
num=road(length(road));
len=size(array,2);

for i=1:len
    if array(num,i)~=0  
        if sum(road==array(num,i))~=0       %如果路径中已经有此路径,则说明出现死锁
            new_road=[road,array(num,i)];
            if lock_arr~=zeros(1,len+2)
                lock_len=size(lock_arr,1);
                for j=1:length(new_road)
                    lock_arr(lock_len+1,j)=new_road(j);
                end
                break;
            end
            if lock_arr==zeros(1,len+2)     %判断是否是第一次注入数据
                for j=1:length(new_road)
                    lock_arr(1,j)=new_road(j);
                end
            end
            
        end
        if sum(road==array(num,i))==0       %如果有路径并且不重复，则进入继续搜索
           new_road=[road,array(num,i)];
           lock_arr= DFS(array,new_road,lock_arr);
        end
        
    end
    
end

end

