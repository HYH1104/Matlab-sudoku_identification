clc
close all
clear all
warning off
f = imread('0000.jpg');
f=imcomplement(f);
% f = imadjust(f,[0 1],[1 0]);
% SE = strel('square',3);
% A2 = imdilate(f,SE);
% SE = strel('disk',1);
% f = imerode(A2,SE);
% SE = strel('square',1);
% f = imdilate(f,SE);
gray_level = graythresh(f);
f = im2bw(f,gray_level);
[l,n] = bwlabel(f,8);
figure(1)
imshow(f);
hold on
for k = 1:n
    [r,c] = find(l==k);
    rbar = mean(r);
    cbar = mean(c);
% fprintf('%d,%d\n',rbar,cbar)
sit(k,1)=cbar;sit(k,2)=rbar;
plot(cbar,rbar,'Marker','o','MarkerEdgeColor','g','MarkerFaceColor','y','MarkerSize',10);
row = max(r) - min(r);
col = max(c) - min(c);
for i = 1:row
    for j = 1:col
        seg(i,j) = 1;
    end
end
con = [r-min(r)+1,c-min(c)+1];
[a,b] = size(con);
for i = 1:a
    seg(con(i,1),con(i,2)) = 0;
end
imwrite(seg,strcat('im/',num2str(k,'%02d'),'.bmp'));
clear seg;
end
load bp_net.mat
load VL.mat
bmp=imread('im/01.bmp');
[l,w]=size(bmp);
juzheng=zeros(9,9);
for k = 2:n
  xx=fix(sit(k,1)/(l/9))+1;
  yy=fix(sit(k,2)/(w/9))+1; 
  bmp=imread(['im/',num2str(k,'%02d'),'.bmp']);
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
C=bwmorph(A,'open',inf);%对图像进行形态学开操作
C=im2bw(A,0.3);%图像转化为二值化图
im=imresize(C,[32,21]);
[~, p_test] = get_feature(im);
p2n = tramnmx(p_test,minp, maxp);
r=sim(net,p2n);
r2n = postmnmx(r,mint,maxt);
r = round(r2n(1));
r = ts{r};
juzheng(xx,yy)=str2num(r);
end
juzheng=juzheng';
disp(juzheng)