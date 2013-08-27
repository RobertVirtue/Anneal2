function varargout = aggro(varargin)
% AGGRO MATLAB code for aggro.fig
%      AGGRO, by itself, creates a new AGGRO or raises the existing
%      singleton*.
%
%      +H = AGGRO returns the handle to a new AGGRO or the handle to
%      the existing singleton*.
%
%      AGGRO('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in AGGRO.M with the given input arguments.
%
%      AGGRO('Property','Value',...) creates a new AGGRO or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before aggro_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to aggro_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help aggro

% Last Modified by GUIDE v2.5 21-Aug-2013 12:37:29

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @aggro_OpeningFcn, ...
                   'gui_OutputFcn',  @aggro_OutputFcn, ...
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


% --- Executes just before aggro is made visible.
function aggro_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output = hObject;
guidata(hObject, handles);

% --- Outputs from this function are returned to the command line.
function varargout = aggro_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;


% --- Executes on selection change in idmenu.
function idmenu_Callback(hObject, eventdata, handles)
% Hints: contents = cellstr(get(hObject,'String')) returns idmenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from idmenu
global loc_ID
sel = get(hObject,'Value');
slist = get(hObject,'String');
conn = database('', 'disag', '&Mn3l!uvyv6Y', 'com.mysql.jdbc.Driver', 'jdbc:mysql://kenny-aus.cz7krcf0qk03.us-east-1.rds.amazonaws.com:3306/kennydb');  
loc_ID = fetch(conn, strcat('SELECT `LOCATION_ID` FROM `METER` WHERE `NAME` =''',slist{sel},''''));
close(conn);

% --- Executes during object creation, after setting all properties.
function idmenu_CreateFcn(hObject, eventdata, handles)
global loc_ID
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
conn = database('', 'disag', '&Mn3l!uvyv6Y', 'com.mysql.jdbc.Driver', 'jdbc:mysql://kenny-aus.cz7krcf0qk03.us-east-1.rds.amazonaws.com:3306/kennydb');  
id = fetch(conn, 'SELECT * FROM `METER`');
close(conn);
mname = id(:,4);
loc_ID = cell(1);
loc_ID(1) = id(1,5);
set(hObject,'String',mname);


% --- Executes on button press in startbutton.
function startbutton_Callback(hObject, eventdata, handles)
uicalendarv('SelectionType',1,'DestinationUI',{[hObject handles.lastbutton], 'string'})


% --- Executes on button press in lastbutton.
function lastbutton_Callback(hObject, eventdata, handles)
uicalendarv('SelectionType',1,'DestinationUI',{hObject, 'string'})


% --- Executes on button press in fetchbutton.
function fetchbutton_Callback(hObject, eventdata, handles)
global loc_ID
import java.lang.String
import java.util.* java.awt.*
import java.util.Enumeration

dvStart = datevec(get(handles.startbutton,'String'));
dvStop = datevec(get(handles.lastbutton,'String'));
conn = database('', 'disag', '&Mn3l!uvyv6Y', 'com.mysql.jdbc.Driver', 'jdbc:mysql://kenny-aus.cz7krcf0qk03.us-east-1.rds.amazonaws.com:3306/kennydb'); 
tzonestr = fetch(conn, strcat('SELECT `TIMEZONE` FROM `LOCATION` WHERE `ID` = ', num2str(loc_ID{1}) ));

SensorZone = GregorianCalendar(TimeZone.getTimeZone(tzonestr));
% January is 0 - subtract one from datevec month
SensorZone.set(dvStart(1), dvStart(2)-1, dvStart(3), dvStart(4), dvStart(5), dvStart(6));
%datenum is from Jan 0, 0000. Add one to day.
startTimeNum = datenum([1970 0 1 0 0 (SensorZone.getTimeInMillis() / 1000) ]);
startDB_Str = datestr(startTimeNum,31)

SensorZone.set(dvStop(1), dvStop(2)-1, dvStop(3), dvStop(4), dvStop(5), dvStop(6));
% We want the end of day for stop date. Add 2.
stopTimeNum = datenum([1970 0 2 0 0 (SensorZone.getTimeInMillis() / 1000) ]);
stopStamp = datestr(stopTimeNum,31)

assignin('base','dateoff', datenum(dvStart) - startTimeNum);
assignin('base','startdate',startDB_Str);
assignin('base','stopdate',stopStamp);

SensorHistory = fetch(conn, strcat('SELECT * FROM  `SENSORHISTORY` WHERE  `METER_ID` =  ', num2str(loc_ID{1}) ));
qp1 =  strcat('SELECT * FROM  `SENSORRAWDATA` WHERE  `GATEWAYID` =''', SensorHistory(1,7) ,''' AND  `SENSOREUI` = ''', SensorHistory(1,5));
query = strcat(qp1, ''' AND  `TIMESTAMP` > UNIX_TIMESTAMP(''', startDB_Str ,''') AND  `TIMESTAMP` < UNIX_TIMESTAMP(''', stopStamp ,''')');
RawData = fetch(conn, query{1});
close(conn)
if isempty(RawData)
    disp('No data in specified range, aborting')
    return
end
clear EA_Zone SensorHistory SensorZone qp1 query

%
% Order timestamps
% time:[RawData{:,7}]' power:[RawData{:,5}]' energy:[RawData{:,2}]'
sorted = sortrows([ [RawData{:,7}]' [RawData{:,5}]' [RawData{:,2}]' ]);
clear RawData rP rT rE;

%
% Nuke repeated timestamps {sorted(:,1)}
mLen = length(sorted(:,1));
notRepeated = true(mLen, 1);
for i = 1:mLen - 1
    % Check for duplicate timestamps, keep the first
    if sorted(i+1,1) - sorted(i,1) < 1 
        notRepeated(i+1) = false;
        % Check that E is also a repeat
        if  sorted(i+1,3) - sorted(i,3) > 0
            display('Two energy values, one timestamp')
            display([sorted(i,:) sorted(i+1,:)])
        end
    end
    if sorted(i,2) == 0 || sorted(i,3) == 0
        notRepeated(i) = false;
    end
end
cleanSort = sorted(notRepeated,:);
clear sorted notRepeated;

assignin('base','times', cleanSort(:,1));
assignin('base','power', cleanSort(:,2));
assignin('base','energy',cleanSort(:,3));
clear cleansort;
figure(1)
plot(cleanSort(:,1),cleanSort(:,2),'-b.');
display('ok')

% --- Executes on button press in forestButton.
function forestButton_Callback(hObject, eventdata, handles)
% hObject    handle to forestButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
forest


% --- Executes on button press in firstLessDay.
function firstLessDay_Callback(hObject, eventdata, handles)
% hObject    handle to firstLessDay (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
oldDate = datenum(get(handles.startbutton,'String'));
newDate = addtodate(oldDate, -1, 'Day');
set(handles.startbutton, 'String', datestr(newDate));


% --- Executes on button press in firstPlusDay.
function firstPlusDay_Callback(hObject, eventdata, handles)
% hObject    handle to firstPlusDay (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
oldDate = datenum(get(handles.startbutton,'String'));
newDate = addtodate(oldDate, 1, 'Day');
set(handles.startbutton, 'String', datestr(newDate));
if (oldDate == datenum(get(handles.lastbutton, 'String')))
    set(handles.lastbutton, 'String', datestr(newDate));
end



% --- Executes on button press in lastLessDay.
function lastLessDay_Callback(hObject, eventdata, handles)
% hObject    handle to lastLessDay (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
oldDate = datenum(get(handles.lastbutton,'String'));
newDate = addtodate(oldDate, -1, 'Day');
set(handles.lastbutton, 'String', datestr(newDate));
if (oldDate == datenum(get(handles.startbutton, 'String')))
    set(handles.startbutton, 'String', datestr(newDate));
end


% --- Executes on button press in lastPlusDay.
function lastPlusDay_Callback(hObject, eventdata, handles)
% hObject    handle to lastPlusDay (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
oldDate = datenum(get(handles.lastbutton,'String'));
newDate = addtodate(oldDate, 1, 'Day');
set(handles.lastbutton, 'String', datestr(newDate));
