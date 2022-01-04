function ret = Choose(list)
%CHOOSE 选择待操作的两个个体
    threshold=rand;
    for i=1:length(list)
       if sum(list(1:i))>threshold
          ret=i; 
          break;
       end
    end
end

