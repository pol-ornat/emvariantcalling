# emvariantcalling

HOW TO RUN THE ALGORITHM
  1. Decompress the software 'samtools-1.9'
  2. Download the file 'homo.bam' from the DRIVE repository
  3. Follow the instructions in HOW_TO_samtools to generate SAM files
  4. Load the SAM Files in the Python scripts to generate matrices (see README in Python folder)
  5. Generate the .csv files using the python scripts (see README in Python folder)
  6. Load the data to Matlab and run the selected algorithm script (see README in Matlab folder)
  
  
In this repository you will find:

  - 'Matlab' folder: contains both the code and the results of its execution for the 4 test run.
        
        1. 9M_SNP: contains the code 'em_variant_calling_test_snp.m' which runs the EM algorithms using the data
        of the first 9 milions nucleotides of the sequence. It just consider the SNP, so the INDELS are not included.
        It also contains the performance evaluating the results of a run in 'performance_9M_snp.mat'
        
        2. 9M_INDEL: contains the code 'em_variant_calling_indel.m' which runs the EM algorithms using the data
        of the first 9 milions nucleotides of the sequence. It just considers both  SNP and INDELS.
        It also contains the performance evaluating the results of a run in 'performance_indel.mat'
        
        3. Comp_N: Contains all the runs that form the test when the length N takes different values. Contains both
        codes for execution and performance results for each case.
        
        4. Full_Genome: contains the code 'em_variant_calling_full.m' which runs the EM algorithms using the data
        of the full genome sequence. It just consider the SNP, so the INDELS are not included.
        It also contains the performance evaluating the results of a run in 'performance_full.mat'. There is an
        additional matlab code to import the .csv matrices from python to matlab in a more efficient way (toMatrixFull.m)
        
        The file 'convert_to_full_instances.m' generates a matrix grouping each nucleotide and ordering
        it (as said in the paper) by quality bining. 
        
        Lastly, there is a link to a drive repository, so you can access the results of every simulation.
        
       
 - 'GATK' folder: contains the necessary instructions and software to use the GATK algorithm.
        
        In the software folder there is a .zip with the GATK version we used.
        
        The file 'gatk_instructions.sh' is a series of instructions to run GATK using our reference genome and
        .bam files. It will generate a .VCF file.
        
        The file 'gt_16M.vcf' is the ground truth file for the first 16 million nucleotides.
        

- 'Python files': contains all the necessary functions to generate the matlab matrix from the SAM file. The most 
important functions are:
        
        'genMatrix.py': generates the nucleotide matrix
        'genMatrixQ.py': enerates the quality score matrix
        
        'genMatrix_indel.py': generates the nucleotide matrix considering the INDELs
        'genMatrixQ_indel.py': generates the quality score matrix considering the INDELs
        
        The other functions are useful to parse the CIGAR value (for checking procedures) and convert different type
        of files (vcf, reference or gatk) to a vector to import into Matlab.
        
  Find README_python for detailed information
        

The file 'samtools-1.9.tar.bz2' is the version of the samtools software we used. Mainly to convert SAM files into BAM.


ACCESS DRIVE FILES IN THE FOLLOWING LINK: https://drive.google.com/drive/folders/1J1Nan86uB8qYUDRUZGNhvrX9aVlTnm9o?usp=sharing
