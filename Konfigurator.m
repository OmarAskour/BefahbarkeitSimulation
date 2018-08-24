function varargout = Konfigurator(varargin)
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Konfigurator_OpeningFcn, ...
                   'gui_OutputFcn',  @Konfigurator_OutputFcn, ...
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

function Konfigurator_OpeningFcn(hObject, eventdata, handles, varargin)

handles.output = hObject;
%----------------------------INPUT DATA �BRERTRAGEN------------------------
Gesamt_ver_Stufen = getappdata(0, 'Gesamt_ver_Stufen'); %n-verz
Stufen_laufradius = getappdata(0, 'Stufen_laufradius'); %n-rad
stufen_anzahl = getappdata(0, 'stufen_anzahl');
auftrittsbreite = getappdata(0, 'auftrittsbreite');
treppenbreite = getappdata(0, 'treppenbreite');
%--------------------BERECHNUNG DIE ABST�NDE F�R DIE TREPPEN RAHMAN--------
L_nicht_verzogen = (stufen_anzahl - Gesamt_ver_Stufen) * auftrittsbreite;
Lange_raduis = auftrittsbreite * 0.5 / sin(deg2rad(45/Stufen_laufradius));
Lange_verzogen = (Gesamt_ver_Stufen - Stufen_laufradius) / 2 * auftrittsbreite;
lichte = treppenbreite / 2;
%--------------------BERECHNUNGSWERTE IN GUI SETZEN------------------------
set(handles.Laenge_nicht_ver_edit,'String',L_nicht_verzogen);
set(handles.Laenge_radius_L_edit,'String', Lange_raduis);
set(handles.Laenge_Ver_L_edit,'String',Lange_verzogen);
set(handles.Halbe_lichte_edit,'String', lichte);

%-------------------- AUSBLENDEN-------------------------------
set(handles.uipanel3,'visible','off');
set(handles.uipanel7,'visible','off');
set(handles.uipanel5,'visible','off');
set(handles.initial_position,'visible','off');
set(handles.Vorwaerts,'visible','off');
set(handles.Rueckwaerts,'visible','off');

set(gca,'XTickLabel',[]) 
set(gca,'YTickLabel',[])
axes(handles.axes1);
guidata(hObject, handles);


%---------STUFEN VERZIEHUNG & LAUFLINIEN EINSTELLUNG EINBLENDEN------------
function Neues_Modell_Callback(hObject, eventdata, handles)
set(handles.uipanel3,'visible','on');


%---------KONFIGURATOR VERLASSEN-------------------------------------------
function pushbutton_Zurueck_Callback(hObject, eventdata, handles)
clear;
close(Konfigurator);
DIN_Pruefung;

%---------Treppe Plotten -------------------------------------------
function pushbutton_bestaetigen_Callback(hObject, eventdata, handles)

set(handles.uipanel5,'visible','on');

tbl = datenbank.fetchData(); 
if height(tbl) > 0
    imgPath = string(tbl{1,4});
    set_figure(char(imgPath), handles);
end

Gesamt_ver_Stufen = getappdata(0, 'Gesamt_ver_Stufen'); % Anzahl der gesamten verzogenen Stufen
Stufen_laufradius = getappdata(0, 'Stufen_laufradius'); %Anzahl der  verzogenen Stufen im laufradius
stufen_anzahl = getappdata(0, 'stufen_anzahl');
auftrittsbreite = getappdata(0, 'auftrittsbreite');
treppenbreite = getappdata(0, 'treppenbreite');

nicht_verzogen = (stufen_anzahl -Gesamt_ver_Stufen) * auftrittsbreite; %Laufl�nge nicht verzogen 
lange_raduis = auftrittsbreite * 0.5 / sin(deg2rad( 0.5 * 90 / Stufen_laufradius));%Laufl�nge Radius Lauflinienradius 
lange_verzogen = (Gesamt_ver_Stufen - Stufen_laufradius) / 2 * auftrittsbreite; %L�nge verzogene Stufen ohne Lauflinienradius
lichte = treppenbreite / 2;% halbe lichte Stufenbreite

x=[100;100; lichte+lange_verzogen+lange_raduis+nicht_verzogen+100;  lichte+lange_verzogen+lange_raduis+nicht_verzogen+100;  treppenbreite+100;  treppenbreite+100; 100 ];
y=[100; lichte+lange_verzogen+lange_raduis+100; lichte+lange_verzogen+lange_raduis+100;  lichte+lange_verzogen+lange_raduis+100-treppenbreite;  lichte+lange_verzogen+lange_raduis+100-treppenbreite; 100; 100 ];
 
achse_x=lichte+lange_verzogen+lange_raduis+nicht_verzogen+150;
achse_y=lichte+lange_verzogen+lange_raduis+nicht_verzogen+50;


scatter(x,y,'.r');
title('2D Treppen Modul Darstellung'); %Ein Titel w12ird eingef�gt
xlabel('x-Kurze Seite in cm'); %Die x-Achse wird bezeichnet
ylabel('y-Lange Seite in cm'); %Die y-Achse wird bezeichnet
grid off %Ein Gitternetz wird angezeigt
axis([0 achse_x 0 achse_y]); % 
hold on;

for i=1:6    
    plot([x(i) x(i+1)],[y(i) y(i+1)],'-b');   
end 
legend('Ecken','Grenzen');
hold off;

Nzahl_stufen_NV = floor(nicht_verzogen/auftrittsbreite); % Anzal der stufen in der Laufl�nge nicht verzogen 
hold on
for i=1:Nzahl_stufen_NV
x1=[lichte+lange_verzogen+lange_raduis+nicht_verzogen+100-i*auftrittsbreite; lichte+lange_verzogen+lange_raduis+nicht_verzogen+100-i*auftrittsbreite ];
y1=[lichte+lange_verzogen+lange_raduis+100;lichte+lange_verzogen+lange_raduis+100-treppenbreite];   
plot([x1(1) x1(2)],[y1(1) y1(2)],'-b');
end
legend('off'),
% Nach
hold off



%---------BILD LADEN ------------------------------------------------------------
function set_figure(path, handles)
treppenImage = imread(path);
axes(handles.axes2);
imshow(treppenImage);
axes(handles.axes1);

%---------GESPEICHERTE MODELL LADEN ---------------------------------------
function Load_modell_Callback(hObject, eventdata, handles)
set(handles.uipanel3,'visible','on');
row = datenbank.getCurrentRow();
set_table_data_and_figure(row, handles, false);

%---------GESPEICHERTE WERTE AUF DIE TABELLEN LADEN -----------------------
function set_table_data_and_figure(tbl, handles, do_set_figure)
%------- Lauflinien data �bertragen
x = str2num(cell2mat(tbl{1,2})); 
y = str2num(cell2mat(tbl{1,3}));
data = []
for i=1:length(x)
    data = [data; x(i) y(i)];
set(handles.uitable4,'data',data);
end
%------- kurze data �bertragen
sn = str2num(cell2mat(tbl{1,5})); 
innen = str2num(cell2mat(tbl{1,6}));
aussen = str2num(cell2mat(tbl{1,7}));
data = []
for i=1:length(sn)
    data = [data; sn(i) innen(i) aussen(i)];
set(handles.uitable9,'data',data);
end
%------- lange seite data �bertragen
sn = str2num(cell2mat(tbl{1,8})); 
innen = str2num(cell2mat(tbl{1,9}));
aussen = str2num(cell2mat(tbl{1,10}));
data = []
for i=1:length(sn)
    data = [data; sn(i) innen(i) aussen(i)];
set(handles.uitable10,'data',data);
end
%-------bild �bertragen
if do_set_figure
    imgPath = string(tbl{1,4});
    set_figure(char(imgPath), handles);
end

%---------GESPEICHERTE MODELL L�SCHEN -------------------------------------
function Modell_Loeschen_Callback(hObject, eventdata, handles)
datenbank.deleteCurrentModel()
tbl = datenbank.fetchData();
cla(handles.axes2);
if height(tbl) > 0
    row = datenbank.getCurrentRow();
    set_table_data_and_figure(row, handles, false);
end


