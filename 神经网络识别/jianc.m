% clc; clear all; close all;
% warning off all;
% % ��ȡ�ַ���
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
% % ��ȡ�ַ����ϵ���������
% db_file = fullfile(pwd, 'VL.mat');
% if exist(db_file, 'file')
%     load(db_file);
% else
%     VT = [];
%     LT = [];
%     for i = 1 : length(files)
%         im = imread(files{i});
%         [~, v] = get_feature(im);
%         % ����
%         VT = [VT v];
%         [pn, ~, ~] = fileparts(files{i});
%         [~, nm, ~] = fileparts(pn);
%         for j = 1 : length(ts)
%             if isequal(ts{j}, nm)
%                 % ��ǩ
%                 LT = [LT j];
%                 break;
%             end
%         end
%     end
%     save(db_file, 'VT', 'LT');
% end
% % BPѵ��
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
%     % �洢����
%     save(net_file, 'net', 'minp', 'maxp', 'mint', 'maxt');
% end
function xx=jianc()
m=1;%ͼƬ������ϵ������ʶ��ɹ���Ӱ��ܴ����ͼƬ����ԱȶȺܸߣ����ͼƬ�ĶԱȶȾͺܸߣ�ֵ��Ϊ1���ɣ�������߽ϰ����ʵ������ֵ��֮��Ȼ��
%�������ļ����е�ͼƬ���轫m����Ϊ0.5~0.3���������������޷�ʵ�ֳ����޷���Ӧ
[fn,pn,fi]=uigetfile('*.jpg','ѡ��ͼƬ');   %ѡ��ͼƬ
I=imread([pn fn]);figure(1),imshow(I);title('ԭʼͼ��');%��ʾԭʼͼ��
%J=imadjust(I,[0.2 0.6],[0 1],m);figure(2),imshow(J);title('�Ҷ�ͼ��'); %����ͼ��ҶȲ���������
grayimg = I;BWimg = grayimg;[width,height]=size(grayimg);%�Ҷ�ͼ���ݴ��ݣ�������
%thresh = graythresh(I);  %�Զ�ȷ����ֵ����ֵ��
A=im2bw(I,0.6);     % thresh=0.5 ��ʾ���Ҷȵȼ���128���µ�����ȫ����Ϊ��ɫ�����Ҷȵȼ���128���ϵ�����ȫ����Ϊ��ɫ��
figure(3);imshow(A);title('��ֵ��ͼ��');%��ʾͼ��
bw = edge(A,'sobel','vertical'); figure(4); imshow(bw);title("��Եͼ��"); % ��ֱ��Ե��� 
Z = strel('rectangle',[30,18]);%��ͨ����
bw_close=imclose(bw,Z);figure(5);imshow(bw_close);title("�ղ���");%��ͨ��մ���
bw_open = imopen(bw,Z);figure(6);imshow(bw_open );title("������");%��ͨ�򿪴���
showImg = grayimg;%�Ҷ�ͼ���ݴ���
%ͼ�����ݶ�ֵ������,���ͼ��߶ȹ����ʹ����ʱ�伸�α����ӣ����Ծ���ʹ��С�߶�ͼƬ�������ͼƬ��ȫOK�����ṩ������ͼƬ�����ڹ������
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
imshow(showImg);%���ӻ���ʾ��ֵ��ͼ��
[l,m] = bwlabel(bw_close);  %�������ǩ
status=regionprops(l,'BoundingBox');%ͼ���������
centroid = regionprops(l,'Centroid');%�ַ��������
imshow(I);hold on;
a=[-7,-7,7,7];
for i=1:m
if status(i).BoundingBox(1,3) > status(i).BoundingBox(1,4)
    status(i).BoundingBox(1,4)=status(i).BoundingBox(1,3);
else
    status(i).BoundingBox(1,3)=status(i).BoundingBox(1,4);
end
   status(i).BoundingBox=status(i).BoundingBox+a;
    rectangle('position',status(i).BoundingBox,'edgecolor','g');%�ַ�����
    text(centroid(i,1).Centroid(1,1)-25,centroid(i,1).Centroid(1,2)-25, num2str(i),'Color', 'r') %�ַ�����
end 
for i=1:m
   cropimg_2 = imcrop(A,status(i).BoundingBox);%���򲿷�ͼ���ȡ
   cropimg_2 = imresize(cropimg_2,[28,28]); 
   for j=1:7
        lj=['C:\\Users\\ͷ���ճ��е���\\Documents\\MATLAB\\hanzishuziluomaxila\\imagess\\',num2str(j),'.bmp'];
        x=imread(lj);
        a(j)=corr2(cropimg_2,x);%����ƥ��
   end   
        xx=find(a==max(a));
        fprintf('%d\n',xx);
%imwrite(cropimg_2,['C:\\Users\\ͷ���ճ��е���\\Documents\\MATLAB\\hanzishuziluomaxila\\LXJC\\',num2str(j),'.bmp'],'bmp')%����ȡ���ֵ�ͼ����ʱ�洢��LXSB�ļ���
%filePath = ['C:\\Users\\ͷ���ճ��е���\\Documents\\MATLAB\\hanzishuziluomaxila\\imagess\\', num2str(xx),'.bmp'];%��ͼ��
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
