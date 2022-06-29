function ret = cross(antibody,best_fit,affinity,plane)
%CROSS ½»²æ»¥»»
    [anti_num,anti_len]=size(antibody);
    for i=1:anti_num
        weight=(best_fit-affinity(i))/best_fit;
        chance=fitness(antibody,affinity);
        thresh=rand;
        for k=1:length(chance)
            if sum(chance(1:k))>=thresh
               j=k;
                break;
            end
        end
        pos1=randi(anti_len);
        pos2=randi(anti_len);
        if pos1>pos2
            temp=pos1;
            pos1=pos2;
            pos2=temp;
        end
        for pos=pos1:pos2
            antibody(i,pos)=antibody(i,pos).*(1-weight)+antibody(j,pos).*weight;
        end
        ok=Test(plane,antibody(1,:));
        while ok==0
            thresh=rand;
            for k=1:length(chance)
                if sum(chance(1:k))>=thresh
                   j=k;
                    break;
                end
            end
            pos1=randi(anti_len);
            pos2=randi(anti_len);
            if pos1>pos2
                temp=pos1;
                pos1=pos2;
                pos2=temp;
            end
            for pos=pos1:pos2
                antibody(i,pos)=antibody(i,pos).*(1-weight)+antibody(j,pos).*weight;
            end
            ok=Test(plane,antibody(i,:));
        end
    end
    ret = antibody;
end

