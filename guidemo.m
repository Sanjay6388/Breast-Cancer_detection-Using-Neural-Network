function varargout = guidemo(varargin)
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @guidemo_OpeningFcn, ...
                   'gui_OutputFcn',  @guidemo_OutputFcn, ...
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

function guidemo_OpeningFcn(hObject, ~, handles, varargin)

handles.output = hObject;
guidata(hObject, handles);

function varargout = guidemo_OutputFcn(~, ~, handles) 

varargout{1} = handles.output;

function Browse_Callback(hObject, ~, handles)
    [filename, pathname] = uigetfile('*.jpg', 'Pick a Image');
    if isequal(filename,0) || isequal(pathname,0)
       warndlg('User pressed cancel')
    else
    filename=strcat(pathname,filename);
    InputImage=imread(filename);    
    axes(handles.axes1);
    imshow(InputImage);    
    handles.InputImage=InputImage;
    end
guidata(hObject, handles);

function AdaptiveMedianFilter_Callback(hObject, ~, handles)
        InputImage=handles.InputImage;
        GrayScaleImage=rgb2gray(InputImage);               
        NoisyImage=GrayScaleImage;
        NoisyImage=double(GrayScaleImage);
        [R, C, ~]=size(NoisyImage);
        OutImage=zeros(R,C);
        Zmin=[];
        Zmax=[];
        Zmed=[];
        for i=1:R        
            for j=1:C
                       if (i==1 && j==1)
                 
                        elseif (i==1 && j==C)
                   
                        elseif (i==R && j==1)
                        elseif (i==R && j==C)
                        elseif (i==1)
                        elseif (i==R)
                        elseif (j==C)
                        elseif (j==1)
                       else
                                    SR1 = NoisyImage((i-1),(j-1));
                                     SR2 = NoisyImage((i-1),(j));
                                     SR3 = NoisyImage((i-1),(j+1));
                                     SR4 = NoisyImage((i),(j-1));
                                     SR5 = NoisyImage(i,j);
                                     SR6 = NoisyImage((i),(j+1));
                                     SR7 = NoisyImage((i+1),(j-1));
                                     SR8 = NoisyImage((i+1),(j));
                                     SR9 = NoisyImage((i+1));((j+1));
                                     TempPixel=[SR1,SR2,SR3,SR4,SR5,SR6,SR7,SR8,SR9];
                                     Zxy=NoisyImage(i,j);
                                     Zmin=min(TempPixel);
                                     Zmax=max(TempPixel);
                                     Zmed=median(TempPixel);
                                     A1 = Zmed - Zmin;
                                     A2 = Zmed - Zmax;
                                     if A1 > 0 && A2 < 0
                                          %   go to level B
                                          B1 = Zxy - Zmin;
                                          B2 = Zxy - Zmax;
                                          if B1 > 0 && B2 < 0
                                              PreProcessedImage(i,j)= Zxy;
                                          else
                                              PreProcessedImage(i,j)= Zmed;
                                          end
                                     else
                                         if ((R > 4 && R < R-5) && (C > 4 && C < C-5))
                                         S1 = NoisyImage((i-1),(j-1));
                                         S2 = NoisyImage((i-2),(j-2));
                                         S3 = NoisyImage((i-1),(j));
                                         S4 = NoisyImage((i-2),(j));
                                         S5 = NoisyImage((i-1),(j+1));
                                         S6 = NoisyImage((i-2),(j+2));
                                         S7 = NoisyImage((i),(j-1));
                                         S8 = NoisyImage((i),(j-2));
                                         S9 = NoisyImage(i,j);
                                         S10 = NoisyImage((i),(j+1));
                                         S11 = NoisyImage((i),(j+2));
                                         S12 = NoisyImage((i+1),(j-1));
                                         S13 = NoisyImage((i+2),(j-2));
                                         S14 = NoisyImage((i+1),(j));
                                         S15 = NoisyImage((i+2),(j));
                                         S16 = NoisyImage((i+1));((j+1));
                                         S17 = NoisyImage((i+2));((j+2));
                                         TempPixel2=[S1,S2,S3,S4,S5,S6,S7,S8,S9,S10,S11,S12,S13,S14,S15,S16,S17];
                                         Zmed2=median(TempPixel2);
                                         PreProcessedImage(i,j)= Zmed2;
                                         else
                                         PreProcessedImage(i,j)= Zmed;
                                         end
                                     end        
                       end    
            end
        end                        
        PreProcessedImage3=[];
        PreProcessedImage3(:,:,1)=PreProcessedImage;
        PreProcessedImage3(:,:,2)=PreProcessedImage;
        PreProcessedImage3(:,:,3)=PreProcessedImage;
        PreProcessedImage=PreProcessedImage3;
        PreProcessedImage=uint8(PreProcessedImage);
        axes(handles.axes2);
        imshow(PreProcessedImage,[]);
        handles.PreProcessedImage=PreProcessedImage;    
