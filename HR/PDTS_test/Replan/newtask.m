function [best_stateB,best_stateT,best_agents]=newtask(agent,T_whole,alphabet_whole,formula0,task0,B0,T0,p0,tran_B0,flag)
%UNTITLED2 此处显示有关此函数的摘要
%   此处显示详细说明
warning off all
addpath('.\LTL_Toolbox','.\Basic');
formula1='Fp4&Fp3&((!p4)Up3)';
task1=[[1,1];[1,1];[0,2];[1,0]];
[B1,T1] = B_T(T_whole,alphabet_whole,formula1,task1);
p1=[3,4];

tran_task_flag=flag;
if tran_task_flag~=0%当进入后缀后flag设置为过渡段
    tran_task_flag=-length(B0.S)-1;
end
point=struct('B0',[tran_B0],'B1',[1],'T',[1],'ori',[],'dis',[],'finish0',[tran_B0],'finish1',[1],'traverse',[0],'agents',[],'p_pre',[],'t_pre',[],'task_flag',[tran_task_flag]);
point.agents=zeros([1,length(agent)]);
for i=1:length(agent)
    point.p_pre=[point.p_pre;agent(i).p(1:2)];
    point.t_pre=[point.t_pre;0];
end
point.dis=max(point.t_pre);
tree=point;

%% 交错决策树
for ii=1:1000
    n=0;%遍历计数器
    for i=1:length(tree)
        if tree(i).traverse==0
            tree(i).traverse=1;%节点状态更新为已遍历
            n=n+1;
            %以此为父节点遍历可转换状态
            father=tree(i);
            stateB0=father.B0;
            stateB1=father.B1;
            stateT=father.T;
            
            for j=1:length(B1.S)
                count=-1;%临时任务推进标记
                son=[];
                for k=1:T1.N
                    if isempty(find(p1==k))
                        continue
                    end
                    ap=T1.nodes(k).data;
                    if isempty(find(p0==k))%检验是否耦合(不耦合)
                        if ~isempty(find(cell2mat(B1.trans(stateB1,j))==ap))&&isempty(find(tree(i).finish1==j))%存在可行转换且不在完成序列中
                            count=count+1;%推进次数加一
                            son=[son;struct('B0',[],'B1',[],'T',[],'ori',[],'dis',[],'finish0',[],'finish1',[],'traverse',[0],'agents',[],'p_pre',[],'t_pre',[],'task_flag',[])];%构建新备选子节点
                            son(end).B0=father.B0;son(end).B1=j;son(end).T=k;son(end).ori=[father.ori,i];
                            son(end).finish0=father.finish0;son(end).finish1=[father.finish1,j];son(end).task_flag=father.task_flag;
                            z=agent_updata(son(end).T,T_whole,father,task1,agent);
                            son(end).p_pre=z.p_pre;son(end).t_pre=z.t_pre;son(end).agents=z.agents;son(end).dis=z.dis;
                            %son(end).dis=father.dis+1;
                        end
                    else%检验是否耦合(耦合)
                        if ~isempty(find(cell2mat(B1.trans(stateB1,j))==ap))&&isempty(find(tree(i).finish1==j))%存在可行转换且不在完成序列中
                            count=0;
                            for jj=1:length(B0.S)
                                if ~isempty(find(cell2mat(B0.trans(stateB0,jj))==ap))&&isempty(find(tree(i).finish0==jj))%存在可行转换且不在完成序列中
                                    count=count+1;%推进次数加一
                                    son=[son;struct('B0',[],'B1',[],'T',[],'ori',[],'dis',[],'finish0',[],'finish1',[],'traverse',[0],'agents',[],'p_pre',[],'t_pre',[],'task_flag',[])];%构建新备选子节点
                                    son(end).B0=jj;son(end).B1=j;son(end).T=k;son(end).ori=[father.ori,i];
                                    son(end).finish0=[father.finish0,jj];son(end).finish1=[father.finish1,j];son(end).task_flag=father.task_flag;
                                    z=agent_updata(son(end).T,T_whole,father,task1,agent);
                                    son(end).p_pre=z.p_pre;son(end).t_pre=z.t_pre;son(end).agents=z.agents;son(end).dis=z.dis;
                                    %son(end).dis=father.dis+1;
                                    if ~isempty(find(B0.F==son(end).B0)) && father.task_flag==0%由前缀进入过渡段
                                        son(end).task_flag=-length(B0.S)-1;
                                        son(end).finish0=[-jj];
                                    elseif ~isempty(find(B0.F==son(end).B0)) && father.task_flag==-length(B0.S)-1%由过渡进入后缀段
                                        son(end).task_flag=son(end).B0;
                                        son(end).finish0=[-jj];
                                    elseif father.task_flag==son(end).B0 && father.task_flag>0 && father.task_flag<=length(B0.S)%完成第一次后缀循环
                                        son(end).task_flag=length(B0.S)+jj;
                                        son(end).finish0=[-jj];
                                    elseif father.task_flag==son(end).B0+length(B0.S) && father.task_flag>length(B0.S) && father.task_flag<=2*length(B0.S)%完成第一次后缀循环
                                        son(end).task_flag=2*length(B0.S)+jj;
                                    else
                                        son(end).task_flag=father.task_flag;%状态不改变，继承父节点任务阶段状态
                                    end
                                end
                            end
                        end
                    end
                end
                if count==0%存在耦合跳转，但因原公式限制无法实现，对B0进行非耦合跳转
                    for jj=1:length(B0.S)
                        for k=1:T0.N
                            if ~isempty(find(p1==k))
                                continue
                            end
                            ap=T0.nodes(k).data;
                            if ~isempty(find(cell2mat(B0.trans(stateB0,jj))==ap))&&isempty(find(tree(i).finish0==jj))%存在可行转换且不在完成序列中
                                count=count+1;%推进次数加一
                                son=[son;struct('B0',[],'B1',[],'T',[],'ori',[],'dis',[],'finish0',[],'finish1',[],'traverse',[0],'agents',[],'p_pre',[],'t_pre',[],'task_flag',[])];%构建新备选子节点
                                son(end).B0=jj;son(end).B1=father.B1;son(end).T=k;son(end).ori=[father.ori,i];
                                son(end).finish0=[father.finish0,jj];son(end).finish1=father.finish1;son(end).task_flag=father.task_flag;
                                z=agent_updata(son(end).T,T_whole,father,task0,agent);
                                son(end).p_pre=z.p_pre;son(end).t_pre=z.t_pre;son(end).agents=z.agents;son(end).dis=z.dis;
                                %son(end).dis=father.dis+1;
                                if ~isempty(find(B0.F==son(end).B0)) && father.task_flag==0%由前缀进入过渡段
                                    son(end).task_flag=-length(B0.S)-1;
                                    son(end).finish0=[-jj];
                                elseif ~isempty(find(B0.F==son(end).B0)) && father.task_flag==-length(B0.S)-1%由过渡进入后缀段
                                    son(end).task_flag=son(end).B0;
                                    son(end).finish0=[-jj];
                                elseif father.task_flag==son(end).B0 && father.task_flag>0 && father.task_flag<=length(B0.S)%完成第一次后缀循环
                                    son(end).task_flag=length(B0.S)+jj;
                                    son(end).finish0=[-jj];
                                elseif father.task_flag==son(end).B0+length(B0.S) && father.task_flag>length(B0.S) && father.task_flag<=2*length(B0.S)%完成第一次后缀循环
                                    son(end).task_flag=2*length(B0.S)+jj;
                                else
                                    son(end).task_flag=father.task_flag;%状态不改变，继承父节点任务阶段状态
                                end
                            end
                        end
                    end
                end
               %% 记录新节点
                for k=1:length(son)
                    tree=[tree;son(k)];
                    over=[];
                    
                    %当B过大时，相似且时间较长的节点去除遍历资格(包括其子节点)
                    for k=2:(length(tree)-1)
                        %判断节点是否相似
                        if tree(k).finish1(end)==tree(end).finish1(end) && tree(k).finish0(end)==tree(end).finish0(end) &&tree(k).task_flag==tree(end).task_flag
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
    if n==0
        break
    end
