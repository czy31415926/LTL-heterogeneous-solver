function [topic] = get_topic(N)
%第i行对应第i个agent的位置，动作，激光雷达话题
pos='/odom';move='/cmd_vel';scan='/scan';reset='/reset';robot='/robot';
topic=[];
for i=1:N
    onetopic=struct('pos',[robot,num2str(i),pos],'move',[robot,num2str(i),move],'scan',[robot,num2str(i),scan],'reset',[robot,num2str(i),reset]);
    topic=[topic;onetopic];
end

