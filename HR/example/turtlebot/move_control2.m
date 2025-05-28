function [v, omega] = move_control2(target,state)
%直线运动控制函数
%% 初始化
x1=state(1);y1=state(2);
beta=state(3);
x2=target(1);y2=target(2);
%计算位置偏角
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
%计算方向偏角
if alpha-beta>180
    theta=(alpha-beta)-360;
elseif alpha-beta<-180
    theta=(alpha-beta)+360;
else
    theta=(alpha-beta);
end
%% 求解
P0=0.01;%初始角度矫正比例
P1=1;%速度比例
P2=0.005;%角速度比例
if abs(theta)>5
    omega=min(P0*theta,1.5);
    v=0;
else
    v=min(P1*norm(target-state(1:2)),0.2);
    omega=min(P2*theta,1.5);
end


