function ret = Affinity_old(best_fit_gen,gen)
%  求解前二十次适应度平均值
    if gen<=50
        ret=mean(best_fit_gen(1:gen-1));
    end
    if gen>50
        ret=mean(best_fit_gen(gen-50:gen-1));
    end
end

