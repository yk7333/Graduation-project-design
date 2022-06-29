function ret = exchange(antibody)
% 交换操作
% 将抗体的两个位置进行交换
[num,len]=size(antibody);
for i=1:num
    pos1=randi(len);
    pos2=randi(len);
    while pos1==pos2
        pos1=randi(len);
        pos2=randi(len);
    end
    temp=antibody(i,pos1);
    antibody(i,pos1)=antibody(i,pos2);
    antibody(i,pos2)=temp;
end
ret=antibody;

end

