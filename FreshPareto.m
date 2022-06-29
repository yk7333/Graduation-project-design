function [pareto_mission,pareto_antibody] = FreshPareto(pareto_mission,pareto_antibody,mission,antibody,plane,target)
% 生成保存帕累托解的矩阵
if length(unique(pareto_mission))==1
    pareto_mission=mission;
    pareto_antibody=antibody;
end
if length(unique(pareto_mission))~=1
    len=size(pareto_mission,3);
    [cost_road,cost_bias,cost_reward]=Cost_new(plane,target,mission);
    for i=1:len
        [p_road,p_bias,p_reward]=Cost_new(plane,target,pareto_mission(:,:,i));
        if cost_road<p_road && cost_bias<p_bias && cost_reward<p_reward
            pareto_mission(:,:,i)=mission;
            pareto_antibody(i,:)=antibody;
        end
    end
    pareto_mission(:,:,len+1)=mission;
    pareto_antibody(len+1,:)=antibody;
    for i=1:len
        for j=i+1:len+1
            if pareto_mission(:,:,i)==pareto_mission(:,:,j)
                pareto_mission(:,:,len+2)=zeros(size(mission));
                pareto_antibody(len+2,:)=zeros(size(antibody));
                for k=j:len+1
                    pareto_mission(:,:,k)=pareto_mission(:,:,k+1);
                    pareto_antibody(k,:)=pareto_antibody(k+1,:);
                end
            end
        end
    end
    pareto_mission(:,:,all(pareto_mission==0,[1,2]))=[];    %去除全0的数组
    pareto_antibody(all(pareto_antibody==0,2),:)=[];


end
    
end

