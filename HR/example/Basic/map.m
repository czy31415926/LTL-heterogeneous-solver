function T=map()
%地图大小
T.X=30;T.Y=30;
%定义初始状态
T.Q0 = [1,1];
%定义特殊节点位置
T.nodes=[];
T.N=5;%特殊节点数
T.M=5;%几种特殊节点
N=T.N;
for i=1:N
    T.nodes=[T.nodes, struct('position',[],'atomicProp',[],'data',[])];
end
d=5;
T.nodes(1).atomicProp='a';T.nodes(1).position=[d,30-d];T.nodes(1).data=1;
T.nodes(2).atomicProp='b';T.nodes(2).position=[d,15];T.nodes(2).data=2;
T.nodes(3).atomicProp='c';T.nodes(3).position=[d,d];T.nodes(3).data=4;
T.nodes(4).atomicProp='d';T.nodes(4).position=[30-d,d];T.nodes(4).data=8;
T.nodes(5).atomicProp='e';T.nodes(5).position=[30-d,30-d];T.nodes(5).data=16;




%定义节点转换
T.adj = zeros([N,N]);
for i=1:N
    for j=1:N
        T.adj(i,j)=((T.nodes(i).position(1)-T.nodes(j).position(1))^2+(T.nodes(i).position(2)-T.nodes(j).position(2))^2)^0.5;
    end
end
    

