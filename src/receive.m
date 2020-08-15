function varargout = receive(varargin)
% RECEIVE MATLAB code for receive.fig
%      RECEIVE, by itself, creates a new RECEIVE or raises the existing
%      singleton*.
%
%      H = RECEIVE returns the handle to a new RECEIVE or the handle to
%      the existing singleton*.
%
%      RECEIVE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in RECEIVE.M with the given input arguments.
%
%      RECEIVE('Property','Value',...) creates a new RECEIVE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before receive_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to receive_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help receive

% Last Modified by GUIDE v2.5 04-May-2017 11:20:44

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @receive_OpeningFcn, ...
                   'gui_OutputFcn',  @receive_OutputFcn, ...
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


% --- Executes just before receive is made visible.
function receive_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to receive (see VARARGIN)

% Choose default command line output for receive
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes receive wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = receive_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)

tcpipClient = tcpip('127.0.0.1',55000,'NetworkRole','Client')
set(tcpipClient,'InputBufferSize',512*512);
set(tcpipClient,'Timeout',512*512);
fopen(tcpipClient);
im = fread(tcpipClient,512*512,'uint8');
fclose(tcpipClient);
im=uint8(im);
im=reshape(im,512,512);
 axes(handles.axes1)
    imshow(im)
     assignin('base','im',im)

% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)

wtr=evalin('base','im');
p=zeros(512,512);
for i=1:256
    for j=1:256
        temp1 = dec2bin(wtr(i,j),8);
        temp2 = dec2bin(wtr(i,j+256),8);
        temp3 =dec2bin(p(i,j),8);
 
        temp3(1:4)=temp1(5:8);
        temp3(5:8)=temp2(5:8);
        
        p(i,j)=bin2dec(temp3);
    end
end

for i=256:512
    for j=1:256
        temp1 = dec2bin(wtr(i,j),8);
        temp2 = dec2bin(wtr(i,j+256),8);
        temp3 =dec2bin(p(i,j),8);
 
        temp3(1:4)=temp1(5:8);
        temp3(5:8)=temp2(5:8);
        
        p(i,j)=bin2dec(temp3);
    end
end
p=char(p)
set(handles.aa,'String',p)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
