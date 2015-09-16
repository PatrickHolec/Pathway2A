%% Welcome to Pathway2A! A friendly interface to figure out how to design your eukaryotic 2A pathway
% Eukaryotic species offer many advantages for enzymatic expression over
% their prokaryotic counterparts. One major disadvantage however is the
% inability to keep multiple genes/enzymes under the same promoter. 2A
% tags are short (20 a.a.) amino acid sequences that self cleave upon exit
% from the ribosome. By alternating gene DNA sequence and 2A tag, you can
% produce multiple enzymes governed by the same promoter.

% The caveot to this technology is you get some decreased expression after
% each 2A tag. The extent of decreased expression has not been quantified,
% but we can loosely estimate this to be 20% decreased in expression, but
% is obviously something to quantify as time permits.

% We can attempt to compensate for decreased expression downstream by
% rearranging the genes to place rate limiting steps upstream and non-rate
% limiting steps downstream.

% So to use this tool, you need to:

% 1. Execute script
% 2. Select the number of enzymes in your biochemical pathway
% 3. Fill in expected kcat/km values
% 4. (Optional) Change the production ratio (between 0 and 1) 
% 5. Simulate!

% You will see your optimized concentration of biochemical species over
% time, the priority for enzyme ordering (priority = 1 refers to 1st gene
% after promoter, priority = 2 refers to 2nd, etc), and a video of the
% speciies in your system over time.

% If you have comments, questions, or want to talk about something
% interesting, please contact:
%
% Patrick V. Holec
% hole0077@umn.edu
% University of Minnesota

%% GUI Code
%
% Most of the action occurs in the "pushbutton1_Callback" function
% Additionally, there is a "GUI_Update" function to update any boxes upon switching enzyme selection or pathway size
%

