To run the algorithm run the script 'em_variant_calling_XXX.m'

In these files you will have to load the matrices generated in the Python files, which have '.csv' format.
  You can use the following script:

        %%% Load Matrix to .mat %%%
        F = importdata('F_matrix_XXX.csv');
        save('F.mat', 'F', '-v7.3')

        disp('F done');
        
        Q = importdata('Q_matrix_XXX.csv');
        disp('Q done');
        save('Q.mat', 'Q', '-v7.3')
        
        indx = importdata('index_XXX.csv');
        disp('indx done');

        save('matrices_full.mat');
        disp('saved');

which saves the data into a '.mat' file faster to load in the algorithm