guidata(hObject, handles);
msgbox('Process completed', "Status"); 

function GMMSegmentation_Callback(hObject, ~, handles)
        PreProcessedImage=  handles.PreProcessedImage;        
        Y=double(PreProcessedImage);
        k=2; 
        g=2; 
        beta=1; 
        EM_iter=10; 
        MAP_iter=10; 
        [X,GMM,ShapeTexture]=image_kmeans(Y,k,g);
        [~,Y,~]=HMRF_EM(X,Y,GMM,k,g,EM_iter,MAP_iter,beta);
        Y=Y*80;
        Y=uint8(Y);
        Y=rgb2gray(Y);
    Y=double(Y);    
    statsa = glcm(Y,0,ShapeTexture);
    ExtractedFeatures1=statsa;
    axes(handles.axes2);
    imshow(Y,[]);
Y=uint8(Y);
    handles.ExtractedFeatures=ExtractedFeatures1;
    disp('exit');    
    handles.gmm=1;
    guidata(hObject, handles);
msgbox('Process completed', "Status"); 

function Classifier_Callback(~, ~, handles)
gmm=0;
gmm=handles.gmm;
load ExtractedFeatures
A=1:20;
B=21:40;
C=41:60;
P = [A B C];
Tc = [1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1  2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3];
k=2; 
g=2;
beta=1; 
EM_iter=10;
MAP_iter=10; 

 file=handles.InputImage;

    file=rgb2gray(file);
    file=adaptivemedian(file);
    [Xk,GMMk,ShapeTexture]=image_kmeans(file,k,g);
    PreProcessedImage(:,:,1)=file;
    PreProcessedImage(:,:,2)=file;
    PreProcessedImage(:,:,3)=file;    
    stats= gmmsegmentation(Xk,PreProcessedImage,GMMk,k,g,beta,EM_iter,MAP_iter,ShapeTexture);
    ShapeTexture=stats.ShapeTexture;    
    for i=1:60        
         statsa=ExtractedFeature{i};
         ShapeTexturea=statsa.ShapeTexture;         
                  
         diff1(i)=corr2(stats.autoc,statsa.autoc);
         diff2(i)=corr2(stats.contr,statsa.contr);
         diff3(i)=corr2(stats.corrm,statsa.corrm);
         diff4(i)=corr2(stats.cprom,statsa.cprom);
         diff5(i)=corr2(stats.cshad,statsa.cshad);
         diff6(i)=corr2(stats.dissi,statsa.dissi);
         diff7(i)=corr2(stats.energ,statsa.energ);
         diff8(i)=corr2(stats.entro,statsa.entro);
         diff9(i)=corr2(stats.homom,statsa.homom);
         diff10(i)=corr2(stats.homop,statsa.homop);
         diff11(i)=corr2(stats.maxpr,statsa.maxpr);
         diff12(i)=corr2(stats.sosvh,statsa.sosvh);
         diff13(i)=corr2(stats.savgh,statsa.savgh);
         diff14(i)=corr2(stats.svarh,statsa.svarh);
         diff15(i)=corr2(stats.senth,statsa.senth);
         diff16(i)=corr2(stats.dvarh,statsa.dvarh);
         diff17(i)=corr2(stats.denth,statsa.denth);
         diff18(i)=corr2(stats.inf1h,statsa.inf1h);
         diff19(i)=corr2(stats.inf2h,statsa.inf2h);
         diff19(i)=corr2(stats.indnc,statsa.indnc);
         diff19(i)=corr2(stats.idmnc,statsa.idmnc);
         diff20(i)=corr2(ShapeTexture,ShapeTexturea);       
    end
    [~, index1]=max(diff1);
    [~, index2]=max(diff2);
    [~, index3]=max(diff3);
    [~, index4]=max(diff4);
    [~, index5]=max(diff5);
    [~, index6]=max(diff6);
    [~, index7]=max(diff7);
    [~, index8]=max(diff8);
    [~, index9]=max(diff9);
    [~, index10]=max(diff10);
    [~, index11]=max(diff11);
    [~, index12]=max(diff12);
    [~, index13]=max(diff13);
    [~, index14]=max(diff14);
    [~, index15]=max(diff15);
    [~, index16]=max(diff16);
    [~, index17]=max(diff17);
    [~, index18]=max(diff18);
    [~, index19]=max(diff19);
    [~, index20]=max(diff20);

T = ind2vec(Tc);
spread = 1;
net = newpnn(P,T,spread);
A = sim(net,P);
Ac = vec2ind(A);

