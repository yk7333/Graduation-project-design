function ret = Test(plane,antibody)
%   可行解判断
%   给定编码，判断是否可行 如果可行返回1 否则返回0
%% 测试编码是否在1与飞机的数目+1之间
max_num=size(plane.num,1)+1;    %飞机的数目+1
ret=1;
for i=1:length(antibody)
    if antibody(i)<1 || antibody(i)>max_num   %只要任意一个不满足，则返回0
        ret=0;
        break;
    end
end
end

