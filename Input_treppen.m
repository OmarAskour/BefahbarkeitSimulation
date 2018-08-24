function varargout = Input_treppen(varargin)
% INPUT_TREPPEN MATLAB code for Input_treppen.fig
%      INPUT_TREPPEN, by itself, creates a new INPUT_TREPPEN or raises the existing
%      singleton*.
%
%ls the local
%      H = INPUT_TREPPEN returns the handle to a new INPUT_TREPPEN or the handle to
%      the existing singleton*.
%      function named CALLBACK in INPUT_TREPPEN.M with the given input arguments.
%
%      INPUT_TREPPEN('CALLBACK',hObject,eventData,handles,...) cal
%      INPUT_TREPPEN('Property','Value',...) creates a new INPUT_TREPPEN or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Input_treppen_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Input_treppen_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Input_treppen

% Last Modified by GUIDE v2.5 08-Oct-2017 16:44:04

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Input_treppen_OpeningFcn, ...
                   'gui_OutputFcn',  @Input_treppen_OutputFcn, ...
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


% --- Executes just before Input_treppen is made visible.
function Input_treppen_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Input_treppen (see VARARGIN)

% Choose default command line output for Input_treppen
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
guidata(hObject, handles);
myimage = imread('viertel rechts gewendelten Treppe.PNG');
axes(handles.axes1);
imshow(myimage);
% UIWAIT makes Input_treppen wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Input_treppen_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in Bestaetigen_Taste.
function Bestaetigen_Taste_Callback(hObject, eventdata, handles)
% hObject    handle to Bestaetigen_Taste (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

geschosshoehe = get(handles.geschoss_edit,'String');
treppenbreite = get(handles.breite_edit,'String');
lichte_Raumhoehe = get(handles.lichte_edit,'String');
Gesamt_ver_Stufen = get(handles.stufen_edit,'String');
Stufen_laufradius = get(handles.laufradius_edit,'String');

if (isempty(geschosshoehe) || isempty(treppenbreite) || isempty(lichte_Raumhoehe) || ...
    isempty(Gesamt_ver_Stufen) || isempty(Stufen_laufradius))

    msgbox('One of the values not provided. Please enter all the data!!!','Error');

else
    
    setappdata(0, 'geschosshoehe', str2double(geschosshoehe));
    setappdata(0, 'treppenbreite', str2double(treppenbreite));
    setappdata(0, 'lichte_Raumhoehe', str2double(lichte_Raumhoehe));
    setappdata(0, 'Gesamt_ver_Stufen', str2double(Gesamt_ver_Stufen));
    setappdata(0, 'Stufen_laufradius', str2double(Stufen_laufradius));
    %clear;
    %close(Input_treppen);
    DIN_Pruefung;
end




function geschoss_edit_Callback(hObject, eventdata, handles)
% hObject    handle to geschoss_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of geschoss_edit as text
%        str2double(get(hObject,'String')) returns contents of geschoss_edit as a double


% --- Executes during object creation, after setting all properties.
function geschoss_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to geschoss_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in treppen_form_listbox.
function treppen_form_listbox_Callback(hObject, eventdata, handles)

index_selected = get(hObject,'Value');
disp(index_selected)
list = get(hObject,'String');
img = list{index_selected};
img_name = [img '.PNG'];
treppe_image = imread(img_name);
imshow(treppe_image);

handlesArray = [handles.geschoss_edit, handles.lichte_edit, handles.breite_edit, ...
    handles.stufen_edit, handles.laufradius_edit, handles.Bestaetigen_Taste, ...
    handles.geschoss_label, handles.breite_label, handles. lichte_label, ...
    handles.stufen_label, handles.laufraduis_label];
if index_selected == 1 || index_selected == 3
    % Get all the handles to everything we want to set in a single array.
    set(handlesArray, 'Visible', 'on');
else
    set(handlesArray, 'Visible', 'off');
end



% --- Executes during object creation, after setting all properties.
function treppen_form_listbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to treppen_form_listbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



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



function lichte_edit_Callback(hObject, eventdata, handles)
% hObject    handle to lichte_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of lichte_edit as text
%        str2double(get(hObject,'String')) returns contents of lichte_edit as a double


% --- Executes during object creation, after setting all properties.
function lichte_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lichte_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function stufen_edit_Callback(hObject, eventdata, handles)
% hObject    handle to stufen_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of stufen_edit as text
%        str2double(get(hObject,'String')) returns contents of stufen_edit as a double


% --- Executes during object creation, after setting all properties.
function stufen_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to stufen_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function laufradius_edit_Callback(hObject, eventdata, handles)
% hObject    handle to laufradius_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of laufradius_edit as text
%        str2double(get(hObject,'String')) returns contents of laufradius_edit as a double


% --- Executes during object creation, after setting all properties.
function laufradius_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to laufradius_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function Bestaetigen_Taste_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Bestaetigen_Taste (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
