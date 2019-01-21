clear,clc

filefold_prex = 'tctodd';
filefold_list = {'1','2','3','4','5','6','7','8','9'};
filename_list = {'alive','all','answer','boy','building','buy','change_mind_',...
    'cold','come','computer_PC_','cost','crazy','danger','deaf','different',...
    'draw','drink','eat','exit','flash-light','forget','girl','give',...
    'glove','go','God','happy','head','hear','hello','his_hers','hot','how',...
    'hurry','hurt','I','innocent','is_true_','joke','juice','know','later',...
    'lose','love','make','man','maybe','mine','money','more','name','no',...
    'Norway','not-my-problem','paper','pen','please','polite','question',...
    'read','ready','research','responsible','right','sad','same','science',...
    'share','shop','soon','sorry','spend','stubborn','surprise','take',...
    'temper','thank','think','tray','us','voluntary','wait_notyet_','what',...
    'when','where','which','who','why','wild','will','write','wrong','yes',...
    'you','zero'};

X = cell(10000,1);
Y = zeros(10000,1);
total_samples = 0;
total_samples_prev = total_samples;
L_max = 0;
L_ave = 0;
for i = 1:length(filefold_list)
    filefold = filefold_list{i};
    label_index = 0;
    for j = 1:length(filename_list)
        filename = filename_list{j};
        label_index = label_index + 1;
        for k = 1:3 % read a new sign
            sampleTS = load(strcat(filefold_prex,filefold,'/',filename,'-',...
                num2str(k),'.tsd'));
            if L_max < size(sampleTS,1)
                L_max = size(sampleTS,1);
            end
            L_ave = L_ave + size(sampleTS,1);
            total_samples = total_samples + 1;
            X{total_samples} = sampleTS';
            Y(total_samples) = label_index;
        end
    end
    total_samples_singlefold = total_samples - total_samples_prev;
    total_samples_prev = total_samples;
    fprintf('Finish tctodd%s, total samples %d, total signs %d \n',...
        filefold,total_samples_singlefold,label_index);
end
L_ave = L_ave/total_samples;
X = X(1:total_samples);
Y = Y(1:total_samples);
fprintf('Total samples %d, total labels %d, L_max %d, L_ave %d\n',...
    total_samples,label_index,L_max,L_ave);

% shuffle and split train/test data with raito 7:3.
shuffle_index = randperm(total_samples);
X = X(shuffle_index); % shuffle the data
Y = Y(shuffle_index);
split_line = floor(total_samples*0.7);
train_X = X(1:split_line);
train_Y = Y(1:split_line);
test_X = X(split_line+1:end);
test_Y = Y(split_line+1:end);
save('auslan.mat','train_X','train_Y','test_X','test_Y');

% sampleTS_mean = mean(sampleTS);
% sampleTS_std = std(sampleTS);
% sampleTS_nor = sampleTS - repmat(sampleTS_mean,size(sampleTS,1),1);
% sampleTS_nor = sampleTS_nor./repmat(sampleTS_std,size(sampleTS,1),1);
% total_samples = total_samples + 1;
% X{total_samples} = sampleTS_nor';
% Y(total_samples) = j;
