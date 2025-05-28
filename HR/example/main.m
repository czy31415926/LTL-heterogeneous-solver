function varargout = main(varargin)
% MAIN MATLAB code for main.fig
%      MAIN, by itself, creates a new MAIN or raises the existing
%      singleton*.
%
%      H = MAIN returns the handle to a new MAIN or the handle to
%      the existing singleton*.
%
%      MAIN('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MAIN.M with the given input arguments.
%
%      MAIN('Property','Value',...) creates a new MAIN or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before main_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to main_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help main

% Last Modified by GUIDE v2.5 17-Apr-2024 14:55:51

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @main_OpeningFcn, ...
                   'gui_OutputFcn',  @main_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before main is made visible.
function main_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to main (see VARARGIN)

% Choose default command line output for main
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes main wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = main_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

%% 初始化
%添加路径
global stop;stop=0;%终止标志
global reactive;reactive=zeros([1,5]);%中断标志
global operation;operation=0;%主程序运行标志

axes(handles.axes1);
axis([0,30,0,35]);



% --- Executes on button press in get_start.
function get_start_Callback(hObject, eventdata, handles)
% hObject    handle to get_start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
warning off all
addpath('.\LTL_Toolbox','.\Basic','.\Replan');
%% 全局变量设定
%标志位全局变量
global stop;
global reactive;
global operation;
if stop==1
    stop=0;
end
operation=1;
%机器人全局变量
global move;
global odom;
global scan;
global reset;

clc;
%% 任务初始化
agent=Agent_initialize();%构造agent
category=3;%定义类别数量
T_whole=map();%构建DTS
real_map=build_map();
alphabet_whole=alphabet_set(obtainAlphabet(8));%构造字母表

%% 绘图
axes(handles.axes1);
% 定义agent颜色
color=zeros([category,3]);
for i=1:category
    color(i,:)=[0.5+0.5*sin(2*pi*i/category),0.5+0.5*sin(2*pi*i/category+2*pi/3),0.5+0.5*sin(2*pi*i/category-2*pi/3)];
end
for j=1:length(agent)
    if agent(j).category==0
        h1(j)=scatter(agent(j).p(1),agent(j).p(2),15,'MarkerEdgeColor','k','MarkerFaceColor','k');
    else
        h1(j)=scatter(agent(j).p(1),agent(j).p(2),15,'MarkerEdgeColor','k','MarkerFaceColor',color(agent(j).category,:));
    end
end
drawnow;
%% 初始路径获取
formula0='GF(p1|p2)&GFp3&GFp4';
task0=[[2,3,1];[2,3,1];[3,3,3];[5,5,5]];%每个任务的agent需求量
[B0,T0] = B_T(T_whole,alphabet_whole,formula0,task0);
p0=[1,2,3,4];%formula0的参与任务
tree0 = D_Tree_whole(T_whole,agent,task0,B0,T0);
[best_agents0,best_stateB0,best_stateT0,section]= solve_best_whole(tree0,B0,T0);
rbest_agents=best_agents0(length(best_stateT0)-section(3)+1:length(best_stateT0),:);
rbest_stateT=best_stateT0(length(best_stateT0)-section(3)+1:length(best_stateT0));
rbest_stateB=best_stateB0(length(best_stateB0)-section(3)+1:length(best_stateB0));

%% 单个agent任务划分
single_agent=best_agents0;
for i=1:size(single_agent,1)
    for j=1:size(single_agent,2)
        if single_agent(i,j)==1
            single_agent(i,j)=best_stateT0(i);
        end
    end
end
state=1;
progress=ones(1,length(agent));
r=0.2;%到达目标点的许可半径
finish=zeros([length(best_stateT0),length(agent)]);
moveing=0;
reactivetext='None';
tp=[];
for i=2:2:6
    for j=3:7
        tp=[tp;[i,j]];
    end
end
tp3=tp+[0,0];
tp2=tp+[0,10];
tp1=tp+[0,20];
tp4=tp+[20,0];
tp5=tp+[21,20];
%% 迭代
for t=1:1000
    if state>length(best_stateT0)||state>20
        break
    end
    if moveing==0%如果移动结束
        %% 检验停止
        if stop==1
            stop=0;
            break
        end

        %% 检验临时任务
        if reactive(1)==1
            reactivetext='Temporary task';
            %% 临时任务
            if state>1
                stateB0=best_stateB0(state-1);
            else
                stateB0=1;
            end
            [best_stateB1,best_stateT1,best_agents1]=newtask(agent,T_whole,alphabet_whole,formula0,task0,B0,T0,p0,stateB0,flag);
            if isempty(best_stateT1)
                disp('no feasible plan for reactive1');
                return
            end
            [best_stateT0,best_stateB0,best_agents0,single_agent,finish] = task_updata(state,best_stateT1,best_stateB1,best_agents1,best_stateT0,best_stateB0,best_agents0,finish);
            progress(1,[1:length(agent)])=state;
            reactive(1)=0;
        end
        %% 检验agent失效
        if reactive(2)==1
            reactivetext='Infeasible agent';
            agent(1).category=0;
            task0=[[2,2,1];[3,2,3];[2,2,2];[4,5,5]];
            %构造节点
            point=struct('state',[],'ori',[],'dis',[],'finish',[],'traverse',0,'agents',[],'p_pre',[],'t_pre',[],'B',[],'T',[],'task_flag',flag);
            point.agents=zeros([1,length(agent)]);
            if state>1
                point.B=best_stateB0(state-1);
            else
                point.B=1;
            end
            point.T=1;point.state=(point.B-1)*T0.N+point.T;
            if isempty(find(B0.F==point.B))
                point.finish=point.B;
            else
                point.finish=-point.B;
            end
            point.dis=0;
            for i=1:length(agent)
                point.p_pre=[point.p_pre;agent(i).p(1:2)];
                point.t_pre=[point.t_pre;0];
            end
            %再规划
            tree2 = D_Tree_break(T_whole,agent,task0,B0,T0,point);
            [best_agents2,best_stateB2,best_stateT2,section2] = solve_best_whole(tree2,B0,T0);
            if isempty(best_stateT2)
                disp('no feasible plan for reactive2');
                return
            end
            %更新规划
            rbest_agents=best_agents2(length(best_stateT2)-section2(3)+1:length(best_stateT2),:);
            rbest_stateT=best_stateT2(length(best_stateT2)-section2(3)+1:length(best_stateT2));
            rbest_stateB=best_stateB2(length(best_stateB2)-section2(3)+1:length(best_stateB2));
            [best_stateT0,best_stateB0,best_agents0,single_agent,finish] = task_updata(state,best_stateT2,best_stateB2,best_agents2,best_stateT0,best_stateB0,best_agents0,finish);
            progress(1,[1:length(agent)])=state;
            reactive(2)=0;
        end
        %% 检验task修改
        if reactive(3)==1
            reactivetext='Change task';
            if agent(1).category==1
                task0=[[2,2,1];[1,1,1];[2,2,2];[5,5,5]];
            else
                task0=[[2,2,1];[1,1,1];[2,2,2];[4,5,5]];
            end
            %构造节点
            point=struct('state',[],'ori',[],'dis',[],'finish',[],'traverse',0,'agents',[],'p_pre',[],'t_pre',[],'B',[],'T',[],'task_flag',flag);
            point.agents=zeros([1,length(agent)]);
            if state>1
                point.B=best_stateB0(state-1);
            else
                point.B=1;
            end
            point.T=1;point.state=(point.B-1)*T0.N+point.T;
            if isempty(find(B0.F==point.B))
                point.finish=point.B;
            else
                point.finish=-point.B;
            end
            point.dis=0;
            for i=1:length(agent)
                point.p_pre=[point.p_pre;agent(i).p(1:2)];
                point.t_pre=[point.t_pre;0];
            end
            %再规划
            tree3 = D_Tree_break(T_whole,agent,task0,B0,T0,point);
            [best_agents3,best_stateB3,best_stateT3,section3] = solve_best_whole(tree3,B0,T0);
            if isempty(best_stateT3)
                disp('no feasible plan for reactive3');
                return
            end
            %更新规划
            rbest_agents=best_agents3(length(best_stateT3)-section3(3)+1:length(best_stateT3),:);
            rbest_stateT=best_stateT3(length(best_stateT3)-section3(3)+1:length(best_stateT3));
            rbest_stateB=best_stateB3(length(best_stateB3)-section3(3)+1:length(best_stateB3));
            [best_stateT0,best_stateB0,best_agents0,single_agent,finish] = task_updata(state,best_stateT3,best_stateB3,best_agents3,best_stateT0,best_stateB0,best_agents0,finish);
            progress(1,[1:length(agent)])=state;
            reactive(3)=0;
        end
        
        %% 检验环境修改
        if reactive(4)==1
            fill([9 10 10 9],[10 10 20 20],[0,0,0]);hold on;
            drawnow;
            reactivetext='Change env';
            %构造节点
            point=struct('state',[],'ori',[],'dis',[],'finish',[],'traverse',0,'agents',[],'p_pre',[],'t_pre',[],'B',[],'T',[],'task_flag',flag);
            point.agents=zeros([1,length(agent)]);
            if state>1
                point.B=best_stateB0(state-1);
            else
                point.B=1;
            end
            point.T=1;point.state=(point.B-1)*T0.N+point.T;
            if isempty(find(B0.F==point.B))
                point.finish=point.B;
            else
                point.finish=-point.B;
            end
            point.dis=0;
            for i=1:length(agent)
                point.p_pre=[point.p_pre;agent(i).p(1:2)];
                point.t_pre=[point.t_pre;0];
            end
            %再规划
            tree3 = D_Tree_break2(T_whole,agent,task0,B0,T0,point);
            [best_agents3,best_stateB3,best_stateT3,section3] = solve_best_whole(tree3,B0,T0);
            if isempty(best_stateT3)
                disp('no feasible plan for reactive3');
                return
            end
            %更新规划
            rbest_agents=best_agents3(length(best_stateT3)-section3(3)+1:length(best_stateT3),:);
            rbest_stateT=best_stateT3(length(best_stateT3)-section3(3)+1:length(best_stateT3));
            rbest_stateB=best_stateB3(length(best_stateB3)-section3(3)+1:length(best_stateB3));
            [best_stateT0,best_stateB0,best_agents0,single_agent,finish] = task_updata(state,best_stateT3,best_stateB3,best_agents3,best_stateT0,best_stateB0,best_agents0,finish);
            progress(1,[1:length(agent)])=state;
            reactive(4)=0;
        end
        
        
        %% 检验是否进行任务更新
        if length(best_stateT0)-state<length(B0.S)+1
            reactivetext='Updata';
            best_stateT0=[best_stateT0,rbest_stateT];
            best_stateB0=[best_stateB0,rbest_stateB];
            best_agents0=[best_agents0;rbest_agents];
            single_agent=best_agents0;
            for i=1:size(single_agent,1)
                for j=1:size(single_agent,2)
                    if single_agent(i,j)==1
                        single_agent(i,j)=best_stateT0(i);
                    end
                end
            end
            finish=[finish;zeros([length(rbest_stateT),length(agent)])];
        end

        %% 检验完成度，分配目标
        %检验各agent下一个目标（为0则agent停止）
        target=zeros([1,length(agent)]);
        target_pos=zeros([length(agent),2]);
        for j=1:length(target)
            for k=progress(j):length(best_stateT0)
                if single_agent(k,j)~=0
                    target(j)=single_agent(k,j);
                    target_pos(j,:)=T_whole.nodes(target(j)).position;
                    progress(j)=k;
                    break
                end
            end
        end
        %目标点位置矫正
        for j=1:length(agent)
            if target(j)==1
                target_pos(j,:)=tp1(j,:);
            elseif target(j)==2
                target_pos(j,:)=tp2(j,:);
            elseif target(j)==3
                target_pos(j,:)=tp3(j,:);
            elseif target(j)==4
                target_pos(j,:)=tp4(j,:);
            elseif target(j)==5
                target_pos(j,:)=tp5(j,:);
            end
        end
        %检验个体任务完成
        for j=1:length(target)
            if target(j)~=0 && (agent(j).p(1)-target_pos(j,1))^2+(agent(j).p(2)-target_pos(j,2))^2<=r^2
                target(j)=0;
                finish(progress(j),j)=1;
            end
        end
        %检查全局任务完成程度
        if length(find(finish(state,:)==1))>=length(find(best_agents0(state,:)==1))%任务完成
            for j=1:length(progress)
                if best_agents0(state,j)==1
                    progress(j)=state+1;
                end
            end
            state=state+1;
        end
        if state>section(1)
            flag=-length(B0.S)-1;%进入后缀
        else
            flag=0;
        end
        %检查有效性
        fea=zeros([1,length(agent)]);
        for i=1:length(agent)
            if agent(i).category==0
                fea(i)=1;
            end
        end
        moveing=1;%检验结束，置位驱动标志位moveing=1
        %debug区域
        state
    end
    if moveing==1
        tic
        %% 更新位置(所有机器人向目标终点移动一个步长)
        %计算下一个点
        target_pos;
        next_point=get_next_point(real_map,agent,target_pos,r);
        move_finish=zeros([1,15]);
        %模拟
        while toc<0.5
        end
        moveing=0;
        cutnum=5;
        step=[];
        for i=1:length(agent)
            step=[step;next_point(i,:)-agent(i).p(1:2)];
        end
        for tt=1:cutnum
            n_a=[];
            for i=1:length(agent)
                agent(i).p(1:2)=next_point(i,:)-step(i,:)*(cutnum-tt)/cutnum;
                n_a=[n_a;agent(i).p(1:2)];
            end
            %% 绘制agent位置
            delete(h1);
            if t>1||tt>1
                delete(h2);
                delete(h3);
                delete(h4);
            end
            tic
            while toc<0.02
            end
            for j=1:length(agent)
                if agent(j).category==0
                    h1(j)=scatter(agent(j).p(1),agent(j).p(2),10,'MarkerEdgeColor','k','MarkerFaceColor','k');
                else
                    h1(j)=scatter(agent(j).p(1),agent(j).p(2),10,'MarkerEdgeColor','k','MarkerFaceColor',color(agent(j).category,:));
                end
            end
            h2=text(1,33,['State: ',num2str(state)]);
            h3=text(15,33,['Change: ',reactivetext]);
            h4=text(8,33,['Step: ',num2str(t)]);
            if ~strcmp(reactivetext,'None')
                reactivetext='None';
            end
            drawnow;
        end
    end
end
%best_stateT0%查看最终任务
%single_agent%查看最终任务分配
t
reactive=zeros([1,5]);
stop=0;
operation=0;




% --- Executes on button press in get_stop.
function get_stop_Callback(hObject, eventdata, handles)
% hObject    handle to get_stop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global stop;
global operation;
if operation==1
    operation=0;
    stop=1;
end


% --- Executes on button press in get_cla.
function get_cla_Callback(hObject, eventdata, handles)
% hObject    handle to get_cla (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%清除画板
global reactive;
global stop;
axes(handles.axes1);
cla;
stop=0;
reactive=[0,0,0,0,0];
%{
%重置里程计
for i=1:length(reset)
    resetmsg = rosmessage(rostype.std_msgs_Empty);
    send(reset(i),resetmsg);
end
%}


% --- Executes on button press in get_interrupt1.
function get_interrupt1_Callback(hObject, eventdata, handles)
% hObject    handle to get_interrupt1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global reactive;
if reactive(1)==0
    reactive(1)=1;
end

% --- Executes on button press in get_interrupt2.
function get_interrupt2_Callback(hObject, eventdata, handles)
% hObject    handle to get_interrupt2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global reactive;
if reactive(2)==0
    reactive(2)=1;
end

% --- Executes on button press in get_interrupt3.
function get_interrupt3_Callback(hObject, eventdata, handles)
% hObject    handle to get_interrupt3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global reactive;
if reactive(3)==0
    reactive(3)=1;
end


% --- Executes on button press in get_env.
function get_env_Callback(hObject, eventdata, handles)
% hObject    handle to get_env (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global reactive;
if reactive(4)==0
    reactive(4)=1;
end