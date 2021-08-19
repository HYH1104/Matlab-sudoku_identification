[pathstr,name,ext]= fileparts(mfilename('fullpath'));
for k=1:9
pics=dir([pathstr,'\train\',num2str(k),'\*.bmp']);MBS=length(pics);
if MBS>0
for i = 1:1:MBS%我的图像标号是00000001到00001340
    bgFile =[pathstr,'\train\',num2str(k),'\',pics(i).name];%这句话读取目标地址里面的格式图片
    bmp = imread(bgFile);%把图片读成matlab认识的，类型为：图片
figure(1)
imshow(bmp);title('原始动作图像');
mysize=size(bmp);%判断图像色度
if numel(mysize)>2 %判断是否是rgb图像
%%%%%%%%%%图像HSV处理%%%%%%%%%%   
myhsv=rgb2hsv(bmp);%对图像进行HSV处理
h=myhsv(:,:,1);
s=myhsv(:,:,2);
v=myhsv(:,:,3);
%%%%%%%%%%图像二值处理%%%%%%%%%%
A=im2bw(s,0.15);%对图像进行二值化处理
else
A=bmp;
end
    img = imresize(A,[32,21]);%调整大小
    filename=['a',num2str(i,'%02d'),'.jpg'];%输出的图片
    path=fullfile([pathstr,'\train\',num2str(k),'\'],filename);%输出的路径
    imwrite(img,path,'jpg');%以格式输出出去
    delete(bgFile)
end
end
end