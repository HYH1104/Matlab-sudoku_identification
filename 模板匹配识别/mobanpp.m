%�ַ�ģ��ƥ��ʶ�𻷽�
%����µ���Ҫʶ�������ʱ��Ҫ��ӱȶ������Ϣ
function mobanpp=mobanpp(chulitupian)
%%%%%%%%������ȡģ��ͼ��%%%%%%%%%
[pathstr,~,~]= fileparts(mfilename('fullpath'));	
pics1=dir([pathstr,'\train\1\*.jpg']);M1=length(pics1);
pics2=dir([pathstr,'\train\2\*.jpg']);M2=length(pics2);
pics3=dir([pathstr,'\train\3\*.jpg']);M3=length(pics3);
pics4=dir([pathstr,'\train\4\*.jpg']);M4=length(pics4);
pics5=dir([pathstr,'\train\5\*.jpg']);M5=length(pics5);
pics6=dir([pathstr,'\train\6\*.jpg']);M6=length(pics6);
pics7=dir([pathstr,'\train\7\*.jpg']);M7=length(pics7);
pics8=dir([pathstr,'\train\8\*.jpg']);M8=length(pics8);
pics9=dir([pathstr,'\train\9\*.jpg']);M9=length(pics9);
if M1 > 0 %������������ͼ��? ?
for i = 1:M1 %��һ��ȡͼ�� ?
image = imread(strcat([pathstr,'\train\1\'],pics1(i).name));
image=im2bw(image,0.5);%��ͼ����ж�ֵ������
maopaopp(:,:,:,i) = image;
end  
end
if M2 > 0 %������������ͼ��?
for i = 1:M2 %��һ��ȡͼ�� ?
image = imread(strcat([pathstr,'\train\2\'],pics2(i).name)); 
image=im2bw(image,0.5);%��ͼ����ж�ֵ������
maopaopp(:,:,:,i+M1) = image;
end  
end
if M3 > 0 %������������ͼ��?
for i = 1:M3 %��һ��ȡͼ�� ?
image = imread(strcat([pathstr,'\train\3\'],pics3(i).name));
image=im2bw(image,0.5);%��ͼ����ж�ֵ������
maopaopp(:,:,:,i+M1+M2) = image;
end  
end
if M4 > 0 %������������ͼ��? ?
for i = 1:M4 %��һ��ȡͼ�� ?
image = imread(strcat([pathstr,'\train\4\'],pics4(i).name));
image=im2bw(image,0.5);%��ͼ����ж�ֵ������
maopaopp(:,:,:,i+M1+M2+M3) = image;
end  
end
if M5 > 0 %������������ͼ��?
for i = 1:M5 %��һ��ȡͼ�� ?
image = imread(strcat([pathstr,'\train\5\'],pics5(i).name)); 
image=im2bw(image,0.5);%��ͼ����ж�ֵ������
maopaopp(:,:,:,i+M1+M2+M3+M4) = image;
end  
end
if M6 > 0 %������������ͼ��?
for i = 1:M6 %��һ��ȡͼ�� ?
image = imread(strcat([pathstr,'\train\6\'],pics6(i).name));
image=im2bw(image,0.5);%��ͼ����ж�ֵ������
maopaopp(:,:,:,i+M1+M2+M3+M4+M5) = image;
end  
end
if M7 > 0 %������������ͼ��? ?
for i = 1:M7 %��һ��ȡͼ�� ?
image = imread(strcat([pathstr,'\train\7\'],pics7(i).name));
image=im2bw(image,0.5);%��ͼ����ж�ֵ������
maopaopp(:,:,:,i+M1+M2+M3+M4+M5+M6) = image;
end  
end
if M8 > 0 %������������ͼ��?
for i = 1:M8 %��һ��ȡͼ�� ?
image = imread(strcat([pathstr,'\train\8\'],pics8(i).name)); 
image=im2bw(image,0.5);%��ͼ����ж�ֵ������
maopaopp(:,:,:,i+M1+M2+M3+M4+M5+M6+M7) = image;
end  
end
if M9 > 0 %������������ͼ��?
for i = 1:M9 %��һ��ȡͼ�� ?
image = imread(strcat([pathstr,'\train\9\'],pics9(i).name));
image=im2bw(image,0.5);%��ͼ����ж�ֵ������
maopaopp(:,:,:,i+M1+M2+M3+M4+M5+M6+M7+M8) = image;
end  
end
[y,x,~]=size(chulitupian);%��ȡͼƬ����ֵ
[~,~,z]=size(maopaopp);%��ȡͼƬ����ֵ
for k=1:z  %�˴��ж���ģ���ѭ�����ٴ�
sum=0;
for i=1:y
    for j=1:x
         if  maopaopp(i,j,:,k)==chulitupian(i,j)%ͳ�ƺڰ�
             sum=sum+1;
        end
    end
end
baifenbi(1,k)=sum/(x*y);%�ٷֱȱȶ�
end
chepai= find(baifenbi>=max(baifenbi));
mobanpp=chepai;%�����������У���0��ʼ����Ҫ��1�����ﲻ��
%�ȶ������Ϣ
if     mobanpp<=M1
    mobanpp=1;
elseif mobanpp<=(M1+M2)
    mobanpp=2;
elseif mobanpp<=(M1+M2+M3)
    mobanpp=3;
elseif mobanpp<=(M1+M2+M3+M4)
    mobanpp=4;
elseif mobanpp<=(M1+M2+M3+M4+M5)
    mobanpp=5;
elseif mobanpp<=(M1+M2+M3+M4+M5+M6)
    mobanpp=6;
elseif mobanpp<=(M1+M2+M3+M4+M5+M6+M7)
    mobanpp=7;
elseif mobanpp<=(M1+M2+M3+M4+M5+M6+M7+M8)
    mobanpp=8;
elseif mobanpp<=(M1+M2+M3+M4+M5+M6+M7+M8+M9)
    mobanpp=9;
end