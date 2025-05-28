function tree = D_Tree_break(T_whole,agent,task,B,T,point)
%% 决策树构造tree
tic
tree=[];
tree=[tree;point];
for ii=1:1000
    n=0;
    for i=1:length(tree)
        if tree(i).traverse==0
            tree(i).traverse=1;%节点状态更新为已遍历
            n=n+1;
            %以此为父节点遍历可转换状态
            father=tree(i);
            stateB=floor((tree(i).state-1)/T.N)+1;
            stateT=mod(tree(i).state,T.N);
            if stateT==0
                stateT=T.N;
            end
            for j=1:length(B.S)%遍历可转换状态
                son=[];
                for k=1:T.N%遍历地点
                    ap=T.nodes(k).data;
                    if ~isempty(find(cell2mat(B.trans(stateB,j))==ap))&&isempty(find(tree(i).finish==j))%存在可行转换且不在完成序列中
                        son=[son;struct('state',[],'ori',[],'dis',[],'finish',[],'traverse',[],'agents',[],'p_pre',[],'t_pre',[],'B',[],'T',[],'task_flag',[])];%构建新备选子节点
                        son(end).state=(j-1)*T.N+k;son(end).ori=[father.ori,i];son(end).dis=0;
                        son(end).finish=[tree(i).finish,j];son(end).traverse=0;
                        son(end).B=j;son(end).T=k;
                        z=agent_updata(son(end).T,T_whole,father,task,agent);
                        son(end).p_pre=z.p_pre;son(end).t_pre=z.t_pre;son(end).agents=z.agents;son(end).dis=z.dis;
                        if ~isempty(find(B.F==son(end).B)) && father.task_flag==0%由前缀进入过渡段
                            son(end).task_flag=-length(B.S)-1;
                            son(end).finish=[-j];
                        elseif ~isempty(find(B.F==son(end).B)) && father.task_flag==-length(B.S)-1%由过渡进入后缀段
                            son(end).task_flag=son(end).B;
                            son(end).finish=[-j];
                        elseif father.task_flag==son(end).B && father.task_flag>0%完成第一次后缀循环
                            son(end).task_flag=length(B.S)+1;
                        else
                            son(end).task_flag=father.task_flag;%状态不改变，继承父节点任务阶段状态
                        end 
                    end
                end
                %当有新节点时，选择最优节点加入tree，并过滤
                for kk=1:length(son)
                    tree=[tree;son(kk)];
                    over=[];
                    %当B过大时，相似且时间较长的节点去除遍历资格(包括其子节点)
                    for k=1:(length(tree)-1)
                        %判断节点是否相似
                        if tree(k).finish(end)==tree(end).finish(end) && tree(k).task_flag==tree(end).task_flag
                            if tree(end).dis>=tree(k).dis
                                tree(end).traverse=1;
                            else
                                over=[over,k];%记录k为弱节点编号，等待消除遍历资格
                            end
                        end 
                    end
                    %处理相似的弱节点及其子节点
                    for k=1:length(over)%选择弱节点
                        %先处理父节点
                        tree(over(k)).traverse=1;
                        %再处理子节点
                        for m=1:(length(tree)-1)
                            if ~isempty(find(tree(m).ori==over(k)))
                                tree(m).traverse=1;
                            end
                        end
                    end
                end
            end
        end
    end
    %查看是否遍历结束
    if n==0
        break;
    end
end




for i=1:length(tree)
    stateB=floor((tree(i).state-1)/T.N)+1;
    stateT=mod(tree(i).state,T.N);
    if stateT==0
        stateT=T.N;
    end
    tree(i).B=stateB;tree(i).T=stateT;
end
toc
disp(['决策树构造时间: ',num2str(toc)]);


end

