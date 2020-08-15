function varargout = send(varargin)
% SEND MATLAB code for send.fig
%      SEND, by itself, creates a new SEND or raises the existing
%      singleton*.
%
%      H = SEND returns the handle to a new SEND or the handle to
%      the existing singleton*.
%
%      SEND('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SEND.M with the given input arguments.
%
%      SEND('Property','Value',...) creates a new SEND or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before send_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to send_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help send

% Last Modified by GUIDE v2.5 04-May-2017 11:18:58

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @send_OpeningFcn, ...
                   'gui_OutputFcn',  @send_OutputFcn, ...
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


% --- Executes just before send is made visible.
function send_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to send (see VARARGIN)

% Choose default command line output for send
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes send wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = send_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)

an = get(handles.a,'string')
an=double(an)
assignin('base','an',an)


% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
global im2;
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[f p fi]=uigetfile({'*bmp'},'Select the image');
if isequal(f,0) || isequal(p,0)
   ;
else
   im2=imread([p f]);
    if size(im2,3)==3
        im2=rgb2gray(im2);
    else
        im2=im2;
    end
    im2= imresize(im2,[512,512]);
    axes(handles.axes2)
    imshow(im2)
    %Iim=double(Iim);
   assignin('base','im2',im2)
end

% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
an=evalin('base','an');
im2=evalin('base','im2');
wtr=zeros(512,512);
for i=1:512
    for j=1:512
        wtr(i,j)=im2(i,j);
    end
end
[r c]=size(an);

p=zeros(1,512*512);
for i=1:512*512
   if(i<=c)
    p(i)=an(i);
   else
       p(i)=32;
   end
   
end
p=reshape(p,512,512);   
p=p';        
for i=1:256
    for j=1:256
        temp1 = dec2bin(p(i,j),8);
        temp2 =dec2bin(wtr(i,j),8);
        temp3 = dec2bin(wtr(i,j+256),8);
        temp2(5:8)=temp1(1:4);
        temp3(5:8)=temp1(5:8);
        
        wtr(i,j)=bin2dec(temp2);
        wtr(i,j+256)=bin2dec(temp3);
    end
end

for i=256:512
    for j=1:256
        temp1 = dec2bin(p(i,j),8);
        temp2 =dec2bin(wtr(i,j),8);
        temp3 = dec2bin(wtr(i,j+256),8);
        temp2(5:8)=temp1(1:4);
        temp3(5:8)=temp1(5:8);
        
        wtr(i,j)=bin2dec(temp2);
        wtr(i,j+256)=bin2dec(temp3);
    end
end

    
%wtr=bitset(wtr,2,bitget(p,8));
%wtr=bitset(wtr,1,bitget(p,7));


wtr = uint8(wtr);
 axes(handles.axes3)
    imshow(wtr)
    %Iim=double(Iim);
   assignin('base','wtr',wtr)

% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
wtr=evalin('base','wtr');


s = whos('wtr')
tcpipServer = tcpip('0.0.0.0',55000,'NetworkRole','Server');
set(tcpipServer,'OutputBufferSize',s.bytes);
fopen(tcpipServer);
fwrite(tcpipServer,wtr(:),'uint8');
fclose(tcpipServer); 


% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function a_Callback(hObject, eventdata, handles)
% hObject    handle to a (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of a as text
%        str2double(get(hObject,'String')) returns contents of a as a double


% --- Executes during object creation, after setting all properties.
function a_CreateFcn(hObject, eventdata, handles)
% hObject    handle to a (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
