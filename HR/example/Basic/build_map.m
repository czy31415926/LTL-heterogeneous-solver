function real_m = build_map()
m=zeros([300,300]);
wide=6;
%边界
for i=1:length(m)
    for j=1:wide
        m(j,i)=1;
        m(size(m,1)+1-j,i)=1;
        m(i,j)=1;
        m(i,size(m,2)+1-j)=1;
    end
end
%栅栏
wide=8;
for i=1:100
    for j=1:wide
        m(i,j+100-wide/2)=1;
        m(i,j+200-wide/2)=1;            
        m(301-i,j+200-wide/2)=1;
        m(j+200-wide/2,i)=1;
        if i<=50
            m(j+200-wide/2,301-i)=1;
        end
        if i<20
            m(101-j,200+i)=1;
            m(101-j,200-i)=1;
            m(101-j,100+i)=1;
            m(101-j,100-i)=1;
        end
    end
end
%建筑
for i=121:180
    for j=21:80
        m(i,j)=1;
    end
end



real_m=m;
map1=logical(rot90(m,1));
map1 = robotics.BinaryOccupancyGrid(map1,10);
show(map1);hold on;

%绘制区域
d=0.5;
fill([1 8 8 1],[2 2 8 8],[0,0.3,0]);hold on;
fill([1 8 8 1],[12 12 18 18],[0,0.6,0]);hold on;
fill([1 8 8 1],[22 22 28 28],[0,1,0]);hold on;
fill([21 29 29 21],[21 21 29 29],[1,0.5,0]);hold on;
fill([22 28 28 22],[2 2 8 8],[0.8,0,1]);hold on;
fill([12 18 18 12],[2 2 8 8],[0,0,1]);hold on;

title('Map');
xlabel('X');
ylabel('Y');
axis([0 30 0 35]);

