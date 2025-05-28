function [next_point,target]=get_next_point(m,agent,target)
m_init=m;
next_point=[];
for i=1:length(agent)
    if norm(agent(i).p(1:2)-target(i,:))<=0.05
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
        x=round(agent(j).p(1)*100);
        y=round(agent(j).p(2)*100);
        s=-30;e=-s;
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
    map2 = robotics.BinaryOccupancyGrid(map2,100);
    prm = robotics.PRM;
    prm.Map = map2;
    prm.NumNodes = 300;
    prm.ConnectionDistance = 0.5;
    startLocation = agent(i).p(1:2);
    x=round(target(i,1)*100);
    y=round(target(i,2)*100);
    endLocation = target(i,:);
    try
         path = findpath(prm, startLocation, endLocation);
    catch
         path =agent(i).p(1:2);
    end
    %path = findpath(prm, startLocation, endLocation);
    if size(path,1)<3
        next=agent(i).p(1:2);
    else
        next=path(3,:);
    end
    if m(round(100*agent(i).p(1)),round(100*agent(i).p(2)))==1&&abs(startLocation(1)-2)<=1.25
        next=[startLocation(1)+(startLocation(1)-2)/1.5*0.1,startLocation(2)+(startLocation(2)-2)/1.5*0.1];
    end
    if m(round(100*agent(i).p(1)),round(100*agent(i).p(2)))==1&&abs(startLocation(1)-2)>1.8
        next=[startLocation(1)+(2-startLocation(1))/1.9*0.1,startLocation(2)+(2-startLocation(2))/1.9*0.1];
    end
    next_point=[next_point;next];
    agent(i).p(1:2)=next;
end






