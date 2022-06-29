function ret = select(antibody,affinity,number)
%SELECT 轮盘赌选择繁衍的后代 生成number个后代个体
    chance=fitness(antibody,affinity);
    for num=1:number
        thresh=rand;
        for i=1:length(chance)
            if sum(chance(1:i))>=thresh
               ret(num,:)=antibody(i,:);
                break;
            end
        end
    end
     
end