%--------- LETZTE GESPEICHERTE MODELL ZEIGEN -----------------------------
function pre_modell_Callback(hObject, eventdata, handles)
% hObject    handle to pre_modell (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
row = datenbank.getPrevRow();
imgPath = string(row{1,4});
set_figure(char(imgPath),handles);

%--------- NaeCHSTE GESPEICHERTE MODELL ZEIGEN -----------------------------
function Next_Modell_Callback(hObject, eventdata, handles)
% hObject    handle to Next_Modell (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
row = datenbank.getNextRow();
imgPath = string(row{1,4});
set_figure(char(imgPath),handles);


%--------- AKTUELLE MODELL SPEICHERN --------------------------------------
function Speichern_Callback(hObject, eventdata, handles)
set(handles.axes1,'visible','off');

imageData = screencapture(handles.axes1);
model_id = num2str(posixtime(datetime('now')));
id = datenbank.getLastSavedId() + 1;
path = strcat('images/', num2str(id), '.png');
imwrite(imageData, path);

%-----------------------Speichern Data aus Tabelle Lauflinie
tableData = get(handles.uitable4, 'data');
data1 = tableData(:,1)
data2 = tableData(:,2)
x_achses = "";
y_achses = "";
for i=1:length(data1)
    if i == length(data1)
        try
        x_achses = strcat(x_achses, num2str(data1(i)));
        y_achses = strcat(y_achses, num2str(data2(i)));
        catch ME
        x_achses = strcat(x_achses, num2str(cell2mat(data1(i))));
        y_achses = strcat(y_achses, num2str(cell2mat(data2(i))));
        end
    else
        try
        x_achses = strcat(x_achses, num2str(data1(i)), " ");
        y_achses = strcat(y_achses, num2str(data2(i)), " ");
        catch ME
        x_achses = strcat(x_achses, num2str(cell2mat(data1(i))), " ");
        y_achses = strcat(y_achses, num2str(cell2mat(data2(i))), " ");
        end
    end
end
%-----------------------Speichern Data aus Tabelle Kurze seite
tableData = get(handles.uitable9, 'data');
data1 = tableData(:,1)
data2 = tableData(:,2)
data3 = tableData(:,3)
kurze_sn = ""; kurze_innen = ""; kurze_aussen = "";
for i=1:length(data1)
    if i == length(data1)
        try
        kurze_sn = strcat(kurze_sn, num2str(data1(i)));
        kurze_innen = strcat(kurze_innen, num2str(data2(i)));
        kurze_aussen = strcat(kurze_aussen, num2str(data3(i)));
        catch ME
        kurze_sn = strcat(kurze_sn, num2str(cell2mat(data1(i))));
        kurze_innen = strcat(kurze_innen, num2str(cell2mat(data2(i))));
        kurze_aussen = strcat(kurze_aussen, num2str(cell2mat(data3(i))));
        end
    else
        try
        kurze_sn = strcat(kurze_sn, num2str(data1(i)), " ");
        kurze_innen = strcat(kurze_innen, num2str(data2(i)), " ");
        kurze_aussen = strcat(kurze_aussen, num2str(data3(i)), " ");
        catch ME
        kurze_sn = strcat(kurze_sn, num2str(cell2mat(data1(i))), " ");
        kurze_innen = strcat(kurze_innen, num2str(cell2mat(data2(i))), " ");
        kurze_aussen = strcat(kurze_aussen, num2str(cell2mat(data3(i))), " ");
        end
    end
end

%-----------------------Speichern Data aus Tabelle lange seite
tableData = get(handles.uitable10, 'data');
data1 = tableData(:,1)
data2 = tableData(:,2)
data3 = tableData(:,3)
lange_sn = ""; lange_innen = ""; lange_aussen = "";
for i=1:length(data1)
    if i == length(data1)
        try
        lange_sn = strcat(lange_sn, num2str(data1(i)));
        lange_innen = strcat(lange_innen, num2str(data2(i)));
        lange_aussen = strcat(lange_aussen, num2str(data3(i)));
        catch ME
        lange_sn = strcat(lange_sn, num2str(cell2mat(data1(i))));
        lange_innen = strcat(lange_innen, num2str(cell2mat(data2(i))));
        lange_aussen = strcat(lange_aussen, num2str(cell2mat(data3(i))));
        end
    else
        try
        lange_sn = strcat(lange_sn, num2str(data1(i)), " ");
        lange_innen = strcat(lange_innen, num2str(data2(i)), " ");
        lange_aussen = strcat(lange_aussen, num2str(data3(i)), " ");
        catch ME
        lange_sn = strcat(lange_sn, num2str(cell2mat(data1(i))), " ");
        lange_innen = strcat(lange_innen, num2str(cell2mat(data2(i))), " ");
        lange_aussen = strcat(lange_aussen, num2str(cell2mat(data3(i))), " ");
        end
    end
end
%---------------------- ganze Data in das Datenbank legen
datenbank.addData({id, x_achses, y_achses, path, kurze_sn, kurze_innen, kurze_aussen, lange_sn, lange_innen, lange_aussen}, model_id);
tbl = datenbank.fetchData(); 
if height(tbl) == 1
    imgPath = string(tbl{1,4});
    set_figure(char(imgPath), handles);
end

%--------- AKTUELLE MODELL PLOTTEN-----------------------------------------
function Plot_Callback(hObject, eventdata, handles)
set(handles.axes1,'visible','on');
cla; % FIGURE L�SCHEN (ZUM UPDATE)

Gesamt_ver_Stufen = getappdata(0, 'Gesamt_ver_Stufen'); %n-verz
Stufen_laufradius = getappdata(0, 'Stufen_laufradius'); %n-rad
stufen_anzahl = getappdata(0, 'stufen_anzahl');
auftrittsbreite = getappdata(0, 'auftrittsbreite');
treppenbreite = getappdata(0, 'treppenbreite');

nicht_verzogen = (stufen_anzahl -Gesamt_ver_Stufen) * auftrittsbreite; %Laufl�nge nicht verzogen 
lange_raduis = auftrittsbreite * 0.5 / sin(deg2rad( 0.5 * 90 / Stufen_laufradius));%Laufl�nge Radius Lauflinienradius 
lange_verzogen = (Gesamt_ver_Stufen - Stufen_laufradius) / 2 * auftrittsbreite;
lichte = treppenbreite / 2;

kurzeseite_Laenge = lange_raduis + lange_verzogen + lichte % L�NGE DER KURZEN SEITE
Leangeseite_Laenge = lange_raduis + lange_verzogen + lichte + nicht_verzogen % L�NGE DER LANDEN SEITE
Achsen_Entf=100 % ABSTABD ZWISCHEN NULL STELLEN ACHSE XY UND TREPPE 

data1=get(handles.uitable9,'data'); % DATA IN DER TABELLE VERZUGENE STUFEN
data2=get(handles.uitable10,'data'); % DATA IN DER TABELLE VERZOGENE STUFEN


hold on
data=get(handles.uitable4,'data'); % DATA IN DER TABELLE LAUFLINIE

%------------------- LAUFLINIE PLOTTEN--------
try
    
    if ~isempty(str2num(cell2mat(data(1,1)))) % �BERPRUFUNG OB TABELLE LEER IST
        error('Handle table');
    end
catch ME    
    x=data(:,1);
    y=data(:,2);
    try
        xq1 = data(1,1):0.01:data(length(data),1);
    catch ME
        x = str2num(cell2mat(x))
        y = str2num(cell2mat(y))
        xq1 = str2double(data(1,1)):0.01:str2double(data(length(data),1));
    end
     
    p = pchip(x,y,xq1);% PLOT METHEDE PCHIP PUNKTE VERBINDUNG 
    plot(x,y,'o',xq1,p,'-');
end
legend('off'),
% Nach
hold off

%------------------- VERZOGENE STUFEN PLOTTEN--------


try
%Parameter fur kurze seite
Stufen_num1= str2num(cell2mat(data1(:,1)));
Innenabstand1= str2num(cell2mat(data1(:,2)));
Aussenabstand1= str2num(cell2mat(data1(:,3)));
% Parameter f�r lane seite
Stufen_num2= str2num(cell2mat(data2(:,1)));
Innenabstand2= str2num(cell2mat(data2(:,2)));
Aussenabstand2= str2num(cell2mat(data2(:,3)));
catch ME
 %Parameter fur kurze seite
Stufen_num1= data1(:,1);
Innenabstand1= data1(:,2);
Aussenabstand1= data1(:,3);

% Parameter f�r lange seite
Stufen_num2= data2(:,1);
Innenabstand2= data2(:,2);
Aussenabstand2= data2(:,3);
end
hold on
%--------------------Plot kuzre seite
for i=1:length(Stufen_num1)
    sum_Innenabstand1 = 0;
    sum_Aussenabstand1 = 0;
    
    for j=1:i
        
        sum_Innenabstand1 = sum_Innenabstand1 + Innenabstand1(j);
        sum_Aussenabstand1 = sum_Aussenabstand1 + Aussenabstand1(j);
        if (sum_Innenabstand1 > kurzeseite_Laenge - treppenbreite) || ( sum_Aussenabstand1 > kurzeseite_Laenge)
            set(handles.axes1,'visible','off');
            cla;
            
        else
        Px=[(Achsen_Entf/Stufen_num1(i))*i ((Achsen_Entf + treppenbreite)/Stufen_num1(i))*i];
        Py=[sum_Aussenabstand1+Achsen_Entf  sum_Innenabstand1+Achsen_Entf];
        plot([Px(1) Px(2)],[Py(1) Py(2)],'-r') 
        end  
    end 
 end

%-----------------------------Plot lang seite

for i=1:length(Stufen_num2)
    
    sum_Innenabstand2 = 0;
    sum_Aussenabstand2 = 0;
  
    for j=1:i
       
        sum_Innenabstand2 = sum_Innenabstand2 + Innenabstand2(j);
        sum_Aussenabstand2 = sum_Aussenabstand2 + Aussenabstand2(j);
        
        if (sum_Innenabstand1 > kurzeseite_Laenge - treppenbreite) || ( sum_Aussenabstand1 > kurzeseite_Laenge) || (sum_Innenabstand2<0) || (sum_Aussenabstand2<0)
           cla;
           %msgbox(sprintf('Die gesamt stufen leange muss kleiner oder gleich : %g',kurzeseite_Laenge - treppenbreite),'Error')
        else
       
       Px=[sum_Innenabstand2+Achsen_Entf+treppenbreite  sum_Aussenabstand2+Achsen_Entf]  
       Py=[((kurzeseite_Laenge+Achsen_Entf-treppenbreite )/Stufen_num2(i))*i  ((Achsen_Entf + kurzeseite_Laenge)/Stufen_num2(i))*i]
        plot([Px(1) Px(2)],[Py(1) Py(2)],'-r') 
       end
    end 
 end

pushbutton_bestaetigen_Callback(handles.pushbutton_bestaetigen, eventdata,handles);
set(handles.uipanel7,'visible','on');

%----------FAHRT ANALYSE STARTEN-------------------------------------------

function pushbutton_Fahrt_Start_Callback(hObject, eventdata, handles)

%---------- INPUT PARAMETER
Plattform_breite = get(handles.H_Breite,'String');
Plattform_Laenge = get(handles.H_Laenge,'String');
Rad_Laenge = get(handles.R_Laenge,'String');
Rad_breite = get(handles.R_Breite,'String');
Abstand_Raede = get(handles.Abstand,'String');

if isempty(Plattform_breite) || isempty(Plattform_Laenge) || isempty(Rad_Laenge) || isempty(Rad_breite) ||...
        isempty(Abstand_Raede) 
  
    msgbox('Bitte f�llen sie alle Parameter Ein !!')
else
set(handles.initial_position,'visible','on');
set(handles.Vorwaerts,'visible','on');
set(handles.Rueckwaerts,'visible','on');
end

%-------------------PLATTFORM POSITION INITIALISIERUNG --------------------

function initial_position_Callback(hObject, eventdata, handles)

data=get(handles.uitable4,'data');
Plattform_breite= str2double(get(handles.H_Breite,'string'));  % Einheit [cm]
Plattform_Laenge= str2double(get(handles.H_Laenge,'string'));    % Einheit [cm]
%Plattform_Tangent_winkel = atand(Plattform_breite/Plattform_Laenge) ; % Theta winkel breite auf laenge
%Plattform_Orientation_winkel 

add_Akt_pos = 2;
add_Nex_pos = 3;
set(handles.pos_1,'string',add_Akt_pos);
set(handles.Pos_2,'string',add_Nex_pos);
try
 %X-Achse Plattform projetzierung
 P1x=str2num(cell2mat(data(1,1)))-(Plattform_breite/2);
 P2x=str2num(cell2mat(data(1,1)))+(Plattform_breite/2);
 P3x=str2num(cell2mat(data(1,1)))+(Plattform_breite/2);
 P4x=str2num(cell2mat(data(1,1)))-(Plattform_breite/2);

 %y-Achse Plattform projetzierung
 P1y=str2num(cell2mat(data(1,2)))+(Plattform_Laenge/2);
 P2y=str2num(cell2mat(data(1,2)))+(Plattform_Laenge/2);
 P3y=str2num(cell2mat(data(1,2)))-(Plattform_Laenge/2);
 P4y=str2num(cell2mat(data(1,2)))-(Plattform_Laenge/2);
 
 PX=[P1x P2x P3x P4x P1x];
 PY=[P1y P2y P3y P4y P1y];
 
 
  % Haupt Parameter Raeder
Rad_breite= str2double(get(handles.R_Breite,'string'));
Rad_laenge= str2double(get(handles.R_Laenge,'string'));
abstand_Zwischen_Raeder = str2double(get(handles.Abstand,'string')); 
 
  %X-Achse Plattform projetzierung
  %....rad1
 P11x=str2num(cell2mat(data(1,1)))+(Plattform_breite/2);
 P12x=str2num(cell2mat(data(1,1)))+((Plattform_breite/2)+ Rad_breite);
 P13x=str2num(cell2mat(data(1,1)))+((Plattform_breite/2)+ Rad_breite);
 P14x=str2num(cell2mat(data(1,1)))+(Plattform_breite/2) ;
 
 
 %y-Achse Plattform projetzierung
 %....rad1
 P11y=str2num(cell2mat(data(1,2)))+(Plattform_Laenge/2);
 P12y=str2num(cell2mat(data(1,2)))+(Plattform_Laenge/2);
 P13y=str2num(cell2mat(data(1,2)))+(Plattform_Laenge/2) - Rad_laenge;
 P14y=str2num(cell2mat(data(1,2)))+(Plattform_Laenge/2) - Rad_laenge;
 %....rad2
 P21y=str2num(cell2mat(data(1,2)))+(Plattform_Laenge/2)-Rad_laenge - abstand_Zwischen_Raeder;
 P22y=str2num(cell2mat(data(1,2)))+(Plattform_Laenge/2)-Rad_laenge - abstand_Zwischen_Raeder;
 P23y=str2num(cell2mat(data(1,2)))+(Plattform_Laenge/2)-2*Rad_laenge - abstand_Zwischen_Raeder;
 P24y=str2num(cell2mat(data(1,2)))+(Plattform_Laenge/2)-2*Rad_laenge - abstand_Zwischen_Raeder;
 
 %....rad3
 P31y=str2num(cell2mat(data(1,2)))+(Plattform_Laenge/2) - 2*Rad_laenge - 2*abstand_Zwischen_Raeder;
 P32y=str2num(cell2mat(data(1,2)))+(Plattform_Laenge/2) - 2*Rad_laenge - 2*abstand_Zwischen_Raeder;
 P33y=str2num(cell2mat(data(1,2)))+(Plattform_Laenge/2) - 3*Rad_laenge - 2*abstand_Zwischen_Raeder;
 P34y=str2num(cell2mat(data(1,2)))+(Plattform_Laenge/2) - 3*Rad_laenge - 2*abstand_Zwischen_Raeder;
 
%....rad4
 P41y=str2num(cell2mat(data(1,2)))+(Plattform_Laenge/2) - 3*Rad_laenge - 3*abstand_Zwischen_Raeder;
 P42y=str2num(cell2mat(data(1,2)))+(Plattform_Laenge/2) - 3*Rad_laenge - 3*abstand_Zwischen_Raeder;
 P43y=str2num(cell2mat(data(1,2)))+(Plattform_Laenge/2) - 4*Rad_laenge - 3*abstand_Zwischen_Raeder;
 P44y=str2num(cell2mat(data(1,2)))+(Plattform_Laenge/2) - 4*Rad_laenge - 3*abstand_Zwischen_Raeder; 
 
 %symetrie 

 P51x=str2num(cell2mat(data(1,1)))-(Plattform_breite/2);
 P52x=str2num(cell2mat(data(1,1)))-((Plattform_breite/2)+ Rad_breite);
 P53x=str2num(cell2mat(data(1,1)))-((Plattform_breite/2)+ Rad_breite);
 P54x=str2num(cell2mat(data(1,1)))-(Plattform_breite/2) ;
 
catch ME
    %X-Achse Plattform projetzierung
 P1x=data(1,1)-(Plattform_breite/2);
 P2x=data(1,1)+(Plattform_breite/2);
 P3x=data(1,1)+(Plattform_breite/2);
 P4x=data(1,1)-(Plattform_breite/2);

 %y-Achse Plattform projetzierung
 P1y=data(1,2)+(Plattform_Laenge/2);
 P2y=data(1,2)+(Plattform_Laenge/2);
 P3y=data(1,2)-(Plattform_Laenge/2);
 P4y=data(1,2)-(Plattform_Laenge/2);
 
 PX=[P1x P2x P3x P4x P1x];
 PY=[P1y P2y P3y P4y P1y];
 
 
  % Haupt Parameter Raeder
Rad_breite= str2double(get(handles.R_Breite,'string'));
Rad_laenge= str2double(get(handles.R_Laenge,'string'));
abstand_Zwischen_Raeder = str2double(get(handles.Abstand,'string')); 
 
  %X-Achse Plattform projetzierung
  %....rad1
 P11x=data(1,1)+(Plattform_breite/2);
 P12x=data(1,1)+((Plattform_breite/2)+ Rad_breite);
 P13x=data(1,1)+((Plattform_breite/2)+ Rad_breite);
 P14x=data(1,1)+(Plattform_breite/2) ;
 
 
 %y-Achse Plattform projetzierung
 %....rad1
 P11y=data(1,2)+(Plattform_Laenge/2);
 P12y=data(1,2)+(Plattform_Laenge/2);
 P13y=data(1,2)+(Plattform_Laenge/2) - Rad_laenge;
 P14y=data(1,2)+(Plattform_Laenge/2) - Rad_laenge;
 %....rad2
 P21y=data(1,2)+(Plattform_Laenge/2)-Rad_laenge - abstand_Zwischen_Raeder;
 P22y=data(1,2)+(Plattform_Laenge/2)-Rad_laenge - abstand_Zwischen_Raeder;
 P23y=data(1,2)+(Plattform_Laenge/2)-2*Rad_laenge - abstand_Zwischen_Raeder;
 P24y=data(1,2)+(Plattform_Laenge/2)-2*Rad_laenge - abstand_Zwischen_Raeder;
 
 %....rad3
 P31y=data(1,2)+(Plattform_Laenge/2) - 2*Rad_laenge - 2*abstand_Zwischen_Raeder;
 P32y=data(1,2)+(Plattform_Laenge/2) - 2*Rad_laenge - 2*abstand_Zwischen_Raeder;
 P33y=data(1,2)+(Plattform_Laenge/2) - 3*Rad_laenge - 2*abstand_Zwischen_Raeder;
 P34y=data(1,2)+(Plattform_Laenge/2) - 3*Rad_laenge - 2*abstand_Zwischen_Raeder;
 
%....rad4
 P41y=data(1,2)+(Plattform_Laenge/2) - 3*Rad_laenge - 3*abstand_Zwischen_Raeder;
 P42y=data(1,2)+(Plattform_Laenge/2) - 3*Rad_laenge - 3*abstand_Zwischen_Raeder;
 P43y=data(1,2)+(Plattform_Laenge/2) - 4*Rad_laenge - 3*abstand_Zwischen_Raeder;
 P44y=data(1,2)+(Plattform_Laenge/2) - 4*Rad_laenge - 3*abstand_Zwischen_Raeder; 
 
 %symetrie 

 P51x=data(1,1)-(Plattform_breite/2);
 P52x=data(1,1)-((Plattform_breite/2)+ Rad_breite);
 P53x=data(1,1)-((Plattform_breite/2)+ Rad_breite);
 P54x=data(1,1)-(Plattform_breite/2) ;
end
 
 
 
 P1X=[P11x P12x P13x P14x P11x];
 P1Y=[P11y P12y P13y P14y P11y];
 P2Y=[P21y P22y P23y P24y P21y];
 P3Y=[P31y P32y P33y P34y P31y];
 P4Y=[P41y P42y P43y P44y P41y]; 
 P5X=[P51x P52x P53x P54x P51x];
 
 hold on;

for i=1:4    
    plot([PX(i) PX(i+1)],[PY(i) PY(i+1)],'-k');  
   % plot([P1X(i) P1X(i+1)],[P1Y(i) P1Y(i+1)],'-r');
    %plot([P1X(i) P1X(i+1)],[P2Y(i) P2Y(i+1)],'-r');
    %plot([P1X(i) P1X(i+1)],[P3Y(i) P3Y(i+1)],'-r');
    %plot([P1X(i) P1X(i+1)],[P4Y(i) P4Y(i+1)],'-r');
  
    %plot([P5X(i) P5X(i+1)],[P1Y(i) P1Y(i+1)],'-r');
   % plot([P5X(i) P5X(i+1)],[P2Y(i) P2Y(i+1)],'-r');
   % plot([P5X(i) P5X(i+1)],[P3Y(i) P3Y(i+1)],'-r');
   % plot([P5X(i) P5X(i+1)],[P4Y(i) P4Y(i+1)],'-r');
 
end 
%legend('Ecken','Grenzen');
hold off;


%-------------------PLATTFORM R�CKW�RTS POSITION---------------------------

function Rueckwaerts_Callback(hObject, eventdata, handles)

Plot_Callback(handles.Plot, eventdata,handles); % FIGURE UPDATE

data=get(handles.uitable4,'data'); % LAUFLINIEN PUNKTE F�R DIE LOKALISATION DER POSITION-PLATTFORM
Akt_pos = str2double(get(handles.pos_1,'string')); % AKTUELLE POSITION DER PLATTFORM
Nex_pos= str2double(get(handles.Pos_2,'string'));% ZIEL POSITION DER PLATTFORM

if Akt_pos <= length(data(1))
   
   initial_position_Callback(handles.Plot, eventdata,handles); 
else 

add_Akt_pos = Akt_pos-1;
add_Nex_pos = Nex_pos-1;
set(handles.pos_1,'string',add_Akt_pos);
set(handles.Pos_2,'string',add_Nex_pos);

%PLATTFORM PARAMETER F�R DIE BERECHNUNG
Plattform_breite= str2double(get(handles.H_Breite,'string'));  % Einheit [cm]
Plattform_Laenge= str2double(get(handles.H_Laenge,'string'));    % Einheit [cm]

Plattform_Tangent_winkel = atand(Plattform_breite/Plattform_Laenge) ; % betha winkel breite auf l�nge
try
PPosition1=str2num(cell2mat(data(add_Akt_pos,1)))
PPosition2=str2num(cell2mat(data(add_Akt_pos,2)))
Plattform_Orientation_winkel = atand((str2num(cell2mat(data(add_Akt_pos,2))) - str2num(cell2mat(data(add_Nex_pos,2))))/(str2num(cell2mat(data(add_Akt_pos,1))) - str2num(cell2mat(data(add_Nex_pos,1))))); % Theta winkel
catch ME
PPosition1= data(add_Akt_pos,1)
PPosition2= data(add_Akt_pos,2)
Plattform_Orientation_winkel = atand((data(add_Akt_pos,2) - data(add_Nex_pos,2))/(data(add_Akt_pos,1) - data(add_Nex_pos,1))); % Theta winkel
    
end
Plattform_Hypothenus = Plattform_Laenge/(2*cosd(Plattform_Tangent_winkel));  %abstand C
Symetrie1_winkel= Plattform_Tangent_winkel + Plattform_Orientation_winkel; % alpha
Symetrie1_winke2= Plattform_Tangent_winkel - Plattform_Orientation_winkel; % alpha stern


% PLATTFORM KOORDINATEN SYSTEM PUNKTE

% symetrie1 Abst�nde
P1X_Abstand = Plattform_Hypothenus * cosd(Symetrie1_winkel);
P1Y_Abstand = Plattform_Hypothenus * sind(Symetrie1_winkel);
 
% symetrie2 Abst�nde
P2X_Abstand = Plattform_Hypothenus * cosd(Symetrie1_winke2);
P2Y_Abstand = Plattform_Hypothenus * sind(Symetrie1_winke2);
 
%X-Achse Plattform projetzierung
 P1x= PPosition1 + P1X_Abstand;
 P2x= PPosition1 + P2X_Abstand;
 P3x= PPosition1 - P1X_Abstand;
 P4x= PPosition1 - P2X_Abstand;
 
 %y-Achse Plattform projetzierung
 P1y= PPosition2 + P1Y_Abstand;
 P2y= PPosition2 - P2Y_Abstand;
 P3y= PPosition2 - P1Y_Abstand;
 P4y= PPosition2 + P2Y_Abstand;
 
 %MATRIX F�R DIE GESAMT KOORDINATEN SYSTEM PLATTFORM
 PX=[P1x P2x P3x P4x P1x];
 PY=[P1y P2y P3y P4y P1y];
 
 
 %R�DER PARAMETER F�R DIR BERECHNUNG 
Rad_breite= str2double(get(handles.R_Breite,'string'));
Rad_laenge= str2double(get(handles.R_Laenge,'string'));
abstand_Zwischen_Raeder = str2double(get(handles.Abstand,'string'));
abstand1_Mitell_Raeder = (Plattform_Laenge/2)-(abstand_Zwischen_Raeder + Rad_laenge); 
abstand2_Mitell_Raeder = (Plattform_Laenge/2)-(abstand_Zwischen_Raeder+2*Rad_laenge); 


%******************** Rad1 ******************

  %rad12 Punkte Parameter
Rad12_Tangent_winkel = atand(((Plattform_breite/2) + Rad_breite)/(Plattform_Laenge/2));
Rad12_Hypothenus =(Plattform_Laenge/ (2*cosd(Rad12_Tangent_winkel)));
rad12_winkel= Rad12_Tangent_winkel + Plattform_Orientation_winkel; 
%  Abst�nde Rad12
P12X_Abstand = Rad12_Hypothenus * cosd(rad12_winkel);
P12Y_Abstand = Rad12_Hypothenus * sind(rad12_winkel);
  
 %rad13 Punkte Parameter
Rad13_Tangent_winkel = atand(((Plattform_breite/2)+Rad_breite)/((Plattform_Laenge/2) - Rad_laenge));
Rad13_Hypothenus =((Plattform_Laenge/2) - Rad_laenge ) / cosd(Rad13_Tangent_winkel);
rad13_winkel= Rad13_Tangent_winkel + Plattform_Orientation_winkel; 
%  Abst�nde Rad13
P13X_Abstand = Rad13_Hypothenus * cosd(rad13_winkel);
P13Y_Abstand = Rad13_Hypothenus * sind(rad13_winkel);
 
 %rad14 Punkte Parameter
Rad14_Tangent_winkel = atand((Plattform_breite/2) /((Plattform_Laenge/2) - Rad_laenge));
Rad14_Hypothenus = ((Plattform_Laenge/2) - Rad_laenge ) / cosd(Rad14_Tangent_winkel);
rad14_winkel= Rad14_Tangent_winkel + Plattform_Orientation_winkel; 
%  Abst�nde Rad14
P14X_Abstand = Rad14_Hypothenus * cosd(rad14_winkel);
P14Y_Abstand = Rad14_Hypothenus * sind(rad14_winkel);
 
%X-Achse R�der projetzierung
 P12x= PPosition1 + P12X_Abstand;
 P13x= PPosition1 + P13X_Abstand;
 P14x= PPosition1 + P14X_Abstand;
 
 %y-Achse R�der projetzierung
 P12y= PPosition2 + P12Y_Abstand ;
 P13y= PPosition2 + P13Y_Abstand ;
 P14y= PPosition2 + P14Y_Abstand ;
 
 P1X=[P1x P12x P13x P14x P1x];
 P1Y=[P1y P12y P13y P14y P1y];
  
 %******************** Rad2 ******************
 
 
  %rad22 Punkte Parameter
Rad22_Tangent_winkel = atand(((Plattform_breite/2) + Rad_breite)/(Plattform_Laenge/2));
Rad22_Hypothenus =(Plattform_Laenge/ (2*cosd(Rad22_Tangent_winkel)));
rad22_winkel= Rad22_Tangent_winkel - Plattform_Orientation_winkel; 
%  Abst�nde Rad22
P22X_Abstand = Rad22_Hypothenus * cosd(rad22_winkel);
P22Y_Abstand = Rad22_Hypothenus * sind(rad22_winkel);
 
  %rad23 Punkte Parameter
Rad23_Tangent_winkel = atand(((Plattform_breite/2)+Rad_breite)/((Plattform_Laenge/2) - Rad_laenge));
Rad23_Hypothenus =((Plattform_Laenge/2) - Rad_laenge ) / cosd(Rad23_Tangent_winkel);
rad23_winkel= Rad23_Tangent_winkel - Plattform_Orientation_winkel; 
%  Abst�nde Rad23
P23X_Abstand = Rad23_Hypothenus * cosd(rad23_winkel);
P23Y_Abstand = Rad23_Hypothenus * sind(rad23_winkel);
 
 
  %rad24 Punkte Parameter
Rad24_Tangent_winkel = atand((Plattform_breite/2) /((Plattform_Laenge/2) - Rad_laenge));
Rad24_Hypothenus = ((Plattform_Laenge/2) - Rad_laenge ) / cosd(Rad24_Tangent_winkel);
rad24_winkel= Rad24_Tangent_winkel - Plattform_Orientation_winkel; 
%  Abst�nde Rad14
P24X_Abstand = Rad24_Hypothenus * cosd(rad24_winkel);
P24Y_Abstand = Rad24_Hypothenus * sind(rad24_winkel);
 
 %X-Achse R�der projetzierung
 P22x= PPosition1 + P22X_Abstand;
 P23x= PPosition1 + P23X_Abstand;
 P24x= PPosition1 + P24X_Abstand;
 %y-Achse R�der projetzierung
 P22y= PPosition2 - P22Y_Abstand ;
 P23y= PPosition2 - P23Y_Abstand ;
 P24y= PPosition2 - P24Y_Abstand ;
 
 P2X=[P2x P22x P23x P24x P2x];
 P2Y=[P2y P22y P23y P24y P2y];
 
  %******************** Rad7,8 symetrie ******************
 
  %X-Achse R�der projetzierung
 
  %.....Rad7
 P72x= PPosition1 - P22X_Abstand;
 P73x= PPosition1 - P23X_Abstand;
 P74x= PPosition1 - P24X_Abstand;
 %....Rad8
 P82x= PPosition1 - P12X_Abstand;
 P83x= PPosition1 - P13X_Abstand;
 P84x= PPosition1 - P14X_Abstand;
 
 %y-Achse R�der projetzierung
 
  %.....Rad7
 P72y= PPosition2 + P22Y_Abstand ;
 P73y= PPosition2 + P23Y_Abstand ;
 P74y= PPosition2 + P24Y_Abstand ;
 %....Rad8
 P82y= PPosition2 - P12Y_Abstand ;
 P83y= PPosition2 - P13Y_Abstand ;
 P84y= PPosition2 - P14Y_Abstand ;
 
 P7X=[P4x P72x P73x P74x P4x];
 P7Y=[P4y P72y P73y P74y P4y];
 
 P8X=[P3x P82x P83x P84x P3x];
 P8Y=[P3y P82y P83y P84y P3y];
 
 
 %******************** Rad3 ****************** 
 
  %rad31 Punkte Parameter
Rad31_Tangent_winkel = atand((Plattform_breite/2)/abstand1_Mitell_Raeder);
Rad31_Hypothenus =(abstand1_Mitell_Raeder/ cosd(Rad31_Tangent_winkel));
rad31_winkel= Rad31_Tangent_winkel + Plattform_Orientation_winkel; 
%  Abst�nde Rad12
P31X_Abstand = Rad31_Hypothenus * cosd(rad31_winkel);
P31Y_Abstand = Rad31_Hypothenus * sind(rad31_winkel);
 
%rad32 Punkte Parameter
Rad32_Tangent_winkel = atand(((Plattform_breite/2)+Rad_breite)/abstand1_Mitell_Raeder);
Rad32_Hypothenus =(abstand1_Mitell_Raeder/ cosd(Rad32_Tangent_winkel));
rad32_winkel= Rad32_Tangent_winkel + Plattform_Orientation_winkel; 
%  Abst�nde Rad12
P32X_Abstand = Rad32_Hypothenus * cosd(rad32_winkel);
P32Y_Abstand = Rad32_Hypothenus * sind(rad32_winkel);
 
%rad33 Punkte Parameter
Rad33_Tangent_winkel = atand(((Plattform_breite/2)+Rad_breite)/abstand2_Mitell_Raeder);
Rad33_Hypothenus =(abstand2_Mitell_Raeder/ cosd(Rad33_Tangent_winkel));
rad33_winkel= Rad33_Tangent_winkel + Plattform_Orientation_winkel; 
%  Abst�nde Rad33
P33X_Abstand = Rad33_Hypothenus * cosd(rad33_winkel);
P33Y_Abstand = Rad33_Hypothenus * sind(rad33_winkel);
 
%rad34 Punkte Parameter
Rad34_Tangent_winkel = atand((Plattform_breite/2)/abstand2_Mitell_Raeder);
Rad34_Hypothenus =(abstand2_Mitell_Raeder/ cosd(Rad34_Tangent_winkel));
rad34_winkel= Rad34_Tangent_winkel + Plattform_Orientation_winkel; 
%  Abst�nde Rad34
P34X_Abstand = Rad34_Hypothenus * cosd(rad34_winkel);
P34Y_Abstand = Rad34_Hypothenus * sind(rad34_winkel);
 
%******************** Rad4 ****************** 
 
  %rad41 Punkte Parameter
Rad41_Tangent_winkel = atand((Plattform_breite/2)/abstand1_Mitell_Raeder);
Rad41_Hypothenus =(abstand1_Mitell_Raeder/ cosd(Rad41_Tangent_winkel));
rad41_winkel= Rad41_Tangent_winkel - Plattform_Orientation_winkel; 
%  Abst�nde Rad41
P41X_Abstand = Rad41_Hypothenus * cosd(rad41_winkel);
P41Y_Abstand = Rad41_Hypothenus * sind(rad41_winkel);
 
%rad42 Punkte Parameter
Rad42_Tangent_winkel = atand(((Plattform_breite/2)+Rad_breite)/abstand1_Mitell_Raeder);
Rad42_Hypothenus =(abstand1_Mitell_Raeder/ cosd(Rad42_Tangent_winkel));
rad42_winkel= Rad42_Tangent_winkel - Plattform_Orientation_winkel; 
%  Abst�nde Rad42
P42X_Abstand = Rad42_Hypothenus * cosd(rad42_winkel);
P42Y_Abstand = Rad42_Hypothenus * sind(rad42_winkel);
 
%rad43 Punkte Parameter
Rad43_Tangent_winkel = atand(((Plattform_breite/2)+Rad_breite)/abstand2_Mitell_Raeder);
Rad43_Hypothenus =(abstand2_Mitell_Raeder/ cosd(Rad43_Tangent_winkel));
rad43_winkel= Rad43_Tangent_winkel - Plattform_Orientation_winkel; 
%  Abst�nde Rad43
P43X_Abstand = Rad43_Hypothenus * cosd(rad43_winkel);
P43Y_Abstand = Rad43_Hypothenus * sind(rad43_winkel);
 
%rad44 Punkte Parameter
Rad44_Tangent_winkel = atand((Plattform_breite/2)/abstand2_Mitell_Raeder);
Rad44_Hypothenus =(abstand2_Mitell_Raeder/ cosd(Rad44_Tangent_winkel));
rad44_winkel= Rad44_Tangent_winkel - Plattform_Orientation_winkel; 
%  Abst�nde Rad34
P44X_Abstand = Rad44_Hypothenus * cosd(rad44_winkel);
P44Y_Abstand = Rad44_Hypothenus * sind(rad44_winkel);
 
 %x-Achse Plattform projetzierung
 %...rad3
 P31x= PPosition1 + P31X_Abstand;
 P32x= PPosition1 + P32X_Abstand;
 P33x= PPosition1 + P33X_Abstand;
 P34x= PPosition1 + P34X_Abstand;
 %...rad4
 P41x= PPosition1 + P41X_Abstand;
 P42x= PPosition1 + P42X_Abstand;
 P43x= PPosition1 + P43X_Abstand;
 P44x= PPosition1 + P44X_Abstand;
 
 %y-Achse Plattform projetzierung
 %...rad3
 P31y= PPosition2 + P31Y_Abstand;
 P32y= PPosition2 + P32Y_Abstand;
 P33y= PPosition2 + P33Y_Abstand;
 P34y= PPosition2 + P34Y_Abstand;
  %...rad4
 P41y= PPosition2 - P41Y_Abstand;
 P42y= PPosition2 - P42Y_Abstand;
 P43y= PPosition2 - P43Y_Abstand;
 P44y= PPosition2 - P44Y_Abstand;
 
 
 P3X=[ P31x P32x P33x P34x P31x];
 P3Y=[ P31y P32y P33y P34y P31y];
 
 P4X=[ P41x P42x P43x P44x P41x];
 P4Y=[ P41y P42y P43y P44y P41y];
 
 
 %******************** Rad5,6 symetrie ******************
 
  %X-Achse R�der projetzierung
 
  %.....Rad5
 P51x= PPosition1 - P41X_Abstand;
 P52x= PPosition1- P42X_Abstand;
 P53x= PPosition1 - P43X_Abstand;
 P54x= PPosition1 - P44X_Abstand;
 %....Rad6
 P61x= PPosition1 - P31X_Abstand;
 P62x= PPosition1 - P32X_Abstand;
 P63x= PPosition1 - P33X_Abstand;
 P64x= PPosition1 - P34X_Abstand;
 
 %y-Achse R�der projetzierung
 
  %.....Rad5
 P51y= PPosition2 + P41Y_Abstand ;
 P52y= PPosition2 + P42Y_Abstand ;
 P53y= PPosition2 + P43Y_Abstand ;
 P54y= PPosition2 + P44Y_Abstand ;
 %....Rad8
 P61y= PPosition2 - P31Y_Abstand ;
 P62y= PPosition2 - P32Y_Abstand ;
 P63y= PPosition2 - P33Y_Abstand ;
 P64y= PPosition2 - P34Y_Abstand ;
 
 P5X=[P51x P52x P53x P54x P51x];
 P5Y=[P51y P52y P53y P54y P51y];
 
 P6X=[P61x P62x P63x P64x P61x];
 P6Y=[P61y P62y P63y P64y P61y];
 
 hold on;
 
 
 % DAS GESAMT PLATTFORM PLOTTEN
for i=1:4 %ANZAHL DER KOORDINATEN PUNKTE PRO EINHEIT
    plot([PX(i) PX(i+1)],[PY(i) PY(i+1)],'-k');   
    plot([P1X(i) P1X(i+1)],[P1Y(i) P1Y(i+1)],'-r');
    plot([P2X(i) P2X(i+1)],[P2Y(i) P2Y(i+1)],'-r'); 
    plot([P7X(i) P7X(i+1)],[P7Y(i) P7Y(i+1)],'-r');
    plot([P8X(i) P8X(i+1)],[P8Y(i) P8Y(i+1)],'-r');
    plot([P3X(i) P3X(i+1)],[P3Y(i) P3Y(i+1)],'-r');
    plot([P4X(i) P4X(i+1)],[P4Y(i) P4Y(i+1)],'-r');
    plot([P5X(i) P5X(i+1)],[P5Y(i) P5Y(i+1)],'-r');
    plot([P6X(i) P6X(i+1)],[P6Y(i) P6Y(i+1)],'-r');
end  

end


%-------------------PLATTFORM VORW�RTS POSITION---------------------------
function Vorwaerts_Callback(hObject, eventdata, handles)
Plot_Callback(handles.Plot, eventdata,handles);

data=get(handles.uitable4,'data');
Akt_pos = str2double(get(handles.pos_1,'string'));
Nex_pos= str2double(get(handles.Pos_2,'string'));

if Akt_pos >= length(data)
   
   initial_position_Callback(handles.Plot, eventdata,handles); 
else    
add_Akt_pos = Akt_pos+1;
add_Nex_pos = Nex_pos+1;
set(handles.pos_1,'string',add_Akt_pos);
set(handles.Pos_2,'string',add_Nex_pos);


Plattform_breite= str2double(get(handles.H_Breite,'string'));  % Einheit [cm]
Plattform_Laenge= str2double(get(handles.H_Laenge,'string'));    % Einheit [cm]

Plattform_Tangent_winkel = atand(Plattform_breite/Plattform_Laenge) ; % betha winkel breite auf l�nge

try
PPosition1=str2num(cell2mat(data(Akt_pos,1)))
PPosition2=str2num(cell2mat(data(Akt_pos,2)))
Plattform_Orientation_winkel = atand((str2num(cell2mat(data(Akt_pos,2))) - str2num(cell2mat(data(Nex_pos,2))))/(str2num(cell2mat(data(Akt_pos,1))) - str2num(cell2mat(data(Nex_pos,1))))); % Theta winkel
catch ME
PPosition1= data(Akt_pos,1)
PPosition2= data(Akt_pos,2)
Plattform_Orientation_winkel = atand((data(Akt_pos,2) - data(Nex_pos,2))/(data(Akt_pos,1) - data(Nex_pos,1))); % Theta winkel
end

Plattform_Hypothenus = Plattform_Laenge/(2*cosd(Plattform_Tangent_winkel));  %abstand C
Symetrie1_winkel= Plattform_Tangent_winkel + Plattform_Orientation_winkel; % alpha
Symetrie1_winke2= Plattform_Tangent_winkel - Plattform_Orientation_winkel; % alpha Stern

% symetrie1 Abst�nde
P1X_Abstand = Plattform_Hypothenus * cosd(Symetrie1_winkel);
P1Y_Abstand = Plattform_Hypothenus * sind(Symetrie1_winkel);
 
% symetrie2 Abst�nde
P2X_Abstand = Plattform_Hypothenus * cosd(Symetrie1_winke2);
P2Y_Abstand = Plattform_Hypothenus * sind(Symetrie1_winke2);
 
%X-Achse Plattform projetzierung
 P1x= PPosition1 + P1X_Abstand;
 P2x= PPosition1 + P2X_Abstand;
 P3x= PPosition1 - P1X_Abstand;
 P4x= PPosition1 - P2X_Abstand;
 
 %y-Achse Plattform projetzierung
 P1y= PPosition2 + P1Y_Abstand;
 P2y= PPosition2 - P2Y_Abstand;
 P3y= PPosition2 - P1Y_Abstand;
 P4y= PPosition2 + P2Y_Abstand;
 
 PX=[P1x P2x P3x P4x P1x];
 PY=[P1y P2y P3y P4y P1y];
 
 %################################################## Haupt Parameter Raeder
Rad_breite= str2double(get(handles.R_Breite,'string'));
Rad_laenge= str2double(get(handles.R_Laenge,'string'));
abstand_Zwischen_Raeder = str2double(get(handles.Abstand,'string'));
abstand1_Mitell_Raeder = (Plattform_Laenge/2)-(abstand_Zwischen_Raeder + Rad_laenge); 
abstand2_Mitell_Raeder = (Plattform_Laenge/2)-(abstand_Zwischen_Raeder+2*Rad_laenge); 
%******************** Rad1 ******************
 
 
  %rad12 Punkte Parameter
Rad12_Tangent_winkel = atand(((Plattform_breite/2) + Rad_breite)/(Plattform_Laenge/2));
Rad12_Hypothenus =(Plattform_Laenge/ (2*cosd(Rad12_Tangent_winkel)));
rad12_winkel= Rad12_Tangent_winkel + Plattform_Orientation_winkel; 
%  Abst�nde Rad12
P12X_Abstand = Rad12_Hypothenus * cosd(rad12_winkel);
P12Y_Abstand = Rad12_Hypothenus * sind(rad12_winkel);
  
 %rad13 Punkte Parameter
Rad13_Tangent_winkel = atand(((Plattform_breite/2)+Rad_breite)/((Plattform_Laenge/2) - Rad_laenge));
Rad13_Hypothenus =((Plattform_Laenge/2) - Rad_laenge ) / cosd(Rad13_Tangent_winkel);
rad13_winkel= Rad13_Tangent_winkel + Plattform_Orientation_winkel; 
%  Abst�nde Rad13
P13X_Abstand = Rad13_Hypothenus * cosd(rad13_winkel);
P13Y_Abstand = Rad13_Hypothenus * sind(rad13_winkel);
 
 %rad14 Punkte Parameter
Rad14_Tangent_winkel = atand((Plattform_breite/2) /((Plattform_Laenge/2) - Rad_laenge));
Rad14_Hypothenus = ((Plattform_Laenge/2) - Rad_laenge ) / cosd(Rad14_Tangent_winkel);
rad14_winkel= Rad14_Tangent_winkel + Plattform_Orientation_winkel; 
%  Abst�nde Rad14
P14X_Abstand = Rad14_Hypothenus * cosd(rad14_winkel);
P14Y_Abstand = Rad14_Hypothenus * sind(rad14_winkel);
 
%X-Achse R�der projetzierung
 P12x= PPosition1 + P12X_Abstand;
 P13x= PPosition1 + P13X_Abstand;
 P14x= PPosition1 + P14X_Abstand;
 
 %y-Achse R�der projetzierung
 P12y= PPosition2 + P12Y_Abstand ;
 P13y= PPosition2 + P13Y_Abstand ;
 P14y= PPosition2 + P14Y_Abstand ;
 
 
 
 P1X=[P1x P12x P13x P14x P1x];
 P1Y=[P1y P12y P13y P14y P1y];
  
 %******************** Rad2 ******************
 
 
  %rad22 Punkte Parameter
Rad22_Tangent_winkel = atand(((Plattform_breite/2) + Rad_breite)/(Plattform_Laenge/2));
Rad22_Hypothenus =(Plattform_Laenge/ (2*cosd(Rad22_Tangent_winkel)));
rad22_winkel= Rad22_Tangent_winkel - Plattform_Orientation_winkel; 
%  Abst�nde Rad22
P22X_Abstand = Rad22_Hypothenus * cosd(rad22_winkel);
P22Y_Abstand = Rad22_Hypothenus * sind(rad22_winkel);
 
  %rad23 Punkte Parameter
Rad23_Tangent_winkel = atand(((Plattform_breite/2)+Rad_breite)/((Plattform_Laenge/2) - Rad_laenge));
Rad23_Hypothenus =((Plattform_Laenge/2) - Rad_laenge ) / cosd(Rad23_Tangent_winkel);
rad23_winkel= Rad23_Tangent_winkel - Plattform_Orientation_winkel; 
%  Abst�nde Rad23
P23X_Abstand = Rad23_Hypothenus * cosd(rad23_winkel);
P23Y_Abstand = Rad23_Hypothenus * sind(rad23_winkel);
 
 
  %rad24 Punkte Parameter
Rad24_Tangent_winkel = atand((Plattform_breite/2) /((Plattform_Laenge/2) - Rad_laenge));
Rad24_Hypothenus = ((Plattform_Laenge/2) - Rad_laenge ) / cosd(Rad24_Tangent_winkel);
rad24_winkel= Rad24_Tangent_winkel - Plattform_Orientation_winkel; 
%  Abst�nde Rad14
P24X_Abstand = Rad24_Hypothenus * cosd(rad24_winkel);
P24Y_Abstand = Rad24_Hypothenus * sind(rad24_winkel);
 
 %X-Achse R�der projetzierung
 P22x= PPosition1 + P22X_Abstand;
 P23x= PPosition1 + P23X_Abstand;
 P24x= PPosition1 + P24X_Abstand;
 %y-Achse R�der projetzierung
 P22y= PPosition2 - P22Y_Abstand ;
 P23y= PPosition2 - P23Y_Abstand ;
 P24y= PPosition2 - P24Y_Abstand ;
 
 P2X=[P2x P22x P23x P24x P2x];
 P2Y=[P2y P22y P23y P24y P2y];
 
  %******************** Rad7,8 symetrie ******************
 
  %X-Achse R�der projetzierung
 
  %.....Rad7
 P72x= PPosition1 - P22X_Abstand;
 P73x= PPosition1 - P23X_Abstand;
 P74x= PPosition1 - P24X_Abstand;
 %....Rad8
 P82x= PPosition1 - P12X_Abstand;
 P83x= PPosition1 - P13X_Abstand;
 P84x= PPosition1 - P14X_Abstand;
 
 %y-Achse R�der projetzierung
 
  %.....Rad7
 P72y= PPosition2 + P22Y_Abstand ;
 P73y= PPosition2 + P23Y_Abstand ;
 P74y= PPosition2 + P24Y_Abstand ;
 %....Rad8
 P82y= PPosition2 - P12Y_Abstand ;
 P83y= PPosition2 - P13Y_Abstand ;
 P84y= PPosition2 - P14Y_Abstand ;
 
 P7X=[P4x P72x P73x P74x P4x];
 P7Y=[P4y P72y P73y P74y P4y];
 
 P8X=[P3x P82x P83x P84x P3x];
 P8Y=[P3y P82y P83y P84y P3y];
 
 
 %******************** Rad3 ****************** 
 
  %rad31 Punkte Parameter
Rad31_Tangent_winkel = atand((Plattform_breite/2)/abstand1_Mitell_Raeder);
Rad31_Hypothenus =(abstand1_Mitell_Raeder/ cosd(Rad31_Tangent_winkel));
rad31_winkel= Rad31_Tangent_winkel + Plattform_Orientation_winkel; 
%  Abst�nde Rad12
P31X_Abstand = Rad31_Hypothenus * cosd(rad31_winkel);
P31Y_Abstand = Rad31_Hypothenus * sind(rad31_winkel);
 
%rad32 Punkte Parameter
Rad32_Tangent_winkel = atand(((Plattform_breite/2)+Rad_breite)/abstand1_Mitell_Raeder);
Rad32_Hypothenus =(abstand1_Mitell_Raeder/ cosd(Rad32_Tangent_winkel));
rad32_winkel= Rad32_Tangent_winkel + Plattform_Orientation_winkel; 
%  Abst�nde Rad12
P32X_Abstand = Rad32_Hypothenus * cosd(rad32_winkel);
P32Y_Abstand = Rad32_Hypothenus * sind(rad32_winkel);
 
%rad33 Punkte Parameter
Rad33_Tangent_winkel = atand(((Plattform_breite/2)+Rad_breite)/abstand2_Mitell_Raeder);
Rad33_Hypothenus =(abstand2_Mitell_Raeder/ cosd(Rad33_Tangent_winkel));
rad33_winkel= Rad33_Tangent_winkel + Plattform_Orientation_winkel; 
%  Abst�nde Rad33
P33X_Abstand = Rad33_Hypothenus * cosd(rad33_winkel);
P33Y_Abstand = Rad33_Hypothenus * sind(rad33_winkel);
 
%rad34 Punkte Parameter
Rad34_Tangent_winkel = atand((Plattform_breite/2)/abstand2_Mitell_Raeder);
Rad34_Hypothenus =(abstand2_Mitell_Raeder/ cosd(Rad34_Tangent_winkel));
rad34_winkel= Rad34_Tangent_winkel + Plattform_Orientation_winkel; 
%  Abst�nde Rad34
P34X_Abstand = Rad34_Hypothenus * cosd(rad34_winkel);
P34Y_Abstand = Rad34_Hypothenus * sind(rad34_winkel);
 
%******************** Rad4 ****************** 
 
  %rad41 Punkte Parameter
Rad41_Tangent_winkel = atand((Plattform_breite/2)/abstand1_Mitell_Raeder);
Rad41_Hypothenus =(abstand1_Mitell_Raeder/ cosd(Rad41_Tangent_winkel));
rad41_winkel= Rad41_Tangent_winkel - Plattform_Orientation_winkel; 
%  Abst�nde Rad41
P41X_Abstand = Rad41_Hypothenus * cosd(rad41_winkel);
P41Y_Abstand = Rad41_Hypothenus * sind(rad41_winkel);
 
%rad42 Punkte Parameter
Rad42_Tangent_winkel = atand(((Plattform_breite/2)+Rad_breite)/abstand1_Mitell_Raeder);
Rad42_Hypothenus =(abstand1_Mitell_Raeder/ cosd(Rad42_Tangent_winkel));
rad42_winkel= Rad42_Tangent_winkel - Plattform_Orientation_winkel; 
%  Abst�nde Rad42
P42X_Abstand = Rad42_Hypothenus * cosd(rad42_winkel);
P42Y_Abstand = Rad42_Hypothenus * sind(rad42_winkel);
 
%rad43 Punkte Parameter
Rad43_Tangent_winkel = atand(((Plattform_breite/2)+Rad_breite)/abstand2_Mitell_Raeder);
Rad43_Hypothenus =(abstand2_Mitell_Raeder/ cosd(Rad43_Tangent_winkel));
rad43_winkel= Rad43_Tangent_winkel - Plattform_Orientation_winkel; 
%  Abst�nde Rad43
P43X_Abstand = Rad43_Hypothenus * cosd(rad43_winkel);
P43Y_Abstand = Rad43_Hypothenus * sind(rad43_winkel);
 
%rad44 Punkte Parameter
Rad44_Tangent_winkel = atand((Plattform_breite/2)/abstand2_Mitell_Raeder);
Rad44_Hypothenus =(abstand2_Mitell_Raeder/ cosd(Rad44_Tangent_winkel));
rad44_winkel= Rad44_Tangent_winkel - Plattform_Orientation_winkel; 
%  Abst�nde Rad34
P44X_Abstand = Rad44_Hypothenus * cosd(rad44_winkel);
P44Y_Abstand = Rad44_Hypothenus * sind(rad44_winkel);
 
 %x-Achse Plattform projetzierung
 %...rad3
 P31x= PPosition1 + P31X_Abstand;
 P32x= PPosition1 + P32X_Abstand;
 P33x= PPosition1 + P33X_Abstand;
 P34x= PPosition1 + P34X_Abstand;
 %...rad4
 P41x= PPosition1 + P41X_Abstand;
 P42x= PPosition1 + P42X_Abstand;
 P43x= PPosition1 + P43X_Abstand;
 P44x= PPosition1 + P44X_Abstand;
 
 %y-Achse Plattform projetzierung
 %...rad3
 P31y= PPosition2 + P31Y_Abstand;
 P32y= PPosition2 + P32Y_Abstand;
 P33y= PPosition2 + P33Y_Abstand;
 P34y= PPosition2 + P34Y_Abstand;
  %...rad4
 P41y= PPosition2 - P41Y_Abstand;
 P42y= PPosition2 - P42Y_Abstand;
 P43y= PPosition2 - P43Y_Abstand;
 P44y= PPosition2 - P44Y_Abstand;
 
 
 P3X=[ P31x P32x P33x P34x P31x];
 P3Y=[ P31y P32y P33y P34y P31y];
 
 P4X=[ P41x P42x P43x P44x P41x];
 P4Y=[ P41y P42y P43y P44y P41y];
 
 
 %******************** Rad5,6 symetrie ******************
 
  %X-Achse R�der projetzierung
 
  %.....Rad5
 P51x= PPosition1 - P41X_Abstand;
 P52x= PPosition1- P42X_Abstand;
 P53x= PPosition1 - P43X_Abstand;
 P54x= PPosition1 - P44X_Abstand;
 %....Rad6
 P61x= PPosition1 - P31X_Abstand;
 P62x= PPosition1 - P32X_Abstand;
 P63x= PPosition1 - P33X_Abstand;
 P64x= PPosition1 - P34X_Abstand;
 
 %y-Achse R�der projetzierung
 
  %.....Rad5
 P51y= PPosition2 + P41Y_Abstand ;
 P52y= PPosition2 + P42Y_Abstand ;
 P53y= PPosition2 + P43Y_Abstand ;
 P54y= PPosition2 + P44Y_Abstand ;
 %....Rad8
 P61y= PPosition2 - P31Y_Abstand ;
 P62y= PPosition2 - P32Y_Abstand ;
 P63y= PPosition2 - P33Y_Abstand ;
 P64y= PPosition2 - P34Y_Abstand ;
 
 P5X=[P51x P52x P53x P54x P51x];
 P5Y=[P51y P52y P53y P54y P51y];
 
 P6X=[P61x P62x P63x P64x P61x];
 P6Y=[P61y P62y P63y P64y P61y];
 
 hold on;
 
for i=1:4
    plot([PX(i) PX(i+1)],[PY(i) PY(i+1)],'-k');   
    plot([P1X(i) P1X(i+1)],[P1Y(i) P1Y(i+1)],'-r');
    plot([P2X(i) P2X(i+1)],[P2Y(i) P2Y(i+1)],'-r'); 
    plot([P7X(i) P7X(i+1)],[P7Y(i) P7Y(i+1)],'-r');
    plot([P8X(i) P8X(i+1)],[P8Y(i) P8Y(i+1)],'-r');
    plot([P3X(i) P3X(i+1)],[P3Y(i) P3Y(i+1)],'-r');
    plot([P4X(i) P4X(i+1)],[P4Y(i) P4Y(i+1)],'-r');
    plot([P5X(i) P5X(i+1)],[P5Y(i) P5Y(i+1)],'-r');
    plot([P6X(i) P6X(i+1)],[P6Y(i) P6Y(i+1)],'-r');
end  
 

    
    
end


%################TABELLEN STEUERUNGSFUNKTIONEN#############################

%-------------- TABELLEN ENTLEEREN-----------------------------------------
function pushbutton_Clear_data1_Callback(hObject, eventdata, handles)
data(:,1)=(0);
data(:,2)=(0);
set(handles.uitable4, 'data',data);
data1(:,1)=(0);
data1(:,2)=(0);
data1(:,3)=(0);
set(handles.uitable9, 'data',data1); 
set(handles.uitable10, 'data',data1); 

%-------------- ZEILE EINF�HGEN LAUFLINIE TABELLE--------------------------
function Add_row_Callback(hObject, eventdata, handles)

data=get(handles.uitable4, 'data'); 
try
data(end+1,:)= {'0'};   
catch ME
data(end+1,:)= (0);  
end
set(handles.uitable4, 'data', data);


%-------------- ZEILE L�SCHEN LAUFLINIE TABELLE----------------------------
function Delete_row_Callback(hObject, eventdata, handles)

data=get(handles.uitable4, 'data'); 
data(end,:)=[]; 
set(handles.uitable4, 'data', data);

%-------------- LAUFLINIE NACH OBEN VERSCHIEBEN----------------------------
function Y_oben_verschieben_Callback(hObject, eventdata, handles)

Verschiebung_Schritt=get(handles.X_Achse_verschieben,'String');
epsilon = str2num(Verschiebung_Schritt);
data=get(handles.uitable4, 'data'); 
A=data(:,2);
f = @(x) x + epsilon;
try
    A = arrayfun(f,A);
    data(:,2)= A;
catch ME
    A = str2num(cell2mat(A));
    A = arrayfun(f,A);
    A = cellstr(num2str(A));
    data(:,2)= A;
end 
set(handles.uitable4, 'data',data);
Plot_Callback(handles.Plot, eventdata,handles);

%-------------- LAUFLINIE NACH LINKS VERSCHIEBEN---------------------------
function X_links_verschieben_Callback(hObject, eventdata, handles)
Verschiebung_Schritt=get(handles.X_Achse_verschieben,'String');
epsilon = str2num(Verschiebung_Schritt);
data=get(handles.uitable4, 'data'); 
A=data(:,1);
f = @(x) x - epsilon;
try
    A = arrayfun(f,A);
    data(:,1)= A;
catch ME
    A = str2num(cell2mat(A));
    A = arrayfun(f,A);
    A = cellstr(num2str(A));
    data(:,1)= A;
end 
set(handles.uitable4, 'data',data);
Plot_Callback(handles.Plot, eventdata,handles);

%-------------- LAUFLINIE NACH RECHTS VERSCHIEBEN--------------------------
function X_rechts_verschieben_Callback(hObject, eventdata, handles)

Verschiebung_Schritt=get(handles.X_Achse_verschieben,'String');
epsilon = str2num(Verschiebung_Schritt);
data=get(handles.uitable4, 'data'); 
A=data(:,1);
f = @(x) x + epsilon;
try
    A = arrayfun(f,A);
    data(:,1)= A;
catch ME
    A = str2num(cell2mat(A));
    A = arrayfun(f,A);
    A = cellstr(num2str(A));
    data(:,1)= A;
end  
set(handles.uitable4, 'data',data);
Plot_Callback(handles.Plot, eventdata,handles);

%-------------- LAUFLINIE NACH UNTEN VERSCHIEBEN---------------------------
function Y_unten_verschieben_Callback(hObject, eventdata, handles)

Verschiebung_Schritt=get(handles.X_Achse_verschieben,'String');
epsilon = str2num(Verschiebung_Schritt);
data=get(handles.uitable4, 'data'); 
A=data(:,2);
f = @(x) x - epsilon;
try
    A = arrayfun(f,A);
    data(:,2)= A;
catch ME
    A = str2num(cell2mat(A));
    A = arrayfun(f,A);
    A = cellstr(num2str(A));
    data(:,2)= A;
end 
set(handles.uitable4, 'data',data);
Plot_Callback(handles.Plot, eventdata,handles);


%-------------- ZEILE EINF�GEN STUFEN TABELLE LANGE SEITE -----------------
data1=get(handles.uitable9, 'data'); 
data2=get(handles.uitable10, 'data');
Gesamt_ver_Stufen = getappdata(0, 'Gesamt_ver_Stufen'); %n-verz
stufen_anzahl = getappdata(0, 'stufen_anzahl');
auftrittsbreite = getappdata(0, 'auftrittsbreite');
nicht_verzogen = (stufen_anzahl -Gesamt_ver_Stufen) * auftrittsbreite; %Laufl�nge nicht verzogen 
Nzahl_stufen_NV = floor(nicht_verzogen/auftrittsbreite); % Anzahl nicht verzogene stufen lange seite in der tabelle
Anzal_stufen_tabelle = length(data1(:,1))+length(data2(:,1)) % Anzahl verzogene stufen Kurze/lane seite in der tabelle
Erlaubte_stufenTabelle= stufen_anzahl - Nzahl_stufen_NV -1

if (Anzal_stufen_tabelle >= Erlaubte_stufenTabelle) %&& (~ isempty(data1(:,1))) && (~isempty(data2(:,1)))
    
    msgbox(sprintf('Achten sie darauf, dass die gesamten Stufen in der Tabele kleine oder gleich %g ist',Erlaubte_stufenTabelle),'Achtung')
else
    try
     data2(end+1,:)= {''}; 
    catch ME
     data2(end+1,:)= (0); 
    end
set(handles.uitable10, 'data', data2);
end


%-------------- ZEILE L�SCHEN STUFEN TABELLE LANGE SEITE -----------------

function pushbutton49_Callback(hObject, eventdata, handles)
data=get(handles.uitable10, 'data'); 
data(end,:)=[]; 
set(handles.uitable10, 'data', data);

%-------------- ZEILE EINF�GEN STUFEN TABELLE lange SEITE -----------------
function pushbutton50_Callback(hObject, eventdata, handles)

data1=get(handles.uitable9, 'data'); 
data2=get(handles.uitable10, 'data');
Gesamt_ver_Stufen = getappdata(0, 'Gesamt_ver_Stufen'); %n-verz
stufen_anzahl = getappdata(0, 'stufen_anzahl');
auftrittsbreite = getappdata(0, 'auftrittsbreite');
nicht_verzogen = (stufen_anzahl -Gesamt_ver_Stufen) * auftrittsbreite; %Laufl�nge nicht verzogen 
Nzahl_stufen_NV = floor(nicht_verzogen/auftrittsbreite); % Anzahl nicht verzogene stufen lange seite in der tabelle
Anzal_stufen_tabelle = length(data1(:,1))+length(data2(:,1)) % Anzahl verzogene stufen Kurze/lane seite in der tabelle
Erlaubte_stufenTabelle= stufen_anzahl - Nzahl_stufen_NV -1

if (Anzal_stufen_tabelle >= Erlaubte_stufenTabelle) %&& (~ isempty(length(data1(:,1))+length(data2(:,2))))
    
    msgbox(sprintf('Achten sie darauf, dass die gesamten Stufen in der Tabele kleine oder gleich %g ist',Erlaubte_stufenTabelle),'Achtung')
    
else
    try
       data1(end+1,:)= {''}; 
    catch ME
       data1(end+1,:)= (0); 
    end
set(handles.uitable9, 'data', data1);
end

%-------------- ZEILE L�SCHEN STUFEN TABELLE KURZE SEITE -----------------
function pushbutton51_Callback(hObject, eventdata, handles)
data=get(handles.uitable9, 'data'); 
data(end,:)=[]; 
set(handles.uitable9, 'data', data);
set(handles.uipanel3,'visible','on');


%-------------- ZEILE EINF�GEN STUFEN TABELLE KURZE SEITE -----------------
function pushbutton48_Callback(hObject, eventdata, handles)
 
data1=get(handles.uitable9, 'data'); 
data2=get(handles.uitable10, 'data');
Gesamt_ver_Stufen = getappdata(0, 'Gesamt_ver_Stufen'); %n-verz
stufen_anzahl = getappdata(0, 'stufen_anzahl');
auftrittsbreite = getappdata(0, 'auftrittsbreite');
nicht_verzogen = (stufen_anzahl -Gesamt_ver_Stufen) * auftrittsbreite; %Laufl�nge nicht verzogen 
Nzahl_stufen_NV = floor(nicht_verzogen/auftrittsbreite); % Anzahl nicht verzogene stufen lange seite in der tabelle
Anzal_stufen_tabelle = length(data1(:,1))+length(data2(:,1)) % Anzahl verzogene stufen Kurze/lane seite in der tabelle
Erlaubte_stufenTabelle= stufen_anzahl - Nzahl_stufen_NV -1
 
if (Anzal_stufen_tabelle >= Erlaubte_stufenTabelle) %&& (~ isempty(data1(:,1))) && (~isempty(data2(:,1)))
    
    msgbox(sprintf('Achten sie darauf, dass die gesamten Stufen in der Tabele kleine oder gleich %g ist',Erlaubte_stufenTabelle),'Achtung')
else
    try
     data2(end+1,:)= {''}; 
    catch ME
     data2(end+1,:)= (0); 
    end
set(handles.uitable10, 'data', data2);
end




%################## NICHT VERWENDETE FUNKTIONEN (aber nicht l�schen ge ;) )############################
function pushbutton_RESET_Callback(hObject, eventdata, handles)
function Plot_DeleteFcn(hObject, eventdata, handles)

function Stufen_Position_Nummer_Callback(hObject, eventdata, handles)
function Aussenabstand_Callback(hObject, eventdata, handles)
function LL_Pos_Callback(hObject, eventdata, handles)
function pushbutton3_Callback(hObject, eventdata, handles)
function pushbutton8_Callback(hObject, eventdata, handles)
function pushbutton9_Callback(hObject, eventdata, handles)
% --- Executes when uipanel1 is resized.
function uipanel1_SizeChangedFcn(hObject, eventdata, handles)
% --- Executes on button press in pushbutton43.
function pushbutton43_Callback(hObject, eventdata, handles)
% --- Executes during object creation, after setting all properties.
function axes2_CreateFcn(hObject, eventdata, handles)
% --- Executes on button press in pushbutton44.
function pushbutton44_Callback(hObject, eventdata, handles)
% --- Executes during object creation, after setting all properties.
function uitable4_CreateFcn(hObject, eventdata, handles)
function varargout = Konfigurator_OutputFcn(hObject, eventdata, handles) 

varargout{1} = handles.output;

function Laenge_nicht_ver_edit_Callback(hObject, eventdata, handles)

function Laenge_nicht_ver_edit_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function Laenge_radius_L_edit_Callback(hObject, eventdata, handles)
function Laenge_radius_L_edit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function Laenge_Ver_L_edit_Callback(hObject, eventdata, handles)
function Laenge_Ver_L_edit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function Halbe_lichte_edit_Callback(hObject, eventdata, handles)
function Halbe_lichte_edit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function pushbutton11_Callback(hObject, eventdata, handles)
function Innenabstand_Callback(hObject, eventdata, handles)
% --- Executes on button press in pushbutton_Fahrt_Start.

function Y_Achse_verschieben_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function Y_Achse_verschieben_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object deletion, before destroying properties.
function uitable4_DeleteFcn(hObject, eventdata, handles)
function X_Achse_verschieben_Callback(hObject, eventdata, handles)

function X_Achse_verschieben_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
    
function edit10_Callback(hObject, eventdata, handles)

function edit10_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit11_Callback(hObject, eventdata, handles)

function edit11_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit12_Callback(hObject, eventdata, handles)

function edit12_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit13_Callback(hObject, eventdata, handles)

function edit13_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit14_Callback(hObject, eventdata, handles)

function edit14_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit15_Callback(hObject, eventdata, handles)

function edit15_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit16_Callback(hObject, eventdata, handles)

function edit16_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function pushbutton21_Callback(hObject, eventdata, handles)

function pushbutton_RESET_CreateFcn(hObject, eventdata, handles)

function pushbutton21_CreateFcn(hObject, eventdata, handles)

function Plot_CreateFcn(hObject, eventdata, handles)

function edit23_Callback(hObject, eventdata, handles)
function edit23_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit24_Callback(hObject, eventdata, handles)
function edit24_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit25_Callback(hObject, eventdata, handles)
function edit25_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit26_Callback(hObject, eventdata, handles)
function edit26_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit27_Callback(hObject, eventdata, handles)
function edit27_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function H_Breite_Callback(hObject, eventdata, handles)
function H_Breite_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function H_Laenge_Callback(hObject, eventdata, handles)

function H_Laenge_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function R_Breite_Callback(hObject, eventdata, handles)
function R_Breite_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function R_Laenge_Callback(hObject, eventdata, handles)
function R_Laenge_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function pos_1_Callback(hObject, eventdata, handles)
function pos_1_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function Pos_2_Callback(hObject, eventdata, handles)
function Pos_2_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function Abstand_Callback(hObject, eventdata, handles)
function Abstand_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit35_Callback(hObject, eventdata, handles)
function edit35_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit36_Callback(hObject, eventdata, handles)
function edit36_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function Stufen_Position_Nummer_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
% --- Executes during object creation, after setting all properties.
function LL_Pos_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
% --- Executes during object creation, after setting all properties.
function Aussenabstand_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
% --- Executes during object creation, after setting all properties.
function Innenabstand_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
% --- Executes during object creation, after setting all properties.
function pushbutton_Zurueck_CreateFcn(hObject, eventdata, handles)
% --- Executes on button press in pushbutton13.
function pushbutton13_Callback(hObject, eventdata, handles)

function pushbutton_Clear_data1_CreateFcn(hObject, eventdata, handles)
function listbox2_Callback(hObject, eventdata, handles)
function listbox2_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function pushbutton19_Callback(hObject, eventdata, handles)
function edit9_Callback(hObject, eventdata, handles)
function edit9_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%#########################################################################
