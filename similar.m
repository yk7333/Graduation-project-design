function ret= similar(x,y)
%SIMILAR 相似度计算
%  输入：两个序列 输出：相似度
   ret= sum(round(x)==round(y))/length(x);
end

