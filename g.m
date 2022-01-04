function ret = g(iter)
%G 变异函数中的变异程度
    global max_iter;
    ret=0.1*(1-iter/max_iter)^2;
end

