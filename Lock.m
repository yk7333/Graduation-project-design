function ret = Lock(mission)
%   根据分配的任务 求出死锁回路边的次数 返回次数矩阵
    array=Graph(mission);   %获得连接矩阵array
    lock_arr=DFS(array,1,zeros(1,size(array,1)+1));   %获取死锁回路
    new_arr=zeros(size(lock_arr));  %new_arr保存死锁的那段路径
    first=1;
    first_each=1;
    for each=1:max(mission(:))
        lock_arr=DFS(array,each,zeros(1,size(array,1)+1));   %获取死锁回路
        [num,len]=size(lock_arr);
        if sum(lock_arr)==0
            continue;
        end
        for i=1:num
            Start=0;
            End=len;
            for j=1:len
                if sum(lock_arr(i,:)==lock_arr(i,j))~=1 && lock_arr(i,j)~=0   %找到死锁的位置
                    if Start~=0
                        End = j;
                    end
                    if Start == 0
                        Start = j;
                    end
                end
            end
            
            
            if first==1 || first_each==each
                first=0;
                first_each=each;
                for j=1:End-Start
                    new_arr(i,j)=lock_arr(i,j+Start-1);         %第一次迭代，则将数据直接放入array中
                end
                
                continue;
            end
            
            arr_len=size(new_arr,1);                            %不是第一次迭代，则将数据放入上一次array的下方
            for j=1:End-Start
                new_arr(arr_len+1,j)=lock_arr(i,j+Start-1);
            end
        end
        
    end
    
    [new_num,~]=size(new_arr);
    loop=0;                 %loop保存不重复的回路
    add=1;
    for i=1:new_num
        if loop==0
            loop=new_arr(1,:);
            continue;
        end
        u=unique(new_arr(i,:));
        for j=1:size(loop,1)
            if size(u)==size(unique(new_arr(j,:)))
                if  u==unique(new_arr(j,:))
                    add=0;
                end
            end
        end
        if add==1
            loop=[loop;new_arr(i,:)];
        end
    end
    
    ret=zeros(max(mission(:)),max(mission(:)));        %记录出现回路时，每个边出现的次数
    for i=1:size(loop,1)
        last=size(loop,2);
        for j=1:size(loop,2)
            if loop(i,j)>0 && loop(i,j+1)>0
                ret(loop(i,j),loop(i,j+1))=ret(loop(i,j),loop(i,j+1))+1;
            end
            if loop(i,j)==0
                last=j-1;
                break;
            end
        end
        if sum(ret)~=0
            ret(loop(i,last),loop(i,1))=ret(loop(i,last),loop(i,1))+1;
        end
    end
end