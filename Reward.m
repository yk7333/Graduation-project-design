function ret = Reward(plane,target,mission)
%	无人机打击的收益
%   给定任务表，计算出打击的收益
[num,len]=size(mission);
ret=0;    %
for i=1:num
    for j=1:len
        if mission(i,j)>0
            ret=ret+plane.p(i)*target.val(mission(i,j));
        end
    end
end

end

