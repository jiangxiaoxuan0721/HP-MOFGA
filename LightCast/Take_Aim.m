function Take_Aim(castPop, Pop)  % 时间复杂度n*nlog(n)，其中n为个体数
    m = LIGHT_CAST.scatter_degree;
    % 提取 Rank == 1 的元素
    Ref = Pop([Pop.frontno] == 1); 
    % 确保 m 不大于 Ref 的个体数
    n_Ref = numel(Ref);
    m = min(m,n_Ref);  % 如果 m 大于 Ref 的个体数，设置为 Ref 的个体数
    measure_dimension = randi([1, size(Pop(1).dec, 2)]);  % 随机选择比较维度
    
    % 获取 Ref 的决策变量矩阵
    Ref_decs = cat(1, Ref.dec);  % 获取所有 Ref 个体的决策变量
    Ref_dim_values = Ref_decs(:, measure_dimension);  % 提取指定维度的值
    % 遍历 castPop 中的每个个体
    for i = 1:numel(castPop)
        % 获取当前 castPop 个体的决策变量
        castPop_dim_value = castPop(i).dec(measure_dimension);
        
        % 计算与 Ref 中每个个体在指定维度上的差值
        differences = abs(Ref_dim_values - castPop_dim_value);
        
        % 选取差值最小的 m 个个体，将决策变量的值赋值给 add(1到m)
        [~, idx] = sort(differences);    % 时间复杂度 nlog(n)
        idx = idx(1:m);  % 确保 idx 不超出范围
        % 将最接近的 m 个 Ref 个体的决策变量赋值给 castPop(i).Aim
        castPop(i).add = Ref(idx).dec;  % 假设 add 用于存储目标值
    end
    
end
