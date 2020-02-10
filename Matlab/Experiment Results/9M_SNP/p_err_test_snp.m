clear all
%%% Calculate Error Probability GT-Class decided EM"
load('class_test4.mat');
load('est_pos.mat');
load('ref.mat');
load('gt_class','gt_class');
load('gt_pos','gt_pos');
load('gatk_9M');
%%
gt = [ref pos_est];

gatk = [ref pos_est];


for i=1:length(gt_class)
    ind = find(gt_pos(i) == gt(:,2));
    if((isempty(ind)==0))
        gt(ind,1) = gt_class(i);
    end
end

for i=1:length(class_gatk)
    ind = find(pos_gatk(i) == gatk(:,2));
    if((isempty(ind)==0))
        gatk(ind,1) = class_gatk(i);
    end
end
        

%%

% Confusion matrices for EM and GATK
G_em = confusionmat(gt(:,1),class);
acc_em=trace(G_em)/size(gt(:,1),1);

G_gatk = confusionmat(gt(:,1),gatk(:,1));
acc_gatk=trace(G_gatk)/size(gt(:,1),1);

% Positions with errors
err_gatk = gt(:,1)-gatk(:,1);
err_gatk = find(err_gatk~=0);% error for gatk

err_em = gt(:,1)-class;
err_em = find(err_em~=0);% error for em

% Vector with ground truth, classes decided by EM, classes by GATK and
% position:
compare = [gt(:,1), class, gatk(:,1), gt(:,2)];
