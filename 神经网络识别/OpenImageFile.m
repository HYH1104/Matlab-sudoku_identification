
function filePath = OpenImageFile(imgfilePath)
% 打开文件
% 输出参数：
% filePath——文件路径

if nargin < 1
    imgfilePath = fullfile(pwd, 'images/testx/Ⅰ-003.bmp');
end
% 读取文件
[filename, pathname, ~] = uigetfile( ...
    { '*.bmp;*.jpg;*.tif;*.png;*.gif','All Image Files';...
    '*.*',  '所有文件 (*.*)'}, ...
    '选择文件', ...
    'MultiSelect', 'off', ...
    imgfilePath);
filePath = 0;
if isequal(filename, 0) || isequal(pathname, 0)
    return;
end
filePath = fullfile(pathname, filename);