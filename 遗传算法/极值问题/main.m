clear
clc
%% 初始化
max_iter=100;%最大迭代次数
sizepop=300;%种群数量
x_num=5;%未知参数
x_range=[0 pi;0 pi;0 pi;0 pi;0 pi];%参数取值范围

best_chrom=[];
individuals=struct('fitness',zeros(1,sizepop),'chrom',zeros(sizepop,x_num));

for i=1:sizepop
    individuals.chrom(i,:)=Initial(x_range,x_num);          %生成初始种群
    individuals.fitness(1,i)=1./fun(individuals.chrom(i,:));
end
[best_fitness,best_index]=max(individuals.fitness);     %存储最佳适应度种群
best_chrom=[best_chrom;individuals.chrom(best_index,:)];

%% 开启繁殖操作
copy_chance=0.7;    %复制概率
mutate_chance=0.1;  %变异概率
cross_chance=0.2;   %交叉概率

for iter=1:max_iter 
    sumfit=sum(individuals.fitness);        
    norm_fit=individuals.fitness./sumfit;   %适应度归一化
    new_chrom=[];
    for i=1:(sizepop/2)
        index1=Choose(norm_fit);                %选择出待操作的两个个体的索引
        index2=Choose(norm_fit);
        new_chrom=[new_chrom;Reproduce(individuals,[index1,index2],[copy_chance,mutate_chance,cross_chance],iter)];%繁殖操作
    end
    for j=1:sizepop
        individuals.chrom(j,:)=new_chrom(j,:);
        individuals.fitness(1,j)=1./fun(individuals.chrom(j,:));
    end
    [best_fitness,best_index]=max(individuals.fitness);     
    best_chrom=[best_chrom;individuals.chrom(best_index,:)]; %存储每次迭代最佳适应度种群
end
best_fitness=[];
for i=1:max_iter
    best_fitness=[best_fitness;fun(best_chrom(i,:))];
end
plot(1:max_iter,best_fitness,'r');

[min_val,min_index]=min(best_fitness);
min_chrom=best_chrom(min_index,:);
fprintf("    最小值\t\t\t\t\t x的最佳的取值\n");
disp([min_val,min_chrom]);