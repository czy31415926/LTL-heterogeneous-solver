function [posmsg] = get_state(odom)
%���ָ��������λ�û���odom����Ϣ����Χ���������λ�úͽǶ�
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

