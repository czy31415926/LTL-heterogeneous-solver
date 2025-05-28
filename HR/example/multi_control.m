function varargout = multi_control(varargin)
% MULTI_CONTROL MATLAB code for multi_control.fig
%      MULTI_CONTROL, by itself, creates a new MULTI_CONTROL or raises the existing
%      singleton*.
%
%      H = MULTI_CONTROL returns the handle to a new MULTI_CONTROL or the handle to
%      the existing singleton*.
%
%      MULTI_CONTROL('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MULTI_CONTROL.M with the given input arguments.
%
%      MULTI_CONTROL('Property','Value',...) creates a new MULTI_CONTROL or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before multi_control_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to multi_control_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help multi_control

% Last Modified by GUIDE v2.5 10-Nov-2021 12:13:39

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @multi_control_OpeningFcn, ...
                   'gui_OutputFcn',  @multi_control_OutputFcn, ...
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


% --- Executes just before multi_control is made visible.
function multi_control_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to multi_control (see VARARGIN)

% Choose default command line output for multi_control
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes multi_control wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = multi_control_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
addpath('.\turtlebot');


% 机器人的运行速度
global leftVelocity
global rightVelocity
global forwardVelocity
global backwardVelocity
leftVelocity = 1;        % 角速度 (rad/s)
rightVelocity = -1;      % 角速度 (rad/s)
forwardVelocity = 0.2;     % 线速度 (m/s)
backwardVelocity = -0.2;   % 线速度 (m/s)


% --- Executes on button press in connect.
function connect_Callback(hObject, eventdata, handles)
% hObject    handle to connect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
rosMasterUri = 'http://192.168.3.33:11311';
setenv('ROS_MASTER_URI',rosMasterUri)
rosinit


% --- Executes on button press in shutdown.
function shutdown_Callback(hObject, eventdata, handles)
% hObject    handle to shutdown (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
rosshutdown

% --- Executes on button press in get_reset.
function get_reset_Callback(hObject, eventdata, handles)
% hObject    handle to get_reset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global reset
global N
resetmsg = rosmessage(rostype.std_msgs_Empty);
for i=1:N
    send(reset(i),resetmsg);
end

%{
tb=turtlebot('192.168.3.23');
resetOdometry(tb);
%}

% --- Executes on button press in robot1.
function robot1_Callback(hObject, eventdata, handles)
% hObject    handle to robot1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global move_now;
global odom_now;
global scan_now;
global move;
global odom;
global scan;

move_now=move(1);
odom_now=odom(1);
scan_now=scan(1);




% --- Executes on button press in robot2.
function robot2_Callback(hObject, eventdata, handles)
% hObject    handle to robot2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global move_now;
global odom_now;
global scan_now;
global move;
global odom;
global scan;

move_now=move(2);
odom_now=odom(2);
scan_now=scan(2);

% --- Executes on button press in robot3.
function robot3_Callback(hObject, eventdata, handles)
% hObject    handle to robot3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global move_now;
global odom_now;
global scan_now;
global move;
global odom;
global scan;

move_now=move(3);
odom_now=odom(3);
scan_now=scan(3);

% --- Executes on button press in robot4.
function robot4_Callback(hObject, eventdata, handles)
% hObject    handle to robot4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global move_now;
global odom_now;
global scan_now;
global move;
global odom;
global scan;

move_now=move(4);
odom_now=odom(4);
scan_now=scan(4);



% --- Executes on button press in move_f.
function move_f_Callback(hObject, eventdata, handles)
% hObject    handle to move_f (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global forwardVelocity
global move_now;
global vmsg;

vmsg.Angular.Z = 0;
vmsg.Linear.X = forwardVelocity;
send(move_now,vmsg);

% --- Executes on button press in move_left.
function move_left_Callback(hObject, eventdata, handles)
% hObject    handle to move_left (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global leftVelocity
global move_now;
global vmsg;

vmsg.Angular.Z = leftVelocity;
vmsg.Linear.X = 0;
send(move_now,vmsg);

% --- Executes on button press in move_right.
function move_right_Callback(hObject, eventdata, handles)
% hObject    handle to move_right (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global rightVelocity
global move_now;
global vmsg;

vmsg.Angular.Z = rightVelocity;
vmsg.Linear.X = 0;
send(move_now,vmsg);

% --- Executes on button press in move_back.
function move_back_Callback(hObject, eventdata, handles)
% hObject    handle to move_back (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global backwardVelocity
global move_now;
global vmsg;

vmsg.Angular.Z = 0;
vmsg.Linear.X = backwardVelocity;
send(move_now,vmsg);

% --- Executes on button press in move_stop.
function move_stop_Callback(hObject, eventdata, handles)
% hObject    handle to move_stop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global move_now;
global vmsg;

vmsg.Angular.Z = 0;
vmsg.Linear.X = 0;
send(move_now,vmsg);


% --- Executes on button press in get_position.
function get_position_Callback(hObject, eventdata, handles)
% hObject    handle to get_position (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global odom_now;
posmsg=get_state(odom_now);
set(hObject,'string',mat2str(posmsg));


% --- Executes on button press in get_scan.
function get_scan_Callback(hObject, eventdata, handles)
% hObject    handle to get_scan (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global scan_now;
lidarmsg=get_obstacle(scan_now);
axes(handles.axes1);
cla;
scatter(-lidarmsg(:,2),lidarmsg(:,1),10,'filled','b');


% --- Executes on button press in get_all_start.
function get_all_start_Callback(hObject, eventdata, handles)
% hObject    handle to get_all_start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global move;
global vmsg;
global N
global forwardVelocity

vmsg.Angular.Z = 0;
vmsg.Linear.X = forwardVelocity;
for i=1:N
    send(move(i),vmsg);
end



% --- Executes on button press in get_all_stop.
function get_all_stop_Callback(hObject, eventdata, handles)
% hObject    handle to get_all_stop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global move;
global vmsg;
global N

vmsg.Angular.Z = 0;
vmsg.Linear.X = 0;
for i=1:N
    send(move(i),vmsg);
end


% --- Executes on button press in get_init.
function get_init_Callback(hObject, eventdata, handles)
% hObject    handle to get_init (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global N;N=1;%agent数量
global topic;
topic=get_topic(N);%获得通讯节点
global move;move=[];
global odom;odom=[];
global scan;scan=[];
global reset;reset=[];
%获得话题映射点
for i=1:N
    move=[move,rospublisher(topic(i).move,'geometry_msgs/Twist')];
    odom =[odom,rossubscriber(topic(i).pos)];
    scan=[scan,rossubscriber(topic(i).scan)];
    reset=[reset,rospublisher(topic(i).reset)];
end
global vmsg;
vmsg=rosmessage(move(1));%获得速度信息格式