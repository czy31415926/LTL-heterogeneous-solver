function [next_point,target]=get_next_point(m,agent,target,r)
m_init=m;
next_point=[];
for i=1:length(agent)
    if norm(agent(i).p(1:2)-target(i,:))<=r
        next=agent(i).p(1:2);
        next_point=[next_point;next];
        continue;
    end
    m=m_init;
    for j=1:length(agent)
        if j==i
            continue;
        end
        %定义其他agent障碍
        x=round(agent(j).p(1)*10);
        y=round(agent(j).p(2)*10);
        s=-4;e=-s;
        for q=s:e
            for p=s:e
                if x+q<=0||x+q>400||y+p<=0||y+p>400
                    continue;
                end
                if q^2+p^2>s^2
                    continue;
                end
                m(x+q,y+p)=1;
            end
        end
    end
    map2=logical(rot90(m,1));
    map2 = robotics.BinaryOccupancyGrid(map2,10);
    %inflate(map2,0.1);
    prm = robotics.PRM;
    prm.Map = map2;
    prm.NumNodes = 250;
    prm.ConnectionDistance = 5;
    startLocation = agent(i).p(1:2);
    endLocation = target(i,:);
    try
         path = findpath(prm, startLocation, endLocation);
    catch
         path=agent(i).p(1:2);
    end
    if size(path,1)<3
        next=agent(i).p(1:2);
    else
        next=path(3,:);
    end
    next_point=[next_point;next];
    agent(i).p(1:2)=next;
end






