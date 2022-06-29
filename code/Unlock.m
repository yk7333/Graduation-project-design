function ret = Unlock(mission)
%   解决死锁问题
    lock=Lock(mission);
    %使用轮盘赌方式 选择待交换的边
    while sum(lock(:))~=0
        rand_num=randi(sum(lock(:)));
        number=0;
        ok=0;
        for i=1:size(lock,1)
            for j=1:size(lock,2)
                number=number+lock(i,j);
                if number>=rand_num && ok==0
                    exchange1=i;
                    exchange2=j;
                    ok=1;
                end
            end
        end

        for i=1:size(mission,1)
            for j=1:size(mission,2)-1
                if mission(i,j)==exchange1 && mission(i,j+1)==exchange2
                    temp=mission(i,j);
                    mission(i,j)=mission(i,j+1);
                    mission(i,j+1)=temp;
                    break;
                end
            end
        end
        lock=Lock(mission);
    end
    ret = mission;
end

