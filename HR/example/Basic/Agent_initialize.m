function [agent] = Agent_initialize()
agent=[];
N1=5;
N2=5;
N3=5;
for i=1:N1+N2+N3
    agent=[agent;struct('category',[],'p',[],'p_pre',[],'t_pre',[])];%种类，起点，预测位置，预测时间
end
for i=1:N1
    agent(i).category=1;agent(i).p=[23,i+2];agent(i).p_pre=agent(i).p(1:2);agent(i).t_pre=0;
end
for i=N1+1:N1+N2
    agent(i).category=2;agent(i).p=[25,(i-N1)+2];agent(i).p_pre=agent(i).p(1:2);agent(i).t_pre=0;
end
for i=N1+N2+1:N1+N2+N3
    agent(i).category=3;agent(i).p=[27,(i-N1-N2)+2];agent(i).p_pre=agent(i).p(1:2);agent(i).t_pre=0;
end
end

