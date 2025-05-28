function a=agent_updata(sonT,T,father,task,agent)
%agent参数struct('category',[],'p0',[],'p_pre',[],'t_pre',[])]种类，起点，预测位置，预测时间，后两项是为了入参方便
%son，father与tree结构一致
%task和列数代表agent种类，行数代表任务编号
%% 初始化
for i=1:length(agent)%实时数据：位置与时间的获得
    agent(i).p_pre=father.p_pre(i,:);
    agent(i).t_pre=father.t_pre(i);
end
agentnew=agent;

task_now=task(log2(T.nodes(sonT).data)+1,:);
choose=zeros([1,length(agent)]);%记录选择的agent

%% 计算权重并分离种类
value=zeros([length(agent),1]);%value为从0时刻开始计时，该agent最早到达目的地时间
for i=1:length(agent)
    p_task=T.nodes(sonT).position;
    p_agent=agent(i).p_pre;
    value(i)=agent(i).t_pre+((p_agent(1)-p_task(1))^2+(p_agent(2)-p_task(2))^2)^0.5;%解除锁定时间+到达时间
end
value2=-ones(length(task_now),length(agent));
index2=-ones(length(task_now),length(agent));
for i=1:length(task_now)%分离种类
    pos=0;
    for j=1:length(agent)
        if agent(j).category==i
            pos=pos+1;
            value2(i,pos)=value(j);%记录value
            index2(i,pos)=j;%记录编号
        end
    end
end

%% 挑选agent
choosetable=zeros([length(task_now),length(agent)]);%记录挑选中的agent的编号
valuetable=zeros([length(task_now),length(agent)]);%记录挑选中的agent的value
for i=1:length(task_now)%挑选种类
    value_test=value2(i,:);
    index_test=index2(i,:);
    value_max=max(value_test);
    %使无效值-1为2倍最大值使其不影响agent排序
    for j=1:length(value_test)
        if value_test(j)==-1
            value_test(j)=2*value_max;
        end
    end
    [value_sort,index_sort]=sort(value_test,'ascend');
    if task_now(i)>0
        for j=1:task_now(i)
            choosetable(i,j)=index2(i,index_sort(j));%选择第j个小的agent的编号加入choosetable
            valuetable(i,j)=value2(i,index_sort(j));%选择第j个小的agent的value加入valuetable
        end
    end
end
task_now;
choosetable;
valuetable;
%% 输出处理
for i=1:length(task_now)
    for j=1:length(agent)
        if choosetable(i,j)~=0
            num=choosetable(i,j);
            choose(num)=1;%代表对应编号参与任务
            agentnew(num).p_pre=T.nodes(sonT).position;
            agentnew(num).t_pre=agent(num).t_pre+value(num);
        end
    end
end
p_pre=[];
t_pre=[];
for i=1:length(agentnew)
    p_pre=[p_pre;agentnew(i).p_pre];
    t_pre=[t_pre;agentnew(i).t_pre];
end
%由于需要全部参与任务的agent参加才可以结束任务，控制时间为最远时间点
%最大值包含未参与的agent，保证前一个任务完成后再完成本次任务
t_max=max(t_pre);
for i=1:length(task_now)
    for j=1:length(agent)
        if choosetable(i,j)~=0
            num=choosetable(i,j);
            t_pre(num)=t_max;
        end
    end
end
a=struct('dis',[max(t_pre)],'agents',[choose],'p_pre',[p_pre],'t_pre',[t_pre]);



    
    
    
    
    