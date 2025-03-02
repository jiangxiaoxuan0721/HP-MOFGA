classdef LIGHT_CAST < ALGORITHM
% <multi> <real/integer/label/binary/permutation> <constrained/none>
% Ligth cast based on NSGA II 
properties(Access = public,Constant)
     scatter_degree = 3;    % 每个个体能投射出的个体数，在个体空间维度大的情况下，值越大PF越准确，性能开销越大
     lambda = 0.0625;    % 模拟波长因子
end

methods
    function main(Algorithm,Problem)
       %% 初始化随机种群
        Pop = Problem.Initialization();
       %% 计算帕累托支配等级和拥挤度
        [Pop,F,cd] = EnvironmentalSelection(Pop,Problem.N);    
       %% 迭代优化
        while Algorithm.NotTerminated(Pop)
            MatingPool = TournamentSelection(2,Problem.N,F,-cd);   
            % 锦标选择适应的个体进行权衡
            castPop  = OperatorGA(Problem,Pop(MatingPool));      
            % 遗传算法得到投射个体，进行投射
            n_Cast = numel(castPop);
            % try
            % TmpPop = [Pop,castPop];
            % [FrontNo,~] = NDSort(TmpPop.objs,TmpPop.cons,numel(TmpPop));
            % for i = 1:length(TmpPop)
            %     TmpPop(i).frontno = FrontNo(i);  % 将对应的 FrontNo 值赋给每个个体
            % end
            [Pop,~,~] = EnvironmentalSelection([Pop,castPop],n_Cast+Problem.N);
            Take_Aim(castPop,Pop);
            FrontPop = LightCast(castPop);
            [Pop,F,cd] = EnvironmentalSelection([Pop,FrontPop],Problem.N);
        end
    end
end

end