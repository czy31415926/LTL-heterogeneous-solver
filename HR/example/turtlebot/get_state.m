function [posmsg] = get_state(odom)
%获得指定机器人位置话题odom的信息，范围相对于起点的位置和角度
odomdata = receive(odom);
pose = odomdata.Pose.Pose;
x = pose.Position.X;
y = pose.Position.Y;
z = pose.Position.Z;
quat = pose.Orientation;
angles = quat2eul([quat.W quat.X quat.Y quat.Z]);
theta = deg2rad(angles(1));
posmsg=[roundn(x,-2),roundn(y,-2),roundn(theta,-5)*3600];
end

