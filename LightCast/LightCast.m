function newPop = LightCast(castPop) % 算法复杂度O(n*m)
    lambda = LIGHT_CAST.lambda;
    cast_degree = LIGHT_CAST.scatter_degree;   % 每个投影点投射出的数量（常量）
    n_castPop = numel(castPop);             % 投影点数量
    % 初始化 newPop 数组
    totalNewPop = cast_degree * n_castPop;
    newPop = repmat(castPop(1), 1, totalNewPop);  % 复制模板，仅用于结构初始化

    % 主循环，遍历每个投影点
    for i = 1:n_castPop
        baseDec = castPop(i).dec;          % 当前投影点的决策变量
        tmpList = castPop(i).add(1:cast_degree);  % 获取批量的投影目标
        
        % 生成所有新个体
        for d = 1:cast_degree
            idx = (i-1) * cast_degree + d; % 计算新个体的索引
            % 直接更新新个体的决策变量
            newPop(idx).dec = tmpList(d) + (baseDec - tmpList(d)) * lambda;
        end
    end
end
