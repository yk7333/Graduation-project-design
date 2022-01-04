function ret = Mutate(individuals,index,iter)
%MUTATE ±äÒìº¯Êý
    global x_range;
    flag=0;
    while flag~=1
        r=rand;
        if r > 0.5
            max_chrom=max(individuals.chrom(index,:));
            result=individuals.chrom(index,:)+(max_chrom-individuals.chrom(index,:)).*g(iter);
            flag=test(x_range,result);
        end
        if r <=0.5
            min_chrom=min(individuals.chrom(index,:));
            result=individuals.chrom(index,:)+(min_chrom-individuals.chrom(index,:)).*g(iter);
            flag=test(x_range,result);
        end
    end
    ret=result;
end

