function [best_stateB,best_stateT,best_agents]=newtask(agent,T_whole,alphabet_whole,formula0,task0,B0,T0,p0,tran_B0,flag)
%UNTITLED2 �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
warning off all
addpath('.\LTL_Toolbox','.\Basic');
formula1='Fp4&Fp3&((!p4)Up3)';
task1=[[1,1];[1,1];[0,2];[1,0]];
[B1,T1] = B_T(T_whole,alphabet_whole,formula1,task1);
p1=[3,4];

tran_task_flag=flag;
if tran_task_flag~=0%�������׺��flag����Ϊ���ɶ�
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

%% ���������
for ii=1:1000
    n=0;%����������
    for i=1:length(tree)
        if tree(i).traverse==0
            tree(i).traverse=1;%�ڵ�״̬����Ϊ�ѱ���
            n=n+1;
            %�Դ�Ϊ���ڵ������ת��״̬
            father=tree(i);
            stateB0=father.B0;
            stateB1=father.B1;
            stateT=father.T;
            
            for j=1:length(B1.S)
                count=-1;%��ʱ�����ƽ����
                son=[];
                for k=1:T1.N
                    if isempty(find(p1==k))
                        continue
                    end
                    ap=T1.nodes(k).data;
                    if isempty(find(p0==k))%�����Ƿ����(�����)
                        if ~isempty(find(cell2mat(B1.trans(stateB1,j))==ap))&&isempty(find(tree(i).finish1==j))%���ڿ���ת���Ҳ������������
                            count=count+1;%�ƽ�������һ
                            son=[son;struct('B0',[],'B1',[],'T',[],'ori',[],'dis',[],'finish0',[],'finish1',[],'traverse',[0],'agents',[],'p_pre',[],'t_pre',[],'task_flag',[])];%�����±�ѡ�ӽڵ�
                            son(end).B0=father.B0;son(end).B1=j;son(end).T=k;son(end).ori=[father.ori,i];
                            son(end).finish0=father.finish0;son(end).finish1=[father.finish1,j];son(end).task_flag=father.task_flag;
                            z=agent_updata(son(end).T,T_whole,father,task1,agent);
                            son(end).p_pre=z.p_pre;son(end).t_pre=z.t_pre;son(end).agents=z.agents;son(end).dis=z.dis;
                            %son(end).dis=father.dis+1;
                        end
                    else%�����Ƿ����(���)
                        if ~isempty(find(cell2mat(B1.trans(stateB1,j))==ap))&&isempty(find(tree(i).finish1==j))%���ڿ���ת���Ҳ������������
                            count=0;
                            for jj=1:length(B0.S)
                                if ~isempty(find(cell2mat(B0.trans(stateB0,jj))==ap))&&isempty(find(tree(i).finish0==jj))%���ڿ���ת���Ҳ������������
                                    count=count+1;%�ƽ�������һ
                                    son=[son;struct('B0',[],'B1',[],'T',[],'ori',[],'dis',[],'finish0',[],'finish1',[],'traverse',[0],'agents',[],'p_pre',[],'t_pre',[],'task_flag',[])];%�����±�ѡ�ӽڵ�
                                    son(end).B0=jj;son(end).B1=j;son(end).T=k;son(end).ori=[father.ori,i];
                                    son(end).finish0=[father.finish0,jj];son(end).finish1=[father.finish1,j];son(end).task_flag=father.task_flag;
                                    z=agent_updata(son(end).T,T_whole,father,task1,agent);
                                    son(end).p_pre=z.p_pre;son(end).t_pre=z.t_pre;son(end).agents=z.agents;son(end).dis=z.dis;
                                    %son(end).dis=father.dis+1;
                                    if ~isempty(find(B0.F==son(end).B0)) && father.task_flag==0%��ǰ׺������ɶ�
                                        son(end).task_flag=-length(B0.S)-1;
                                        son(end).finish0=[-jj];
                                    elseif ~isempty(find(B0.F==son(end).B0)) && father.task_flag==-length(B0.S)-1%�ɹ��ɽ����׺��
                                        son(end).task_flag=son(end).B0;
                                        son(end).finish0=[-jj];
                                    elseif father.task_flag==son(end).B0 && father.task_flag>0 && father.task_flag<=length(B0.S)%��ɵ�һ�κ�׺ѭ��
                                        son(end).task_flag=length(B0.S)+jj;
                                        son(end).finish0=[-jj];
                                    elseif father.task_flag==son(end).B0+length(B0.S) && father.task_flag>length(B0.S) && father.task_flag<=2*length(B0.S)%��ɵ�һ�κ�׺ѭ��
                                        son(end).task_flag=2*length(B0.S)+jj;
                                    else
                                        son(end).task_flag=father.task_flag;%״̬���ı䣬�̳и��ڵ�����׶�״̬
                                    end
                                end
                            end
                        end
                    end
                end
                if count==0%���������ת������ԭ��ʽ�����޷�ʵ�֣���B0���з������ת
                    for jj=1:length(B0.S)
                        for k=1:T0.N
                            if ~isempty(find(p1==k))
                                continue
                            end
                            ap=T0.nodes(k).data;
                            if ~isempty(find(cell2mat(B0.trans(stateB0,jj))==ap))&&isempty(find(tree(i).finish0==jj))%���ڿ���ת���Ҳ������������
                                count=count+1;%�ƽ�������һ
                                son=[son;struct('B0',[],'B1',[],'T',[],'ori',[],'dis',[],'finish0',[],'finish1',[],'traverse',[0],'agents',[],'p_pre',[],'t_pre',[],'task_flag',[])];%�����±�ѡ�ӽڵ�
                                son(end).B0=jj;son(end).B1=father.B1;son(end).T=k;son(end).ori=[father.ori,i];
                                son(end).finish0=[father.finish0,jj];son(end).finish1=father.finish1;son(end).task_flag=father.task_flag;
                                z=agent_updata(son(end).T,T_whole,father,task0,agent);
                                son(end).p_pre=z.p_pre;son(end).t_pre=z.t_pre;son(end).agents=z.agents;son(end).dis=z.dis;
                                %son(end).dis=father.dis+1;
                                if ~isempty(find(B0.F==son(end).B0)) && father.task_flag==0%��ǰ׺������ɶ�
                                    son(end).task_flag=-length(B0.S)-1;
                                    son(end).finish0=[-jj];
                                elseif ~isempty(find(B0.F==son(end).B0)) && father.task_flag==-length(B0.S)-1%�ɹ��ɽ����׺��
                                    son(end).task_flag=son(end).B0;
                                    son(end).finish0=[-jj];
                                elseif father.task_flag==son(end).B0 && father.task_flag>0 && father.task_flag<=length(B0.S)%��ɵ�һ�κ�׺ѭ��
                                    son(end).task_flag=length(B0.S)+jj;
                                    son(end).finish0=[-jj];
                                elseif father.task_flag==son(end).B0+length(B0.S) && father.task_flag>length(B0.S) && father.task_flag<=2*length(B0.S)%��ɵ�һ�κ�׺ѭ��
                                    son(end).task_flag=2*length(B0.S)+jj;
                                else
                                    son(end).task_flag=father.task_flag;%״̬���ı䣬�̳и��ڵ�����׶�״̬
                                end
                            end
                        end
                    end
                end
               %% ��¼�½ڵ�
                for k=1:length(son)
                    tree=[tree;son(k)];
                    over=[];
                    
                    %��B����ʱ��������ʱ��ϳ��Ľڵ�ȥ�������ʸ�(�������ӽڵ�)
                    for k=2:(length(tree)-1)
                        %�жϽڵ��Ƿ�����
                        if tree(k).finish1(end)==tree(end).finish1(end) && tree(k).finish0(end)==tree(end).finish0(end) &&tree(k).task_flag==tree(end).task_flag
                            if tree(end).dis>=tree(k).dis
                                tree(end).traverse=1;
                            else
                                over=[over,k];%��¼kΪ���ڵ��ţ��ȴ����������ʸ�
                            end
                        end 
                    end
                    %�������Ƶ����ڵ㼰���ӽڵ�
                    for k=1:length(over)%ѡ�����ڵ�
                        %�ȴ����ڵ�
                        tree(over(k)).traverse=1;
                        %�ٴ����ӽڵ�
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

%% ����·��
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

%% ԭ�����ٹ滮
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

