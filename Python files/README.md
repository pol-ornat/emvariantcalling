Information about the Python codes
-----------------------------------

To generate matrices with only SNPs (without indels), use the scripts:
        - genMatrix.py
        - genMatrixQ.py
    

To generate matrices with SNPs and INDELs use the scripts:
        - genMatrix_indel.py
        - genMatrixQ_indel.py
    
    
To generate matrices with SNPs and INDELs use the scripts and get the obvious cases (all rows equal for a position):
        - genMatrix_indel_obvious.py
        - genMatrixQ_indel.py
    
    
IMPORTANT!! For the previous script:
        - Select the SAM file in line 17: with open("./###NAME###.sam") as f:
        - Change the length of the sequence, in line 5, according to file. (i.e. 10000000 if SAM_9M). Remeber to add 
        at least +100.000 extra positions, as the nucleotides start from position 59.000. Just to make a guard space.
        - Change the name of the file in lines 124 and 125.
        - When generating Q matrices (genMatrixQ*) load the index file in line 129 and change name in line 135.
    
    
Other files:
        - gatkToVector.py >> This code gets the GATK VCF File and converts it into a .csv file to import as a vector in Matlab (for positions or variants)
        - getsDiff_ref.py >> This file gets the vector generated from 'refToVector.py' and generates a new vector with the positions given by the input file 'index.csv'
        - vcfToVector.py >> This code gets the VCF File and converts it into a .csv file to import as a vector in Matlab (for positions or variants)
