[pathstr,name,ext]= fileparts(mfilename('fullpath'));
for k=1:9
pics=dir([pathstr,'\train\',num2str(k),'\*.bmp']);MBS=length(pics);
if MBS>0
for i = 1:1:MBS%我的图像标号是00000001到00001340
    bgFile =[pathstr,'\train\',num2str(k),'\',pics(i).name];%这句话读取目标地址里面的格式图片
    bmp = imread(bgFile);%把图片读成matlab认识的，类型为：图片
%%%%%%%%%%图像HSV处理%%%%%%%%%% 
mysize=size(bmp);
if numel(mysize)>2   
myhsv=rgb2hsv(bmp);%对图像进行HSV处理
h=myhsv(:,:,1);
% h=h*360;
s=myhsv(:,:,2);
% s=s*255;
v=myhsv(:,:,3);
%%%%%%%%%%图像中值滤波%%%%%%%%%%
bmp=medfilt2(v,[3,3]);
%%%%%%%%%%图像二值处理%%%%%%%%%%
A=im2bw(v,0.3);%对图像进行二值化处理
%A=imcomplement(A);%对图像进行黑白反转
else
    A=bmp;
end
%%%%%%%%图像二值轮廓提取%%%%%%%%%
B=bwperim(A);%对图像进行二值轮廓提取
%%%%%%%%图像做形态学处理%%%%%%%%%
% C=bwareaopen(B,100);
C=bwmorph(A,'open',inf);%对图像进行形态学开操作
C=im2bw(A,0.3);%图像转化为二值化图
    img = imresize(C,[32,21]);%调整大小
    filename=[num2str(i,'%02d'),'.bmp'];%输出的图片
    path=fullfile([pathstr,'\train\',num2str(k),'\'],filename);%输出的路径
    imwrite(img,path,'bmp');%以格式输出出去
end
end
end