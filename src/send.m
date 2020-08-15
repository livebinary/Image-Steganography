function varargout = send(varargin)

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

function send_OpeningFcn(hObject, eventdata, handles, varargin)

handles.output = hObject;


guidata(hObject, handles);


function varargout = send_OutputFcn(hObject, eventdata, handles) 

varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)

an = get(handles.a,'string')
an=double(an)
assignin('base','an',an)





% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
global im2;


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






function a_Callback(hObject, eventdata, handles)

function a_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
