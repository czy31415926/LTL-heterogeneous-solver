function [lidar] = get_obstacle(scan)
%��ü����״���
laserdata = receive(scan);
lidar = readCartesian(laserdata);
end

