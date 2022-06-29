function ret = new_reverse(antibody)
%REVERSE 反转操作
    anti_len=length(antibody);
    pos1=randi(anti_len);
    pos2=randi(anti_len);
    if pos1>pos2
        temp=pos1;
        pos1=pos2;
        pos2=temp;
    end
    while pos2==pos1
        pos2=randi(anti_len);
    end
    antibody(pos1:pos2)=antibody(pos2:-1:pos1);   %逆转操作
    ret = antibody;
end

