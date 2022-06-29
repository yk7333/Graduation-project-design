function ret = new_cross(antibody,antibody_total,fitness,plane)
%CROSS ½»²æ»¥»»
    weight=0.5;
    anti_len=length(antibody);
    chance=excellence(antibody_total,fitness);
    thresh=rand;
    antibody_new=antibody;
    for i=1:length(chance)
        if sum(chance(1:i))>=thresh
           j=i;
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
        antibody_new(pos)=antibody(pos).*weight+antibody_total(j,pos).*(1-weight);
    end
    ok=Test(plane,antibody_new);
    while ok==0
        pos1=randi(anti_len);
        pos2=randi(anti_len);
        if pos1>pos2
            temp=pos1;
            pos1=pos2;
            pos2=temp;
        end
        for pos=pos1:pos2
            antibody_new(pos)=antibody(pos).*weight+antibody_total(j,pos).*(1-weight);
        end
        ok=Test(plane,antibody_new);
    end
    ret = antibody_new;
end