end

%% 过渡路径
best_stateB=[];
best_stateT=[];
best_agents=[];
endpoint=0;
for i=1:length(tree)
    if ~isempty(find(B1.F==tree(i).B1))
        if endpoint==0
            endpoint=i;
        else
            if tree(endpoint).dis>tree(i).dis
                endpoint=i;
            end
        end
    end
end
if endpoint==0
    return
end
    
tree_code=tree(endpoint);

while(1)
    best_stateB=[best_stateB,tree_code.B0];
    best_stateT=[best_stateT,tree_code.T];   
    best_agents=[best_agents;tree_code.agents];
    if isempty(tree_code.ori)
        break;
    end
    tree_code=tree(tree_code.ori(end));
end
best_stateB=fliplr(best_stateB);
best_stateT=fliplr(best_stateT);
best_agents=flipud(best_agents);
best_stateB(1)=[];
best_stateT(1)=[];
best_agents(1,:)=[];
task_flag=tree(endpoint).task_flag;

%% 原任务再规划
point=struct('state',[],'ori',[],'dis',[],'finish',[],'traverse',0,'agents',[],'p_pre',[],'t_pre',[],'B',[],'T',[],'task_flag',task_flag);
point.agents=zeros([1,length(agent)]);
point.B=best_stateB(end);point.T=1;point.state=(point.B-1)*T0.N+point.T;
if isempty(find(B0.F==point.B))
    point.finish=best_stateB(end);
else
    point.finish=-best_stateB(end);
end
point.dis=0;
for i=1:length(agent)
    point.p_pre=[point.p_pre;agent(i).p_pre];
    point.t_pre=[point.t_pre;agent(i).t_pre];
end

tree2 = D_Tree_break(T_whole,agent,task0,B0,T0,point);
[tran_agents2,tran_stateB2,tran_stateT2,section] = solve_best_whole(tree2,B0,T0);
best_agents=[best_agents;tran_agents2];
best_stateB=[best_stateB,tran_stateB2];
best_stateT=[best_stateT,tran_stateT2];



end

