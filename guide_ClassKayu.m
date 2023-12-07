function varargout = guide_ClassKayu(varargin)
% GUIDE_CLASSKAYU MATLAB code for guide_ClassKayu.fig
%      GUIDE_CLASSKAYU, by itself, creates a new GUIDE_CLASSKAYU or raises the existing
%      singleton*.
%
%      H = GUIDE_CLASSKAYU returns the handle to a new GUIDE_CLASSKAYU or the handle to
%      the existing singleton*.
%
%      GUIDE_CLASSKAYU('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUIDE_CLASSKAYU.M with the given input arguments.
%
%      GUIDE_CLASSKAYU('Property','Value',...) creates a new GUIDE_CLASSKAYU or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before guide_ClassKayu_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to guide_ClassKayu_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help guide_ClassKayu

% Last Modified by GUIDE v2.5 03-Oct-2022 23:47:28

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @guide_ClassKayu_OpeningFcn, ...
                   'gui_OutputFcn',  @guide_ClassKayu_OutputFcn, ...
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


% --- Executes just before guide_ClassKayu is made visible.
function guide_ClassKayu_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to guide_ClassKayu (see VARARGIN)

% Choose default command line output for guide_ClassKayu
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
movegui(hObject, 'center');

% UIWAIT makes guide_ClassKayu wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = guide_ClassKayu_OutputFcn(hObject, eventdata, handles) 
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

% menampilkan menu browse image
[nama_file, nama_folder] = uigetfile('*.jpg');

% jika ada nama file yang diplih maka akan mengeksekusi perintah dibawah
% ini

if ~isequal(nama_file,0)
    % membaca file citra rgb
    Img = imread(fullfile(nama_folder,nama_file));
    %menampilkan citra rgb pada axes 1
    axes(handles.axes1)
    imshow(Img)
    title('RGB Image')
    % menyimpan variable img pada lokasi handles agar dapat dipanggil oleh
    % pushbutton yang lain
    handles.Img = Img;
    guidata(hObject, handles)
else
    %jika tidak ada nama file yang dipilih maka akan kembali
    return
end


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

axes(handles.axes1)
cla reset
set(gca,'XTick',[])
set(gca,'YTick',[])

axes(handles.axes2)
cla reset
set(gca,'XTick',[])
set(gca,'YTick',[])

%set(handles.uitable1,'Data',[])
set(handles.edit6,'String',' ')
set(handles.edit7,'String',' ')
set(handles.edit8,'String',' ')
set(handles.edit9,'String',' ')
set(handles.edit10,'String',' ')


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    % memanggil variable Img yang ada di lokasi handles
    Img = handles.Img;

    % conversi rgb to gray
    gray = rgb2gray(Img);
    Img_gray = imsharpen(gray);
    
    %menampilkan citra grayscale pada axes
    axes(handles.axes2)
    imshow(Img_gray)
    title('Grayscale Image')
    
    %ekstraksi ciri GLCM
    pixel_dist = 1; %jarak antar filter
    
    % membentuk matriks konkurensi
    GLCM = graycomatrix(Img_gray,'Offset',[0 pixel_dist;...
        -pixel_dist pixel_dist; -pixel_dist 0; -pixel_dist -pixel_dist]);

    %mengekstrak fitur GLCM
    stats = graycoprops(GLCM,{'Contrast','Correlation','Energy','Homogeneity'});

    contrast = mean(stats.Contrast);
    correlation = mean(stats.Correlation);
    energy = mean(stats.Energy);
    homogeneity = mean(stats.Homogeneity);
    
    set(handles.edit6,'String',contrast);
    set(handles.edit7,'String',correlation);
    set(handles.edit8,'String',energy);
    set(handles.edit9,'String',homogeneity);
    
    % menyusun variable data_uji
    data_uji(1,1) = contrast;
    data_uji(1,2) = correlation;
    data_uji(1,3) = energy;
    data_uji(1,4) = homogeneity;
    
    %MEMANGGIL MODEL SVM HASIL PELATIHAN
    load Mdl

    %membaaca kelas keluaran hasil pengujian
    kelas_keluaran = predict(Mdl, data_uji);
    set(handles.edit10,'String',kelas_keluaran);



function edit6_Callback(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit6 as text
%        str2double(get(hObject,'String')) returns contents of edit6 as a double


% --- Executes during object creation, after setting all properties.
function edit6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit7_Callback(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit7 as text
%        str2double(get(hObject,'String')) returns contents of edit7 as a double


% --- Executes during object creation, after setting all properties.
function edit7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit8_Callback(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit8 as text
%        str2double(get(hObject,'String')) returns contents of edit8 as a double


% --- Executes during object creation, after setting all properties.
function edit8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit9_Callback(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit9 as text
%        str2double(get(hObject,'String')) returns contents of edit9 as a double


% --- Executes during object creation, after setting all properties.
function edit9_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit10_Callback(hObject, eventdata, handles)
% hObject    handle to edit10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit10 as text
%        str2double(get(hObject,'String')) returns contents of edit10 as a double


% --- Executes during object creation, after setting all properties.
function edit10_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
