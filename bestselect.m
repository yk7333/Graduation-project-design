function ret = bestselect(antibody,fitness,sizemem)
%BESTSELECT 保留最优的个体到记忆库中
    [~,index]=sort(fitness,'descend');      %排序选出最佳的sizemem个抗体
    ret=zeros(sizemem,size(antibody,2));      
    for i=1:sizemem
        ret(i,:)=antibody(index(i),:);     %将最佳的抗体输出
    end
end

