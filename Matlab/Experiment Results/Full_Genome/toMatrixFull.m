%%% Matrix to .mat - full genome %%%
F_full = importdata('F_matrix.csv');
save('F_full.mat', 'F_full', '-v7.3')

disp('F done');
%Q_full = importdata('Q_matrix.csv');
%disp('Q done');
%save('Q_full.mat', 'Q_full', '-v7.3')
%indx = importdata('index_full.csv');
%disp('indx done');

%save('matrices_full.mat');
disp('saved');