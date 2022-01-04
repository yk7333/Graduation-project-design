function ret=Initial(x_range,x_num)
    weight=rand(1,x_num);
    pick=x_range(:,1)'+weight.*(x_range(:,2)-x_range(:,1))';
    flag=test(x_range,pick);
    while flag~=1
        weight=rand(1,x_num);
        pick=x_range(:,1)+weight.*(x_range(:,2)-x_range(:,1));
        flag=test(x_range,pick);
    end
    ret=pick;
end

