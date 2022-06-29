function ret = new_mutate(antibody,num)
%	变异函数
    pos=randi(length(antibody));
    antibody(pos)=rand*num+1;   %对其中一位重新赋值
    ret = antibody;
end

