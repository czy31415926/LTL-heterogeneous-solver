function [lidar] = get_obstacle(scan)
%获得激光雷达结果
laserdata = receive(scan);
lidar = readCartesian(laserdata);
end

