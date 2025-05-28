function [v, omega] = move_control1(target,state)
%ֱ���˶����ƺ���
%% ��ʼ��
x1=state(1);y1=state(2);
beta=state(3);
x2=target(1);y2=target(2);
%����λ��ƫ��
if x1<x2
    alpha=atan((y2-y1)/(x2-x1))*180/pi;
elseif x1>x2&&y1>y2
    alpha=atan((y2-y1)/(x2-x1))*180/pi-180;
elseif x1>x2&&y1<y2
    alpha=atan((y2-y1)/(x2-x1))*180/pi+180;
elseif x1>x2&&y1==y2
    alpha=180;
elseif x1==x2&&y1<y2
    alpha=90;
elseif x1==x2&&y1>y2
    alpha=-90;
else
    alpha=0;
end
%���㷽��ƫ��
if alpha-beta>180
    theta=(alpha-beta)-360;
elseif alpha-beta<-180
    theta=(alpha-beta)+360;
else
    theta=(alpha-beta);
end
%% ���
P0=0.01;%PIDϵ��
P1=0.5;
if abs(theta)>5
    omega=P0*theta;
    v=0;
else
    v=0.002+P1*norm(target-state(1:2));
    omega=0;
end


