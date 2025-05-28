warning off all
addpath('.\LTL_Toolbox','.\Basic','.\Replan');
% N=[];TT=[];
% for i=1:10
%     N=[N,10*i];
%     TT=[TT,2*i];
% end
N=[10,100,1000,2000,3000,4000,5000,6000,7000,8000,9000,10000];
C=[5,10,100,100,100,100,100,100,100,100,100,100];
N1=N./C;
TT=N1/2;
x=3;
cate=C(x);
agent=Agent_initialize(N(x),C(x));%构造agent
category=cate;%定义类别数量
T_whole=map();%构建DTS
alphabet_whole=alphabet_set(obtainAlphabet(8));%构造字母表
formula2='Fp1 & Fp2 & Fp3 & Fp4';
nt=4;
alphabet=alphabet_whole(1:2^nt);
task=[];
onetask(1,[1:cate])=TT(x);
for i=1:nt
    task=[task;onetask];%每个任务的agent需求量
end
[B,T] = B_T(T_whole,alphabet_whole,formula2,task);
time=[];

for ttt=1:25
ttt
tic
tree = D_Tree_whole(T_whole,agent,task,B,T);
[best_agents,best_stateB,best_stateT,section]= solve_best_whole(tree,B,T);
time=[time,toc];
end






