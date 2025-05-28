function [best_stateT,best_stateB,best_agents,single_agent,finish] = task_updata(state,new_stateT,new_stateB,new_agents,best_stateT,best_stateB,best_agents,finish)
best_stateT(state:end)=[];
best_stateT=[best_stateT,new_stateT];
best_stateB(state:end)=[];
best_stateB=[best_stateB,new_stateB];
best_agents(state:end,:)=[];
best_agents=[best_agents;new_agents];
single_agent=best_agents;
for i=1:size(single_agent,1)
    for j=1:size(single_agent,2)
        if single_agent(i,j)==1
            single_agent(i,j)=best_stateT(i);
        end
    end
end
finish(state:end,:)=[];
finish=[finish;zeros([length(new_stateT),size(best_agents,2)])];
%{
best_stateB%查看完成后状态
best_stateT%查看新的顺序
best_agents%查看新的agent选择
single_agent%查看新的agent任务列表
finish%查看新的任务进度表
%}
end

