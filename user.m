function varargout = user(varargin)
% USER MATLAB code for user.fig
%      USER, by itself, creates a new USER or raises the existing
%      singleton*.
%
%      H = USER returns the handle to a new USER or the handle to
%      the existing singleton*.
%
%      USER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in USER.M with the given input arguments.
%
%      USER('Property','Value',...) creates a new USER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before user_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to user_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help user

% Last Modified by GUIDE v2.5 17-Jun-2021 17:05:55

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @user_OpeningFcn, ...
                   'gui_OutputFcn',  @user_OutputFcn, ...
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


% --- Executes just before user is made visible.
function user_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to user (see VARARGIN)
global img_present;
img_present = false;
% Choose default command line output for user
handles.output = hObject;
resetaxis(handles);

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes user wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = user_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global P;
global grado;
global clamped;


set(handles.esc_text, 'visible','on');

set(handles.pushbutton1 , 'enable', 'off');
set(handles.loadimage , 'enable', 'off');
set(handles.reset_button , 'enable', 'off');
set(handles.bspline_butt , 'enable', 'off');


[P,n]=Selezione_Punti(handles);                                             %viene richiamata la funzione per selezionare i punti di controllo
grado = str2double(get(handles.grado, 'String'));                           %lettura del grado inserito dall'utente
clamped = get(handles.clamped, 'Value');

set(handles.esc_text, 'visible','off');
                                                                            %verifica che il grado della curva sia un numero intero non negativo
set(handles.errori, 'String', 'Il grado deve essere un intero positivo');
validateattributes(grado, {'numeric'}, {'nonnegative','integer','scalar'});

set(handles.errori, 'String', ' ');

set(handles.pushbutton1 , 'enable', 'on');
set(handles.loadimage , 'enable', 'on');
set(handles.reset_button , 'enable', 'on');
set(handles.bspline_butt , 'enable', 'on');


set(handles.panelvalue , 'visible', 'on');

set(handles.numpuntic_text , 'visible', 'on');
set(handles.numpuntic , 'visible', 'on');

set(handles.numpesi_text , 'visible', 'on');
set(handles.numpesi , 'visible', 'on');

set(handles.numnodi_text, 'visible', 'on');
set(handles.numnodi, 'visible', 'on');

