function [best_agents,best_stateB,best_stateT,section] = solve_best_whole(tree,B,T)
%UNTITLED �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
%Ѱ�����ŵ���ֹ״̬
t_best=100000;
k_best=0;
for i=1:length(tree)
    if tree(i).task_flag==length(B.S)+1
        if tree(i).t_pre<t_best
            t_best=tree(i).dis;
            k_best=i;
        end
    end
end
%׷��·��
point=tree(k_best);
tree_code=tree(k_best);
best_stateB=[];
best_stateT=[];
best_agents=[];
section=[1,0,0];
while(1)
    best_stateB=[best_stateB,tree_code.B];
    best_stateT=[best_stateT,tree_code.T];   
    best_agents=[best_agents;tree_code.agents];
    if tree_code.task_flag<length(B.S)+1 &&tree_code.task_flag>0
        section(3)=section(3)+1;
    elseif tree_code.task_flag<0
        section(2)=section(2)+1;
    elseif tree_code.task_flag==0
        section(1)=section(1)+1;
    end
    if tree_code.ori(end)==1
        break;
    end
    tree_code=tree(tree_code.ori(end));
end
best_stateB=fliplr(best_stateB);
best_stateT=fliplr(best_stateT);
best_agents=flipud(best_agents);


end

