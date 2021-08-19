% clc; clear all; close all;
% warning off all;
% % 获取字符集
% fd = fullfile(pwd, 'images', 'dbx');
% fds = dir(fd);
% ts = [];
% for i = 1 : length(fds)
%     if isequal(fds(i).name, '.') || isequal(fds(i).name, '..')
%         continue;
%     end
%     ts{end+1} = fds(i).name;
% end
% files = GetAllFiles(fd);
% % 提取字符集合的特征向量
% db_file = fullfile(pwd, 'VL.mat');
% if exist(db_file, 'file')
%     load(db_file);
% else
%     VT = [];
%     LT = [];
%     for i = 1 : length(files)
%         im = imread(files{i});
%         [~, v] = get_feature(im);
%         % 特征
%         VT = [VT v];
%         [pn, ~, ~] = fileparts(files{i});
%         [~, nm, ~] = fileparts(pn);
%         for j = 1 : length(ts)
%             if isequal(ts{j}, nm)
%                 % 标签
%                 LT = [LT j];
%                 break;
%             end
%         end
%     end
%     save(db_file, 'VT', 'LT');
% end
% % BP训练
% net_file = fullfile(pwd, 'bp_net.mat');
% if exist(net_file, 'file')
%     load(net_file);
% else
% 
%     p_train=VT;
%     t_train=LT;
%     [pn,minp,maxp,tn,mint,maxt] = premnmx(p_train, t_train);
%     threshold=minmax(pn);
%     net=newff(threshold,[30,20,10,1],{'tansig','tansig','tansig','purelin'},'trainlm');
%     net.trainParam.epochs=10000;
%     net.trainParam.goal=1e-5;
%     net.trainParam.show=50;
%     net.trainParam.lr=0.01;
%     net=train(net,pn,tn);
%     % 存储网络
%     save(net_file, 'net', 'minp', 'maxp', 'mint', 'maxt');
% end
function xx=jianc()
m=1;%图片的亮度系数对与识别成功率影响很大，如果图片本身对比度很高（你的图片的对比度就很高）值设为1即可，如果光线较暗可适当提高数值反之亦然。
%类似我文件夹中的图片，需将m设置为0.5~0.3，否则连续域处理无法实现程序无法响应
[fn,pn,fi]=uigetfile('*.jpg','选择图片');   %选择图片
I=imread([pn fn]);figure(1),imshow(I);title('原始图像');%显示原始图像
%J=imadjust(I,[0.2 0.6],[0 1],m);figure(2),imshow(J);title('灰度图像'); %调整图像灰度并调高亮度
grayimg = I;BWimg = grayimg;[width,height]=size(grayimg);%灰度图数据传递，导入宽高
%thresh = graythresh(I);  %自动确定二值化阈值；
A=im2bw(I,0.6);     % thresh=0.5 表示将灰度等级在128以下的像素全部变为黑色，将灰度等级在128以上的像素全部变为白色。
figure(3);imshow(A);title('二值化图像');%显示图像
bw = edge(A,'sobel','vertical'); figure(4); imshow(bw);title("边缘图像"); % 垂直边缘检测 
Z = strel('rectangle',[30,18]);%连通域处理
bw_close=imclose(bw,Z);figure(5);imshow(bw_close);title("闭操作");%连通域闭处理
bw_open = imopen(bw,Z);figure(6);imshow(bw_open );title("开操作");%连通域开处理
showImg = grayimg;%灰度图数据传递
%图像数据二值化处理,如果图像尺度过大会使处理时间几何倍增加，所以尽量使用小尺度图片，（你的图片完全OK）我提供个测试图片就属于过大的了
for i=1:width  
    for j=1:height
        if(BWimg(i,j) == 255)
            showImg(i,j)= grayimg(i,j);
        else 
            showImg(i,j)= 0;
        end
    end
end
figure(7);
imshow(showImg);%可视化显示二值化图像
[l,m] = bwlabel(bw_close);  %连续域标签
status=regionprops(l,'BoundingBox');%图像区域度量
centroid = regionprops(l,'Centroid');%字符区域度量
imshow(I);hold on;
a=[-7,-7,7,7];
for i=1:m
if status(i).BoundingBox(1,3) > status(i).BoundingBox(1,4)
    status(i).BoundingBox(1,4)=status(i).BoundingBox(1,3);
else
    status(i).BoundingBox(1,3)=status(i).BoundingBox(1,4);
end
   status(i).BoundingBox=status(i).BoundingBox+a;
    rectangle('position',status(i).BoundingBox,'edgecolor','g');%字符画框
    text(centroid(i,1).Centroid(1,1)-25,centroid(i,1).Centroid(1,2)-25, num2str(i),'Color', 'r') %字符框标号
end 
for i=1:m
   cropimg_2 = imcrop(A,status(i).BoundingBox);%画框部分图像截取
   cropimg_2 = imresize(cropimg_2,[28,28]); 
   for j=1:7
        lj=['C:\\Users\\头发日常有点乱\\Documents\\MATLAB\\hanzishuziluomaxila\\imagess\\',num2str(j),'.bmp'];
        x=imread(lj);
        a(j)=corr2(cropimg_2,x);%矩阵匹配
   end   
        xx=find(a==max(a));
        fprintf('%d\n',xx);
%imwrite(cropimg_2,['C:\\Users\\头发日常有点乱\\Documents\\MATLAB\\hanzishuziluomaxila\\LXJC\\',num2str(j),'.bmp'],'bmp')%将截取部分的图像暂时存储在LXSB文件中
%filePath = ['C:\\Users\\头发日常有点乱\\Documents\\MATLAB\\hanzishuziluomaxila\\imagess\\', num2str(xx),'.bmp'];%打开图像
%    if isequal(filePath, 0)
%         break;
%     end
%     im = uint16(imread(filePath));
%     [~, p_test] = get_feature(im);
%     p2n = tramnmx(p_test,minp, maxp);
%     r=sim(net,p2n);
%     r2n = postmnmx(r,mint,maxt);
%     r = round(r2n(1));
%     r = ts{r};
%     figure;imshow(cropimg_2);title(r, 'FontSize', 16);
end 
end
