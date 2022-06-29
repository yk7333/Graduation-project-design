function ret = mutate(antibody,plane)
%	变异函数
    [anti_num,anti_len]=size(antibody);
    for i=1:anti_num
        pos=randi(anti_len);
        antibody(i,pos)=rand*size(plane.num,1)+1;   %对其中一位重新赋值
    end
    ret = antibody;
end

