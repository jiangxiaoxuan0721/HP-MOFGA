function [Population,FrontNo,CrowdDis] = EnvironmentalSelection(Population,N)
    %% 非支配排序（时间复杂度 O(M * N * log(N))）
    [FrontNo,~] = NDSort(Population.objs,Population.cons,N);

    %% 更新个体的 FrontNo 属性
    for i = 1:length(Population)
        Population(i).frontno = FrontNo(i);  % 将对应的 FrontNo 值赋给每个个体
    end

    %% 标记优先保留的个体
    Next = FrontNo < max(FrontNo(1:N));
    
    %% 拥挤距离计算（时间复杂度 O(M * N * log(N))）
    CrowdDis = CrowdingDistance(Population.objs,FrontNo);

    %% 处理最后一层的个体
    Last = find(FrontNo == max(FrontNo(1:N))); % 只处理必要的最后一层
    [~,Rank] = sort(CrowdDis(Last),'descend'); % 按拥挤距离排序
    Remaining = N - sum(Next);                 % 剩余需要选择的个体数量
    Next(Last(Rank(1:Remaining))) = true;      % 选择剩余的个体

    %% 生成下一代种群（O(N)）
    Population = Population(Next);
    FrontNo = FrontNo(Next);
    CrowdDis = CrowdDis(Next);
    
    %% 更新保留个体的 FrontNo 属性
    for i = 1:length(Population)
        Population(i).frontno = FrontNo(i);  % 更新被选中个体的 FrontNo 属性
    end
end
