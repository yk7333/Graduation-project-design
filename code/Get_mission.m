function mission = Get_mission(plane,target,antibody)
% 抗体解码修正后的任务分配矩阵
init_mission=InitialSolution(plane,target,antibody);
mission=ModifiedSolution(plane,init_mission);
mission=Unlock(mission);
end