function ret = concentration(antibody)
%CONCENTRATION ¼ÆËãÅ¨¶È
    anti_num=size(antibody,1);
    for i=1:anti_num
        concent=0;
        for j=1:anti_num
            sim=similar(antibody(i,:),antibody(j,:));
            if sim>0.5
                concent=concent+1;
            end
        end
        ret(i)= concent/anti_num;
    end
    
end

