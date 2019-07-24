function generate_LR_metasr_X1_X4()
%% settings

data_set = 'MY'
path_save = 'MY_train_HR_bicubic/';
path_src = 'MY_train_HR/';

ext               =  {'*.png', '*.jpg', '*.jpeg'};
filepaths           =  [];
for i = 1 : length(ext)
    filepaths = cat(1,filepaths, dir(fullfile(path_src, ext{i})));
end

nb_im = length(filepaths);

FolderLR_bicubic = path_save

if ~exist(FolderLR_bicubic)
    mkdir(FolderLR_bicubic)
end

parfor idx_im = 1:nb_im
    fprintf('Read HR :%d\n', idx_im);
    ImHR = imread(fullfile(path_src, filepaths(idx_im).name));
    %% generate and save LR via imresize() with Bicubic
    
    scales = [2.0,3.0,4.0];
    
    scale_num = length(scales);
    
    for i = 1:scale_num
        image = ImHR;
        scale = scales(i);
        FolderLR = fullfile(path_save, sprintf('X%d',scale));
        
        if ~exist(FolderLR, 'dir')
            mkdir(FolderLR)
        end
    
        [h,w,n]=size(image);
        if mod(h,scale) ~= 0
            h = h - 4;
        end
        if mod(w,scale) ~= 0
            w = w - 4;
        end
        image =image(1:h,1:w,:);
    
        image= imresize(image, 1/scale, 'bicubic');
        % name image
        fileName = filepaths(idx_im).name;
        items = regexp(fileName, '\.', 'split');
        %NameLR = fullfile(FolderLR, strcat(items(1),'.jpg'));
        NameLR = fullfile(FolderLR, fileName);
        %disp(NameLR);
        % save image
        imwrite(image, NameLR);
    end
end

    
