clear all
%%% Calculate Error Probability GT-Class decided EM"

% Load EM estimates
load('class_test13.mat');
index = index+1;

% Load GATK estimates
load('gatk_9M.mat');

% Load reference
load('ref.mat');

% Load ground truth
load('gt_16M');
% Get up to the position 9.000.0095
tmp=find(gt_pos>9000095);
ps=tmp(1)-1;
gt_class = gt_class(1:ps);
gt_pos = gt_pos(1:ps);
gt = [gt_class gt_pos];

%%% Find the calls (different from reference) and create new vectors for EM
%%% estimates
ind=find(class~=ref);
new_class = class(ind);
new_index = index(ind);

em = [new_class new_index];

% emgtpos = intersect(gt_pos, new_index);
% poss=find(gt_pos==new_index);
% 
% gt_new = gt_pos(poss);
% em_new = new_clas(poss);
% % Confusion matrix
% G_em = confusionmat(gt_new,new_class);



% These calls match with the ground truth calls?
c_em=intersect(gt_pos,new_index);
c_gatk=intersect(gt_pos,pos_gatk);


% Precision of our call = true positives / (false positives+true positives)
% prec = true calls / all our calls;
prec_em = length(c_em)/length(new_index);
prec_gatk = length(c_gatk)/length(pos_gatk);

% Diferencies amb el ground truth --> son calls que hauriem de haver fet,
% per tant = false negatives (Miss-detection)
d_em=setdiff(gt_pos,new_index);
d_gatk=setdiff(gt_pos,pos_gatk);


recall_em = length(c_em)/(length(c_em)+length(d_em)); % 
recall_gatk = length(c_gatk)/(length(c_gatk)+length(d_gatk)); 
% OK pero la questio es que GATK agafa tots els calls
% encara que sigui tot igual, l'agafa. D'aqui que hi hagi mes precisio
% i recall:
% a continuacio s'explica:

%   - pot ser que nosaltres no diem "CALL" perque a la columna de la 
%   matriu tots els valors s?n iguals i per tant nosaltres no el
%   considerem, pero realment allo sigui un call:
%       Exemple:
%              REF:        T
%              Read1:      C
%              Read2:      C
%              Read3:      C
%
% Hi ha un call de T >> C pero com totes les files son iguals no el
% considerem. AIXO HO FA GATK??? JO CREC QUE SI!! L'UNIC QUE HA D FER ES
% DECIDIR ENTRE DIFERENTS NUCS QUE TENEN EL MATEIX VALOR! EASY 




