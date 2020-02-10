# emvariantcalling

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
        
        Finally there is the file 'convert_to_full_instances.m' which generates a matrix grouping each nucleotide and ordering
        it (as said in the paper) by quality bining. 
        
       
 - 'GATK' folder: contains the necessary instructions and software to use the GATK algorithm.
        
        In the software folder there is a .zip with the GATK version we used.
        
        The file 'gatk_instructions.sh' is a series of instructions to run GATK using our reference genome and
        .bam files. It will generate a .VCF file.
        

- 'Python files': contains all the necessary functions to generate the matlab matrix from the SAM file. The most 
important functions are:
        
        'genMatrix.py': generates the nucleotide matrix
        'genMatrixQ.py': enerates the quality score matrix
        
        'genMatrix_indel.py': generates the nucleotide matrix considering the INDELs
        'genMatrixQ_indel.py': generates the quality score matrix considering the INDELs
        
        The other functions are useful to parse the CIGAR value (for checking procedures) and convert different type
        of files (vcf, reference or gatk) to a vector to import into Matlab.
        

The file 'samtools-1.9.tar.bz2' is the version of the samtools software we used. Mainly to convert SAM files into BAM.
