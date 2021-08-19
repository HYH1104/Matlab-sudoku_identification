% * HSV��ɫ�ռ�ת��-->
% * HSVͨ������-->
% * ��ֵ�˲�-->
% * ��ɫ�ָ��ֵ������-->
% * ��̬ѧ����-->
% * ������⼰����-->
% ������״ƥ��
%%%%%%%%����ѵ��ʱ��ͼƬ�����������ʶ��ɹ���
%%%%%%%%���½������ݿ���������ݿ�ο�chuli.m�ļ���ͷ��ע��
%%%%%%%%Hu�ؿ�ƥ��ʶ��ɹ��ʱȽϵ�
%%%%%%%%������ƥ��ʱʹ�õ���bp��ʶ��Hu�ؿ��Լ�ƥ�䷽��Ҳ�Խ����������������������Hu�رȶԷ���
%%%%%%%%%%�����ռ�׼��%%%%%%%%%%
clc
close all
clear all
warning off
%%%%%%%%%%bp�����罨��%%%%%%%%%%
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
% ��ȡ���Ƽ��ϵ���������
db_file = fullfile(pwd, 'VL.mat');
if exist(db_file, 'file')
    load(db_file);
else
    VT = [];
    LT = [];
    for i = 1 : length(files)
        im = imread(files{i});
        [~, v] = get_feature(im);
        % ����
        VT = [VT v];
        [pn, ~, ~] = fileparts(files{i});
        [~, nm, ~] = fileparts(pn);
        for j = 1 : length(ts)
            if isequal(ts{j}, nm)
                % ��ǩ
                LT = [LT j];
                break;
            end
        end
    end
    save(db_file, 'VT', 'LT','ts');
end
% BPѵ��
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
    % �洢����
    save(net_file, 'net', 'minp', 'maxp', 'mint', 'maxt');
end
%%%%%%%%%%����ͼƬѡȡ%%%%%%%%%% 
[fn,pn,fi]=uigetfile('*.*','ѡ��ͼƬ');%ѡ��ͼƬ
bmp=imread([pn fn]);TT=bmp;%��ʾԭʼͼ��
figure(1);subplot(221);imshow(bmp);title('RGBԭʼͼ��');
%%%%%%%%%%ͼ��HSV����%%%%%%%%%% 
mysize=size(bmp);
if numel(mysize)>2   
myhsv=rgb2hsv(bmp);%��ͼ�����HSV����
h=myhsv(:,:,1);
% h=h*360;
s=myhsv(:,:,2);
% s=s*255;
v=myhsv(:,:,3);
% v=v*255;
subplot(222);imshow(h);title('HSVת�����H����');
subplot(223);imshow(s);title('HSVת�����S����');
subplot(224);imshow(v);title('HSVת�����V����');
%%%%%%%%%%ͼ����ֵ�˲�%%%%%%%%%%
bmp=medfilt2(v,[3,3]);
figure(2);subplot(221);imshow(bmp);title('��ֵ�˲�ͼ��');
%%%%%%%%%%ͼ���ֵ����%%%%%%%%%%
A=im2bw(v,0.3);%��ͼ����ж�ֵ������
%A=imcomplement(A);%��ͼ����кڰ׷�ת
else
    A=bmp;
end
%%%%%%%%ͼ���ֵ������ȡ%%%%%%%%%
B=bwperim(A);%��ͼ����ж�ֵ������ȡ
%%%%%%%%ͼ������̬ѧ����%%%%%%%%%
% C=bwareaopen(B,100);
C=bwmorph(A,'open',inf);%��ͼ�������̬ѧ������
C=im2bw(A,0.3);%ͼ��ת��Ϊ��ֵ��ͼ
subplot(222);imshow(A);title('��ֵ��ͼ��');
subplot(223);imshow(B);title('��ֵ������');
subplot(224);imshow(C);title('��̬ѧ����');
im=imresize(C,[32,21]);
[~, p_test] = get_feature(im);
p2n = tramnmx(p_test,minp, maxp);
r=sim(net,p2n);
r2n = postmnmx(r,mint,maxt);
r = round(r2n(1));
r = ts{r};
% title(r, 'FontSize', 16);
hs=msgbox(['ʶ����Ϊ��',num2str(r)],'result');
% ht=findobj(hs,'Type','text');
% set(ht,'FontSize',20,'Unit','normal');
% set(hs,'Resize','on');
pause(1);
close(hs);