function varargout = Pathway2A(varargin)
% PATHWAY2A MATLAB code for Pathway2A.fig
%      PATHWAY2A, by itself, creates a new PATHWAY2A or raises the existing
%      singleton*.
%
%      H = PATHWAY2A returns the handle to a new PATHWAY2A or the handle to
%      the existing singleton*.
%
%      PATHWAY2A('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PATHWAY2A.M with the given input arguments.
%
%      PATHWAY2A('Property','Value',...) creates a new PATHWAY2A or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Pathway2A_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Pathway2A_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Pathway2A

% Last Modified by GUIDE v2.5 14-Sep-2015 13:45:02

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Pathway2A_OpeningFcn, ...
                   'gui_OutputFcn',  @Pathway2A_OutputFcn, ...
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


% --- Executes just before Pathway2A is made visible.
function Pathway2A_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Pathway2A (see VARARGIN)

% Preassignment of variables
max_enzymes = 8;

handles.current = 1;

handles.enzyme_count = 1;
handles.letters = {'A','B','C','D','E','F','G','H','I'};
handles.kcat = randi([10,100],1,max_enzymes);
handles.km = randi([10,100],1,max_enzymes);
handles.prod = 1*(0.8).^(0:(max_enzymes-1));

handles.kcat_order = ones(1,max_enzymes);
handles.km_order = ones(1,max_enzymes);

% Choose default command line output for Pathway2A
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
GUI_Update(handles);

% UIWAIT makes Pathway2A wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Pathway2A_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in listbox1.
function listbox1_Callback(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox1
handles.current = get(handles.listbox1,'value');
GUI_Update(handles)
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function listbox1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1
handles.enzyme_count = get(handles.popupmenu1,'Value');
if handles.current > handles.enzyme_count
    handles.current = handles.enzyme_count;
    set(handles.listbox1,'Value',handles.current)
end
names = cell(1,handles.enzyme_count);
for i = 1:handles.enzyme_count
    names{i} = horzcat('Enzyme ',handles.letters{i});
end
set(handles.listbox1,'String',names)
guidata(hObject,handles);



% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double
handles.kcat(handles.current) = str2double(get(handles.edit1,'String'));
guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double
handles.km(handles.current) = str2double(get(handles.edit2,'String'));
guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu2.
function popupmenu2_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu2
handles.kcat_order(handles.current) = get(handles.popupmenu2,'Value');
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function popupmenu2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu3.
function popupmenu3_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu3 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu3
handles.km_order(handles.current) = get(handles.popupmenu3,'Value');
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function popupmenu3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double
handles.prod(handles.current) = str2double(get(handles.edit3,'String'));
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, data)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

data.PROD = data.prod(1:data.enzyme_count);
data.PROD = 1e-3*(sort(data.PROD,'descend'));
disp(data.PROD)

data.KCAT = zeros(1,data.enzyme_count);
data.KM = zeros(1,data.enzyme_count);

for i = 1:data.enzyme_count
    data.KCAT(i) = data.kcat(i)*(10^(-3*(data.kcat_order(i)-1)));
    data.KM(i) = data.km(i)*(10^(-3*(data.km_order(i)-1)));
end

species_names = cell(1,data.enzyme_count+1);
enzyme_names = cell(1,data.enzyme_count);

for i = 1:data.enzyme_count+1
    species_names{i} = horzcat('Species ',data.letters{i});
end

for i = 1:data.enzyme_count
    enzyme_names{i} = horzcat('Enzyme ',data.letters{i});
end

startconc = 1e-6; % Starting concentration of substrate in cell
threshold = 0.90; % Threshold for reaction completion

prod = data.PROD;
kcat = data.KCAT;
km = data.KM;
count = data.enzyme_count;

priority = 1:count;
perm_priority = perms(priority);
perm_prod = prod(perm_priority);
results = [];

t_res = 1000;
top = 1000; done = 0;

while done ~= 4
    for i = 1:size(perm_prod,1)
        x0 = zeros(1,count + 1);
        x0(1) = startconc;
        tspan=0:top/t_res:top;
        p = {count,perm_prod(i,:),kcat,km};
        [t,x]=ode23s(@lorenz1,tspan,x0,[],p);
        results(i) = t(sum(x(:,end)<threshold*startconc));
    end
    if min(results) == top
        top = 10*top;
        disp('Raising time scale...');
    elseif histc(results,min(results)) > 1
        if min(results) <= top/t_res
            top = top/10;
            disp('Lowering time scale...');
        else
            t_res = 2*t_res;
            done = done + 1;
            disp('Adding resolution...');
        end
    else
        done = 4;
    end
end 
disp('Solution found!');

p = {count,perm_prod(results == min(results),:),kcat,km};
[t,x]=ode23s(@lorenz1,tspan,x0,[],p);
cla();
plot(data.axes6,t,x);
ylim(data.axes6,[0 startconc]);
legend(data.axes6,species_names);
title(data.axes6,'Biochemical Production');
xlabel(data.axes6,'Time (seconds)');
ylabel(data.axes6,'Abundance (Molarity)');

sol = perm_priority(results == min(results),:);
sol = sol(1,:);

cla();
bar(data.axes8,1:length(sol),sol);
title(data.axes8,horzcat('Potential Efficency Improvement: ',num2str(100*(max(results)-min(results))/min(results)),' %'));
ylabel(data.axes8,'Priority/Order');
set(data.axes8, 'XTick', 1:count, 'XTickLabel', enzyme_names,'FontSize',10);

bar(data.axes1,[1:count+1],x(1,:));
title(data.axes1,horzcat('Simulation at ',num2str(t(i)), ' seconds'),'FontSize',16)
ylim(data.axes1,[0 1e-6]);
ylabel(data.axes1,'Concentration (Molarity)','FontSize',12);
set(data.axes1, 'XTick', 1:count, 'XTickLabel', enzyme_names,'FontSize',10);

axis tight;
set(gca,'nextplot','replacechildren');
set(gcf,'renderer','painters')

for i = 1:5:length(t)
    pause(1/100)
    bar(data.axes1,[1:count+1],x(i,:));
    title(data.axes1,horzcat('Simulation at ',num2str(t(i)), ' seconds'),'FontSize',16)
    ylim(data.axes1,[0 1e-6]);
    ylabel(data.axes1,'Concentration (Molarity)','FontSize',12);
    set(data.axes1, 'XTick', 1:count+1, 'XTickLabel', enzyme_names,'FontSize',10);
    refresh;
end

guidata(hObject,data);



% --- Executes on button press in radiobutton1.
function radiobutton1_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton1


function GUI_Update(handles)
set(handles.edit1,'String',num2str(handles.kcat(handles.current)));
set(handles.edit2,'String',num2str(handles.km(handles.current)));
set(handles.edit3,'String',num2str(handles.prod(handles.current)));
set(handles.popupmenu2,'Value',handles.kcat_order(handles.current));
set(handles.popupmenu3,'Value',handles.km_order(handles.current));

function xprime = lorenz1(t,x,p)
%LORENZ: Computes the derivatives involved in solving the
%Lorenz equations.
xprime = zeros(p{1} + 1,1);

xprime(1) = -p{2}(1)*p{3}(1)*x(1)/(x(1)+p{4}(1));
for i = 2:p{1}
    xprime(i) = (p{2}(i-1)*p{3}(i-1)*x(i-1)/(x(i-1)+p{4}(i-1))) - (p{2}(i)*p{3}(i)*x(i)/(x(i)+p{4}(i)));
end
xprime(end) = p{2}(p{1})*p{3}(p{1})*x(p{1})/(x(p{1})+p{4}(p{1}));
