function [bwz, p] = get_feature(im)
% 计算特征向量
bw = im2bw(im,graythresh(uint16(im)));
bw = ~bw;
[r, c] = find(bw);
rect = [min(c)-1 min(r)-1 max(c)-min(c)+2 max(r)-min(r)+2];
bwt = imcrop(bw, rect);
rate = 70/size(bwt, 1);
rc = round(size(bwt)*rate);
bwt = imresize(bwt, rc, 'bilinear');
if size(bwt, 2) < 50
    bwz = zeros(70, 50);
    ss = round((size(bwz, 2)-size(bwt,2))*0.5);
    tt = round((size(bwz, 1)-size(bwt,1))*0.5);
    bwz(:, ss:ss+size(bwt,2)-1) = bwt;
else
    bwz = imresize(bwt, [70 50], 'bilinear');
end
bwz = logical(bwz);
for k=1:7
    for k2=1:5
        dt=sum(bwz(((k*10-9):(k*10)),((k2*10-9):(k2*10))));
        f((k-1)*5+k2)=sum(dt);
    end
end
f=((100-f)/100);
p = f(:);
