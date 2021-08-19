clc
close all
clear all
warning off
f = imread('0001.jpg');
f=imcomplement(f);
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

bmp=imread('im/01.bmp');
[l,w]=size(bmp);
juzheng=zeros(9,9);
for k = 2:n
  xx=fix(sit(k,1)/(l/9))+1;
  yy=fix(sit(k,2)/(w/9))+1; 
  bmp=imread(['im/',num2str(k,'%02d'),'.bmp']);
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
A=imresize(A,[32,21]);%归一化处理
jieguohanzi  = mobanpp(A);
juzheng(xx,yy)=jieguohanzi;
end
juzheng=juzheng';
disp(juzheng)