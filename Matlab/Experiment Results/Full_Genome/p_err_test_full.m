clear all
%%% Calculate Error Probability GT-Class decided EM"
load('test_EM_full','class','indx');

load('ref_full.mat');
load('gt_full');
load('gatk_full');
%%
gt = [ref indx];
gatk = gt;

disp('data loaded');

for i=1:length(gt_class)
    ind = find(gt_pos(i) == gt(:,2));
    if((isempty(ind)==0))
        gt(ind,1) = gt_class(i);
    end
end

disp('gt OK');

for i=1:length(class_gatk)
    ind = find(pos_gatk(i) == gatk(:,2));
    if((isempty(ind)==0))
        gatk(ind,1) = class_gatk(i);
    end
end

disp('gatk OK');
        

%%

% Confusion matrices for EM and GATK
G_em = confusionmat(gt(:,1),class);
acc_em=trace(G_em)/size(gt(:,1),1);

disp('G_em OK');

G_gatk = confusionmat(gt(:,1),gatk(:,1));
acc_gatk=trace(G_gatk)/size(gt(:,1),1);

disp('G_gatk OK');

disp('end');

% Positions with errors
%err_gatk = gt(:,1)-gatk(:,1);
%err_gatk = find(err_gatk~=0);% error for gatk

%err_em = gt(:,1)-class;
%err_em = find(err_em~=0);% error for em

% Vector with ground truth, classes decided by EM, classes by GATK and
% position:
%compare = [gt(:,1), class, gatk(:,1), gt(:,2)];

save('performance_full');