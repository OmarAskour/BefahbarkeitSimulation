function varargout = DIN_Pruefung(varargin)
% DIN_PRUEFUNG MATLAB code for DIN_Pruefung.fig
%      DIN_PRUEFUNG, by itself, creates a new DIN_PRUEFUNG or raises the existing
%      singleton*.
%
%      H = DIN_PRUEFUNG returns the handle to a new DIN_PRUEFUNG or the handle to
%      the existing singleton*.
%
%      DIN_PRUEFUNG('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DIN_PRUEFUNG.M with the given input arguments.
%
%      DIN_PRUEFUNG('Property','Value',...) creates a new DIN_PRUEFUNG or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before DIN_Pruefung_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to DIN_Pruefung_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help DIN_Pruefung

% Last Modified by GUIDE v2.5 08-Oct-2017 17:42:40

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @DIN_Pruefung_OpeningFcn, ...
                   'gui_OutputFcn',  @DIN_Pruefung_OutputFcn, ...
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


% --- Executes just before DIN_Pruefung is made visible.
function DIN_Pruefung_OpeningFcn(hObject, eventdata, handles, varargin)

handles.output = hObject;

handles.valid_value_strings = {
    'Die Treppenbreite entspricht der DIN (>=84cm)', 'Die Steigungshoehe entspricht der DIN (14 - 20cm)';
    'Die Auftrittsbreite entspricht der DIN (23 - 27cm)', 'Das Schrittmasse entspricht der DIN (59 - 65cm)';
    'Die Kopfferheit entspricht der DIN (>=200cm)', 'Diese Treppe ist eine Haupttreppe nach DIN'};

handles.invalid_value_strings = {
    'Die Treppenbreite entspricht nicht der DIN (>=84cm)', 'Die Steigungshoehe entspricht nicht der DIN (14 - 20cm)';
    'Die Auftrittsbreite entspricht nicht der DIN (23 - 27cm)', 'Das Schrittmasse entspricht nicht der DIN (59 - 65cm)';
    'Die Kopfferheit entspricht nicht der DIN (>=200cm)', 'Diese Treppe ist nicht eine Haupttreppe nach DIN'};

geschosshohe = getappdata(0, 'geschosshoehe');
treppenbreite = getappdata(0, 'treppenbreite');
lichte_Raumhoehe = getappdata(0, 'lichte_Raumhoehe');
Gesamt_ver_Stufen = getappdata(0, 'Gesamt_ver_Stufen');
Stufen_laufradius = getappdata(0, 'Stufen_laufradius');

main_label_red = false;

set(handles.breite_edit, 'String', num2str(treppenbreite));
if treppenbreite < 84 
    set(handles.breite_signal_label,'BackgroundColor', [0.9, 0.1, 0.1]);
    set(handles.breite_signal_label,'String', handles.invalid_value_strings{1,1});
    main_label_red = true;
else
    set(handles.breite_signal_label,'String', handles.valid_value_strings{1,1});
end

%calculation
steigungen =geschosshohe / 18.0;
stufen_anzahl = round(steigungen-1);
steigungshohe = geschosshohe /steigungen;

set(handles.steigunghohe_edit, 'String', num2str(steigungshohe));
if ~(steigungshohe >= 14.0 && steigungshohe <= 20.0)
    set(handles.steighohe_signal_label,'BackgroundColor', [0.9, 0.1, 0.1]);
    set(handles.steighohe_signal_label,'String', handles.invalid_value_strings{1,2});
    main_label_red = true;
else
    set(handles.steighohe_signal_label,'String', handles.valid_value_strings{1,2});
end

%calculation
auftrittsbreite =62 - 2 * steigungshohe;
set(handles.auftritt_edit, 'String', num2str(auftrittsbreite));
if ~(auftrittsbreite >= 23.0 && auftrittsbreite <= 37.0) 
    set(handles.auftritts_signal_label,'BackgroundColor', [0.9, 0.1, 0.1]);
    set(handles.auftritts_signal_label,'String', handles.invalid_value_strings{2,1});
    main_label_red = true;
else
    set(handles.auftritts_signal_label,'String', handles.valid_value_strings{2,1});
end

%calculation
schrittmass = 2 * steigungshohe + auftrittsbreite;
set(handles.schritmass_edit, 'String', num2str(schrittmass));
if ~(schrittmass >= 59.0 && schrittmass <= 65.0)
    set(handles.schritt_signal_label,'BackgroundColor', [0.9, 0.1, 0.1]);
    set(handles.schritt_signal_label,'String', handles.invalid_value_strings{2,2});
    main_label_red = true;
else
    set(handles.schritt_signal_label,'String', handles.valid_value_strings{2,2});
end

%calculation
set(handles.steig_edit, 'String', num2str(stufen_anzahl));
laufline = stufen_anzahl * auftrittsbreite;
set(handles.laufline_edit, 'String', num2str(laufline));
%steig_d_treppe = geschosshohe / laufline;
%set(handles.steigdt_edit, 'String', num2str(steig_d_treppe));   



if main_label_red
    set(handles.haupt_signal_label,'BackgroundColor', [0.9, 0.1, 0.1]);
    set(handles.haupt_signal_label,'String', handles.invalid_value_strings{3,2});
    set(handles.Weiter_Taste, 'Enable', 'off');
else
    set(handles.haupt_signal_label,'String', handles.valid_value_strings{3,2});
end

setappdata(0, 'stufen_anzahl', stufen_anzahl);
setappdata(0, 'auftrittsbreite', auftrittsbreite);
setappdata(0, 'steigungshohe', steigungshohe);


% Update handles structure
guidata(hObject, handles);

% UIWAIT makes DIN_Pruefung wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = DIN_Pruefung_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function breite_edit_Callback(hObject, eventdata, handles)
% hObject    handle to breite_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of breite_edit as text
%        str2double(get(hObject,'String')) returns contents of breite_edit as a double


% --- Executes during object creation, after setting all properties.
function breite_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to breite_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function steigunghohe_edit_Callback(hObject, eventdata, handles)
% hObject    handle to steigunghohe_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of steigunghohe_edit as text
%        str2double(get(hObject,'String')) returns contents of steigunghohe_edit as a double


% --- Executes during object creation, after setting all properties.
function steigunghohe_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to steigunghohe_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function auftritt_edit_Callback(hObject, eventdata, handles)
% hObject    handle to auftritt_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of auftritt_edit as text
%        str2double(get(hObject,'String')) returns contents of auftritt_edit as a double


% --- Executes during object creation, after setting all properties.
function auftritt_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to auftritt_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function schritmass_edit_Callback(hObject, eventdata, handles)
% hObject    handle to schritmass_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of schritmass_edit as text
%        str2double(get(hObject,'String')) returns contents of schritmass_edit as a double


% --- Executes during object creation, after setting all properties.
function schritmass_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to schritmass_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function steig_edit_Callback(hObject, eventdata, handles)
% hObject    handle to steig_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of steig_edit as text
%        str2double(get(hObject,'String')) returns contents of steig_edit as a double


% --- Executes during object creation, after setting all properties.
function steig_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to steig_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function laufline_edit_Callback(hObject, eventdata, handles)
% hObject    handle to laufline_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of laufline_edit as text
%        str2double(get(hObject,'String')) returns contents of laufline_edit as a double


% --- Executes during object creation, after setting all properties.
function laufline_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to laufline_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Weiter_Taste.
function Weiter_Taste_Callback(hObject, eventdata, handles)
% hObject    handle to Weiter_Taste (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close(DIN_Pruefung);
Konfigurator;

% --- Executes on button press in Zurueck_Taste.
function Zurueck_Taste_Callback(hObject, eventdata, handles)
% hObject    handle to Zurueck_Taste (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clear;
close(DIN_Pruefung);
Input_treppen;

% --- Executes during object creation, after setting all properties.
function Zurueck_Taste_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Zurueck_Taste (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function Weiter_Taste_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Weiter_Taste (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function breite_signal_label_CreateFcn(hObject, eventdata, handles)
% hObject    handle to breite_signal_label (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function steighohe_signal_label_CreateFcn(hObject, eventdata, handles)
% hObject    handle to steighohe_signal_label (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function auftritts_signal_label_CreateFcn(hObject, eventdata, handles)
% hObject    handle to auftritts_signal_label (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function schritt_signal_label_CreateFcn(hObject, eventdata, handles)
% hObject    handle to schritt_signal_label (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function haupt_signal_label_CreateFcn(hObject, eventdata, handles)
% hObject    handle to haupt_signal_label (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
