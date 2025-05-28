function [agent] = Agent_initialize(Nall,C)
agent=[];
cate=C;
N=floor(Nall/C);
for i=1:N*cate
    agent=[agent;struct('category',[],'p',[],'p_pre',[],'t_pre',[])];%种类，起点，预测位置，预测时间
end
for j=1:cate
    for i=(j-1)*N+1:(j-1)*N+N
        agent(i).category=j;agent(i).p=[j/cate*9,2+(mod(i,4)/N)*6];agent(i).p_pre=agent(i).p(1:2);agent(i).t_pre=0;
    end
end

