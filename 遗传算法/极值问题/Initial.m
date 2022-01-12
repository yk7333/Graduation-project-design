function ret=Initial(x_num)
    global x_range;
    weight=rand(1,x_num);
    pick=x_range(:,1)'+weight.*(x_range(:,2)-x_range(:,1))';
    flag=test(pick);
    while flag~=1
        weight=rand(1,x_num);
        pick=x_range(:,1)'+weight.*(x_range(:,2)-x_range(:,1))';
        flag=test(pick);
    end
    ret=pick;
end

