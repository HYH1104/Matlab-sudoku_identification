% * HSV颜色空间转换-->
% * HSV通道分离-->
% * 中值滤波-->
% * 肤色分割（二值化处理）-->
% * 形态学运算-->
% * 轮廓检测及过滤-->
% 轮廓形状匹配
%%%%%%%%增加训练时的图片数量可以提高识别成功率
%%%%%%%%重新建立数据库或增加数据库参考chuli.m文件开头的注释
%%%%%%%%Hu矩库匹配识别成功率比较低
%%%%%%%%本代码匹配时使用的是bp神经识别，Hu矩库以及匹配方法也以建立保留，后续可自行设计Hu矩比对方法
%%%%%%%%%%工作空间准备%%%%%%%%%%
clc
close all
clear all
warning off
%%%%%%%%%%bp神经网络建立%%%%%%%%%%
fd = fullfile(pwd, 'train');
fds = dir(fd);
ts = [];
for i = 1 : length(fds)
    if isequal(fds(i).name, '.') || isequal(fds(i).name, '..')
        continue;
    end
    ts{end+1} = fds(i).name;
end
files = GetAllFiles(fd);
% 提取手势集合的特征向量
db_file = fullfile(pwd, 'VL.mat');
if exist(db_file, 'file')
    load(db_file);
else
    VT = [];
    LT = [];
    for i = 1 : length(files)
        im = imread(files{i});
        [~, v] = get_feature(im);
        % 特征
        VT = [VT v];
        [pn, ~, ~] = fileparts(files{i});
        [~, nm, ~] = fileparts(pn);
        for j = 1 : length(ts)
            if isequal(ts{j}, nm)
                % 标签
                LT = [LT j];
                break;
            end
        end
    end
    save(db_file, 'VT', 'LT','ts');
end
% BP训练
net_file = fullfile(pwd, 'bp_net.mat');
if exist(net_file, 'file')
    load(net_file);
else

    p_train=VT;
    t_train=LT;
    [pn,minp,maxp,tn,mint,maxt] = premnmx(p_train, t_train);
    threshold=minmax(pn);
    net=newff(threshold,[30,20,10,1],{'tansig','tansig','tansig','purelin'},'trainlm');
    net.trainParam.epochs=10000;
    net.trainParam.goal=1e-9;
    net.trainParam.show=50;
    net.trainParam.lr=0.01;
    net=train(net,pn,tn);
    % 存储网络
    save(net_file, 'net', 'minp', 'maxp', 'mint', 'maxt');
end
%%%%%%%%%%测试图片选取%%%%%%%%%% 
[fn,pn,fi]=uigetfile('*.*','选择图片');%选择图片
bmp=imread([pn fn]);TT=bmp;%显示原始图像
figure(1);subplot(221);imshow(bmp);title('RGB原始图像');
%%%%%%%%%%图像HSV处理%%%%%%%%%% 
mysize=size(bmp);
if numel(mysize)>2   
myhsv=rgb2hsv(bmp);%对图像进行HSV处理
h=myhsv(:,:,1);
% h=h*360;
s=myhsv(:,:,2);
% s=s*255;
v=myhsv(:,:,3);
% v=v*255;
subplot(222);imshow(h);title('HSV转化后的H分量');
subplot(223);imshow(s);title('HSV转化后的S分量');
subplot(224);imshow(v);title('HSV转化后的V分量');
%%%%%%%%%%图像中值滤波%%%%%%%%%%
bmp=medfilt2(v,[3,3]);
figure(2);subplot(221);imshow(bmp);title('中值滤波图像');
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
subplot(222);imshow(A);title('二值化图像');
subplot(223);imshow(B);title('二值化轮廓');
subplot(224);imshow(C);title('形态学处理');
im=imresize(C,[32,21]);
[~, p_test] = get_feature(im);
p2n = tramnmx(p_test,minp, maxp);
r=sim(net,p2n);
r2n = postmnmx(r,mint,maxt);
r = round(r2n(1));
r = ts{r};
% title(r, 'FontSize', 16);
hs=msgbox(['识别结果为：',num2str(r)],'result');
% ht=findobj(hs,'Type','text');
% set(ht,'FontSize',20,'Unit','normal');
% set(hs,'Resize','on');
pause(1);
close(hs);