pl(1) = index20;
p1(2) = index1;
p1(3) = index2;
p1(4) = index3;
p1(5) = index4;
p1(6) = index5;
p1(7) = index6;
p1(8) = index7;
p1(9) = index8;
p1(10) = index9;
p1(11) = index10;
p1(12) = index11;
p1(13) = index12;
p1(14) = index13;
p1(15) = index14;
p1(16) = index15;
p1(17)= index16;
p1(18) = index17;
p1(19) = index18;
p1(20) = index19;
a = sim(net,pl);
ac = vec2ind(a);
disp(ac);
if ac == 1
    dec = "Benign";
elseif ac == 2
    dec = "Malign";
elseif ac == 3
    dec = "Normal";
else
    dec = "error";
end
% ac=num2str(ac);
set(handles.edit1,'String',dec);
%msgbox('Process completed', "Status");
if dec == "Benign"
    msgbox(["Process Completed!";"A benign tumor in breast cancer is a non-cancerous growth in breast tissue that does not spread to other parts of the body, but may increase the risk of developing breast cancer."]);
elseif dec == "Malign"
    msgbox(["Process Completed!"; "A malignant tumor in breast cancer is a cancerous growth in breast tissue that can spread to other parts of the body, potentially becoming life-threatening."]);
elseif dec == "Normal"
    msgbox(["Process Completed!"; "A normal result in breast cancer means that there are no signs of any tumors or cancerous growth in the breast tissue, and the breast tissue appears healthy."]);
else
    % Do nothing
end

function loaddatabase_Callback(~, ~, ~)
    clc;    
    k=2; % k: number of regions
    g=2; % g: number of GMM components
    beta=1; % beta: unitary vs. pairwise
    EM_iter=10; % max num of iterations
    MAP_iter=10; % max num of iterations    
    %helpdlg('In case of error please rerun the same program on system with 8gb ram to avoid empty clusters');

    len=1;
    len1=21;
    len2=41;
             h = waitbar(0,'Please wait...');        
for num=1:20
waitbar(num/20,h)
    filename1=strcat('Beningn',num2str(num),'.jpg');
    filename2=strcat('Malign',num2str(num),'.jpg');
    filename3=strcat('Malign',num2str(num),'.jpg');
    a=imread(filename1);
    b=imread(filename2);
    c=imread(filename3);
    a=rgb2gray(a);
    b=rgb2gray(b);
    c=rgb2gray(c);
    a=adaptivemedian(a);    
    b=adaptivemedian(b);
    c=adaptivemedian(c);        
   [Xka,GMMka,ShapeTexturea]=image_kmeans(a,k,g);
   [Xkb,GMMkb,ShapeTextureb]=image_kmeans(b,k,g);
   [Xkc,GMMkc,ShapeTexturec]=image_kmeans(c,k,g);

    PreProcessedImagea(:,:,1)=a;
    PreProcessedImagea(:,:,2)=a;
    PreProcessedImagea(:,:,3)=a;
    PreProcessedImageb(:,:,1)=b;
    PreProcessedImageb(:,:,2)=b;
    PreProcessedImageb(:,:,3)=b;
    PreProcessedImagec(:,:,1)=c;
    PreProcessedImagec(:,:,2)=c;
    PreProcessedImagec(:,:,3)=c;
    statsa= gmmsegmentation(Xka,PreProcessedImagea,GMMka,k,g,beta,EM_iter,MAP_iter,ShapeTexturea);
    statsb= gmmsegmentation(Xkb,PreProcessedImageb,GMMkb,k,g,beta,EM_iter,MAP_iter,ShapeTextureb);
    statsc= gmmsegmentation(Xkc,PreProcessedImagec,GMMkc,k,g,beta,EM_iter,MAP_iter,ShapeTexturec);

     diff{len}=statsa;
     diff{len1}=statsb;
     diff{len2}=statsc;
    len=len+1;
    len1=len1+1;
    len2=len2+1;            
end
save extractedfeatures diff
close(h);
[~ , ~]=max(diff);
disp('exit');
msgbox('Process completed', "Status"); 

function TrainPNN_Callback(~, ~, ~)
A=1:20;
B=21:40;
C=41:60;
P = [A B C];
Tc = [1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3];
T = ind2vec(Tc);
spread = 1;
net = newpnn(P,T,spread);
msgbox('Training Completed Sucessfully', "Status");
function edit1_Callback(~, ~, ~)

function edit1_CreateFcn(hObject, ~, ~)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function pushbutton7_Callback(~, ~, handles)

a=ones(256,256);
axes(handles.axes1);
imshow(a);
axes(handles.axes2);
imshow(a);
a='';
set(handles.edit1,'String',a);
clear;
