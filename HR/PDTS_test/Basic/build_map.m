function real_m = build_map()
%addpath('.\LTL_Toolbox','.\Basic','.\Replan','.\turtlebot');
T_whole=map();
m=zeros([400,400]);
wide1=6;%Ç½ºñ
wide2=15;%»úÆ÷°ë¾¶
wide=wide1+2*wide2;
x=6;
for i=1:100+wide2
    for j=-wide/2:wide/2
        m(i,j+100+x)=1;
        m(i,j+300-x)=1;
        m(j+300-x,i)=1;
        m(j+300-x,401-i)=1;
    end
end
for i=1:length(m)
    for j=1:wide2
        m(j,i)=1;
        m(401-j,i)=1;
        m(i,j)=1;
        m(i,401-j)=1;
    end
end
real_m=m;
map1=logical(rot90(m,1));
map1 = robotics.BinaryOccupancyGrid(map1,100);
show(map1);hold on;
for i=1:T_whole.N
    color=[0.5+0.5*sin(2*pi*i/T_whole.N),0.5+0.5*sin(2*pi*i/T_whole.N+2*pi/3),0.5+0.5*sin(2*pi*i/T_whole.N-2*pi/3)];
    scatter(T_whole.nodes(i).position(1),T_whole.nodes(i).position(2),1000,'MarkerEdgeColor','b','MarkerFaceColor',color);hold on
    text(T_whole.nodes(i).position(1),T_whole.nodes(i).position(2),num2str(i));
end
axis([-0.2 4.2 -0.2 4.2]);