set(handles.pesi , 'visible', 'on');
set(handles.pesi, 'string', num2str(10*rand(size(P, 2), 1)'));
set(handles.nodi, 'visible', 'on');

if clamped
    set(handles.nodi, 'string', num2str([zeros(grado + 1, 1)' sort(rand(size(P, 2) - grado - 1, 1))' ones(grado + 1, 1)']));
else
    set(handles.nodi, 'string', num2str(sort(rand(size(P, 2) + grado + 1, 1))'));
end


% Numero pesi da inserire

numpesi_real = n;
set(handles.numpesi, 'String', numpesi_real);

numnodi_real = n + grado +1;                                                %calcolo il numero corretto di nodi che deve essere inserito
set(handles.numnodi, 'String',numnodi_real);

% --- Executes on button press in loadimage.
function loadimage_Callback(hObject, eventdata, handles)
% hObject    handle to loadimage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global IMG;
global img_present;
[file, path]=uigetfile('*.*');                                              %apre finestra selezione immagine 
nome_img=[path file];                         
set(handles.errori, 'String', 'Errore nel caricamento immagine');
IMG = imread(nome_img);                                                     %legge l'immagine
img_present = true;
set(handles.errori, 'String', ' ');
axes(handles.axes1);                                                        %importa l'immagine sull'asse 1
hold off;
imshow(IMG);                                                                %mostra l'immagine
grid on;
axis on;
hold on;

axes(handles.axes2);                                                        %importa l'immagine sull'asse 2
hold off;
imshow(IMG);                                                                %mostra l'immagine
grid on;
axis on;
hold on;


% --- Executes on button press in bspline_butt.
function bspline_butt_Callback(hObject, eventdata, handles)
% hObject    handle to bspline_butt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global P;
global grado;
global IMG;
global img_present;
global pthold;
global bson;
global nbson;

bson=get(handles.bscheck, 'Value');
nbson=get(handles.nbscheck, 'Value');

t = str2num(get(handles.nodi, 'String'));                                   %vettore dei nodi inserito dall'utente
w = str2num(get(handles.pesi, 'String'));

resetaxis(handles);

    axes(handles.axes1);
    cla reset;

    if(img_present)
        imshow(IMG);
    end
if(nbson)
    DeBoor_NURBS(P,grado,t,w,handles);


    pthold=get(handles.pointholder, 'Value');                               %in base al checkbox stampa anche i punti 

    if pthold
        plot(P(1,:),P(2,:),'ob');                                           %stampa esclusivamente i punti di controllo
    end

    axes(handles.axes3);
    cla reset;

    grid on;
    axis on;
    hold on;
    N = B_Spline_N(grado, t, size(P, 2));                                   %calcola le funzioni base B-Spline
    


    
    R = NURBS_R(N, w);
    for j = 1 : size(P, 2)                                                  %disegna le funzioni di base sull'asse 3
        plot(handles. axes3, linspace(1, 9, 10*size(P, 2)), R(:, j), 'LineWidth',2);
        legendInfo{j} = strcat('$R_{', num2str(j), ',' ,num2str(grado),'}(u)$');
    end

    if(size(legendInfo) < 8)
        legend(legendInfo, 'interpreter', 'latex', 'location', 'best');
    else
         legend(legendInfo(1:8), 'interpreter', 'latex', 'location', 'best');
        
    end
else
    cla reset;
    grid on;
    axis on;
    hold on;
end


% SECONDA FUNZIONE (B-SPLINE)

axes(handles.axes2);
cla reset;
axes(handles.axes2);
cla reset;

if(img_present)
    imshow(IMG);
end

if(bson)

       DeBoor(P,grado,t,handles);
    if pthold
        plot(P(1,:),P(2,:),'ob');
    end

    axes(handles.axes4);
    cla reset;
    grid on;
    axis on;
    hold on;
    N = B_Spline_N(grado, t, size(P, 2));
    for j = 1 : size(P, 2)                                                  %disegna tutte le funzioni di base
        plot(handles. axes4, linspace(1, 9, 10*size(P, 2)), N(:, j), 'LineWidth',2);
        legendInfo{j} = strcat('$N_{', num2str(j), ',' ,num2str(grado),'}(u)$');
    end
    if(size(legendInfo) < 8)
        legend(legendInfo, 'interpreter', 'latex', 'location', 'best');
    else
        legend(legendInfo(1:8), 'interpreter', 'latex', 'location', 'best');    
    end
else
    cla reset;
    grid on;
    axis on;
    hold on;
end


% --- Executes on button press in reset_button.
function reset_button_Callback(hObject, eventdata, handles)
% hObject    handle to reset_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global img_present;
img_present = false; 

resetaxis(handles);                                                         %reset degli assi: viene gestito da una funzione esterna
                                                                            %per garantire il riuso.

%----------------------------------
% setto tutto a 0
set(handles.numpuntic, 'String', '0');
set(handles.numpesi, 'String', '0');
set(handles.pesi, 'String', '0');
set(handles.numnodi, 'String', '0');
set(handles.nodi, 'String', '0');
%-----------------------------------

% --- Executes on button press in bscheck.
function bscheck_Callback(hObject, eventdata, handles)
% hObject    handle to bscheck (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if(~(get(handles.bscheck, 'Value')))
    axes(handles.axes2);
    cla reset;
    grid on;
    axis on;
    hold on;
    axis([0 100 0 100]);
    
    axes(handles.axes4);
    cla reset;
    grid on;
    axis on;
    hold on;
    axis([0 100 0 100]);
end

% Hint: get(hObject,'Value') returns toggle state of bscheck

% --- Executes on button press in nbscheck.
function nbscheck_Callback(hObject, eventdata, handles)
% hObject    handle to nbscheck (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if(~(get(handles.nbscheck, 'Value')))
    axes(handles.axes1);
    cla reset;
    grid on;
    axis on;
    hold on;
    axis([0 100 0 100]);
    
    axes(handles.axes3);
    cla reset;
    grid on;
    axis on;
    hold on;
    axis([0 100 0 100]);
end




%--------------------------------------------------------------------------
% CALLBACK NON UTILIZZATE
%--------------------------------------------------------------------------

% --- Executes on button press in pointholder.
function pointholder_Callback(hObject, eventdata, handles)
% hObject    handle to pointholder (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of pointholder

% --- Executes on button press in buttonKnot.
function buttonKnot_Callback(hObject, eventdata, handles)
% hObject    handle to buttonKnot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)




function nodo_Callback(hObject, eventdata, handles)
% hObject    handle to nodo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: get(hObject,'String') returns contents of nodo as text
%        str2double(get(hObject,'String')) returns contents of nodo as a double
% --- Executes during object creation, after setting all properties.

function nodo_CreateFcn(hObject, eventdata, handles)
% hObject    handle to nodo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes on button press in clamped.
function clamped_Callback(hObject, eventdata, handles)
% hObject    handle to clamped (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of clamped



function pesi_Callback(hObject, eventdata, handles)
% hObject    handle to pesi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of pesi as text
%        str2double(get(hObject,'String')) returns contents of pesi as a double




function numpuntic_Callback(hObject, eventdata, handles)
% hObject    handle to numpuntic (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of numpuntic as text
%        str2double(get(hObject,'String')) returns contents of numpuntic as a double


% --- Executes during object creation, after setting all properties.
function numpuntic_CreateFcn(hObject, eventdata, handles)
% hObject    handle to numpuntic (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function numpesi_Callback(hObject, eventdata, handles)
% hObject    handle to numpesi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of numpesi as text
%        str2double(get(hObject,'String')) returns contents of numpesi as a double


% --- Executes during object creation, after setting all properties.
function numpesi_CreateFcn(hObject, eventdata, handles)
% hObject    handle to numpesi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function numnodi_Callback(hObject, eventdata, handles)
% hObject    handle to numnodi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of numnodi as text
%        str2double(get(hObject,'String')) returns contents of numnodi as a double


% --- Executes during object creation, after setting all properties.
function numnodi_CreateFcn(hObject, eventdata, handles)
% hObject    handle to numnodi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function nodi_Callback(hObject, eventdata, handles)
% hObject    handle to nodi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of nodi as text
%        str2double(get(hObject,'String')) returns contents of nodi as a double


% --- Executes during object creation, after setting all properties.
function nodi_CreateFcn(hObject, eventdata, handles)
% hObject    handle to nodi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
% --- Executes during object creation, after setting all properties.
function pesi_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pesi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




function grado_Callback(hObject, eventdata, handles)
% hObject    handle to grado (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of grado as text
%        str2double(get(hObject,'String')) returns contents of grado as a double


% --- Executes during object creation, after setting all properties.
function grado_CreateFcn(hObject, eventdata, handles)
% hObject    handle to grado (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
