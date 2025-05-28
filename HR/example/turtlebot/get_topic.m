function [topic] = get_topic(N)
%��i�ж�Ӧ��i��agent��λ�ã������������״ﻰ��
pos='/odom';move='/cmd_vel';scan='/scan';reset='/reset';robot='/robot';
topic=[];
for i=1:N
    onetopic=struct('pos',[robot,num2str(i),pos],'move',[robot,num2str(i),move],'scan',[robot,num2str(i),scan],'reset',[robot,num2str(i),reset]);
    topic=[topic;onetopic];
end

