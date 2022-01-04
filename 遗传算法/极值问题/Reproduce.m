function ret= Reproduce(individuals,index,list,iter)
%REPRODUCE  繁殖函数
%   对种群进行繁衍，选择出下一代种群
%    [copy_chance,mutate_chance,cross_chance]=list;
    num=Choose(list);
    if num==1   %复制
       ret=[individuals.chrom(index(1),:);individuals.chrom(index(2),:)]; 
    end
    if num==2   %变异
       ret1=Mutate(individuals,index(1),iter);
       ret2=Mutate(individuals,index(2),iter);
       ret=[ret1;ret2];
    end
    
    if num==3   %交叉
       ret=Cross(individuals,index);
    end
end

