function varargout = receive(varargin)

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

function receive_OpeningFcn(hObject, eventdata, handles, varargin)

handles.output = hObject;


guidata(hObject, handles);





function varargout = receive_OutputFcn(hObject, eventdata, handles) 

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
