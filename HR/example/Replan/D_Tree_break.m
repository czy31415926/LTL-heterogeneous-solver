function tree = D_Tree_break(T_whole,agent,task,B,T,point)
%% ����������tree
tic
tree=[];
tree=[tree;point];
for ii=1:1000
    n=0;
    for i=1:length(tree)
        if tree(i).traverse==0
            tree(i).traverse=1;%�ڵ�״̬����Ϊ�ѱ���
            n=n+1;
            %�Դ�Ϊ���ڵ������ת��״̬
            father=tree(i);
            stateB=floor((tree(i).state-1)/T.N)+1;
            stateT=mod(tree(i).state,T.N);
            if stateT==0
                stateT=T.N;
            end
            for j=1:length(B.S)%������ת��״̬
                son=[];
                for k=1:T.N%�����ص�
                    ap=T.nodes(k).data;
                    if ~isempty(find(cell2mat(B.trans(stateB,j))==ap))&&isempty(find(tree(i).finish==j))%���ڿ���ת���Ҳ������������
                        son=[son;struct('state',[],'ori',[],'dis',[],'finish',[],'traverse',[],'agents',[],'p_pre',[],'t_pre',[],'B',[],'T',[],'task_flag',[])];%�����±�ѡ�ӽڵ�
                        son(end).state=(j-1)*T.N+k;son(end).ori=[father.ori,i];son(end).dis=0;
                        son(end).finish=[tree(i).finish,j];son(end).traverse=0;
                        son(end).B=j;son(end).T=k;
                        z=agent_updata(son(end).T,T_whole,father,task,agent);
                        son(end).p_pre=z.p_pre;son(end).t_pre=z.t_pre;son(end).agents=z.agents;son(end).dis=z.dis;
                        if ~isempty(find(B.F==son(end).B)) && father.task_flag==0%��ǰ׺������ɶ�
                            son(end).task_flag=-length(B.S)-1;
                            son(end).finish=[-j];
                        elseif ~isempty(find(B.F==son(end).B)) && father.task_flag==-length(B.S)-1%�ɹ��ɽ����׺��
                            son(end).task_flag=son(end).B;
                            son(end).finish=[-j];
                        elseif father.task_flag==son(end).B && father.task_flag>0%��ɵ�һ�κ�׺ѭ��
                            son(end).task_flag=length(B.S)+1;
                        else
                            son(end).task_flag=father.task_flag;%״̬���ı䣬�̳и��ڵ�����׶�״̬
                        end 
                    end
                end
                %�����½ڵ�ʱ��ѡ�����Žڵ����tree��������
                for kk=1:length(son)
                    tree=[tree;son(kk)];
                    over=[];
                    %��B����ʱ��������ʱ��ϳ��Ľڵ�ȥ�������ʸ�(�������ӽڵ�)
                    for k=1:(length(tree)-1)
                        %�жϽڵ��Ƿ�����
                        if tree(k).finish(end)==tree(end).finish(end) && tree(k).task_flag==tree(end).task_flag
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
    %�鿴�Ƿ��������
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
disp(['����������ʱ��: ',num2str(toc)]);


end

