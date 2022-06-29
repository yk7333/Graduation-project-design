function ret = Affinity_new(cost_road,cost_bias,cost_reward,best_road,best_bias,best_reward,Bias)
%   适应度函数求取
e=10;
G_road=(cost_road-best_road)/(best_road+e);
G_bias=(cost_bias-best_bias)/(best_bias+e);
G_reward=-(cost_reward-best_reward)/(best_reward+e);
G=max([G_road,G_bias,G_reward]);
ret=1./(G+Bias);
end

