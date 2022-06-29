function ret = fitness(antibody,fitness)
%CHANCE 计算繁殖的概率(卓越度）
    a=0.6;
    fit_sum=sum(fitness);
    concent=concentration(antibody);
    concent_sum=sum(1./concent);        %浓度越高 越要抑制  给浓度低的抗体繁殖机会
    for i=1:size(antibody,1)
        ret(i) = a*fitness(i)/fit_sum+(1-a)*(1/concent(i)/concent_sum);
    end
    sum_ret=sum(ret);
    for i=1:size(antibody,1)
        ret(i)=ret(i)/sum_ret;
    end
end

