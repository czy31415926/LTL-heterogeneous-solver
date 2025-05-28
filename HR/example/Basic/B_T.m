function [B,T] = B_T(T_whole,alphabet_whole,formula,task)
%UNTITLED3 此处显示有关此函数的摘要
%   此处显示详细说明
addpath('.\LTL_Toolbox','.\Plot');
%% 获得B，T
N_p=size(task,1);%命题数
alphabet=alphabet_whole(1:2^N_p);
B=create_buchi(formula,alphabet);

T=T_whole;
T.M=N_p;
N=T.N;
for i=1:length(T_whole.nodes)
    if T_whole.nodes(i).data==2^N_p
        N=i-1;
        break;
    end
end
T.nodes=T_whole.nodes(1:N);
T.N=N;
T.adj=T_whole.adj(1:N,1:N);
end

