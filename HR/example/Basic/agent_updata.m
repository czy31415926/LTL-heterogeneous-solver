function a=agent_updata(sonT,T,father,task,agent)
%agent����struct('category',[],'p0',[],'p_pre',[],'t_pre',[])]���࣬��㣬Ԥ��λ�ã�Ԥ��ʱ�䣬��������Ϊ����η���
%son��father��tree�ṹһ��
%task����������agent���࣬��������������
%% ��ʼ��
for i=1:length(agent)%ʵʱ���ݣ�λ����ʱ��Ļ��
    agent(i).p_pre=father.p_pre(i,:);
    agent(i).t_pre=father.t_pre(i);
end
agentnew=agent;

task_now=task(log2(T.nodes(sonT).data)+1,:);
choose=zeros([1,length(agent)]);%��¼ѡ���agent

%% ����Ȩ�ز���������
value=zeros([length(agent),1]);%valueΪ��0ʱ�̿�ʼ��ʱ����agent���絽��Ŀ�ĵ�ʱ��
for i=1:length(agent)
    p_task=T.nodes(sonT).position;
    p_agent=agent(i).p_pre;
    value(i)=agent(i).t_pre+((p_agent(1)-p_task(1))^2+(p_agent(2)-p_task(2))^2)^0.5;%�������ʱ��+����ʱ��
end
value2=-ones(length(task_now),length(agent));
index2=-ones(length(task_now),length(agent));
for i=1:length(task_now)%��������
    pos=0;
    for j=1:length(agent)
        if agent(j).category==i
            pos=pos+1;
            value2(i,pos)=value(j);%��¼value
            index2(i,pos)=j;%��¼���
        end
    end
end

%% ��ѡagent
choosetable=zeros([length(task_now),length(agent)]);%��¼��ѡ�е�agent�ı��
valuetable=zeros([length(task_now),length(agent)]);%��¼��ѡ�е�agent��value
for i=1:length(task_now)%��ѡ����
    value_test=value2(i,:);
    index_test=index2(i,:);
    value_max=max(value_test);
    %ʹ��Чֵ-1Ϊ2�����ֵʹ�䲻Ӱ��agent����
    for j=1:length(value_test)
        if value_test(j)==-1
            value_test(j)=2*value_max;
        end
    end
    [value_sort,index_sort]=sort(value_test,'ascend');
    if task_now(i)>0
        for j=1:task_now(i)
            choosetable(i,j)=index2(i,index_sort(j));%ѡ���j��С��agent�ı�ż���choosetable
            valuetable(i,j)=value2(i,index_sort(j));%ѡ���j��С��agent��value����valuetable
        end
    end
end
task_now;
choosetable;
valuetable;
%% �������
for i=1:length(task_now)
    for j=1:length(agent)
        if choosetable(i,j)~=0
            num=choosetable(i,j);
            choose(num)=1;%�����Ӧ��Ų�������
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
%������Ҫȫ�����������agent�μӲſ��Խ������񣬿���ʱ��Ϊ��Զʱ���
%���ֵ����δ�����agent����֤ǰһ��������ɺ�����ɱ�������
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



    
    
    
    
    