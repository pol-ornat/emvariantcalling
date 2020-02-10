## Paths
dataPath="./data/"
softPath="./software/"

## Reference FASTA
# ref=$dataPath"/human_ref/human_g1k_v37.fasta"
ref20="human_g1k_v37.chr20.fasta"
###

raw_VCF=$"gatk_full.vcf"
num_threads=$"2"

### Haplotype Caller Sensitivity
SEC=10
SCC=30
###


## BAM File
aln_BAM=$"/samtools-1.9/homo.bam"

# aln_BAM=$"bam_16M.bam"
aln_sorted_BAM=$"aln.sorted.bam"
aln_sorted_dedup_BAM=$"aln.sorted.dedup.bam"
aln_sorted_dedup_rg_BAM=$"aln.sorted.dedup.rg.bam"
aln_sorted_dedup_rg_recal_BAM=$"aln.aln_sorted_BAM.dedup.rg.recal.bam"
dedupMetrics=$"dedupMetrics.txt"

dbsnpsFile=$dataPath"/dbsnp_138.b37.vcf"
Mills1KGIndels=$dataPath"/Mills_and_1000G_gold_standard.indels.b37.vcf"
KGFileIndels=$dataPath"/1000G_phase1.indels.b37.vcf"

### 

# # Sort File using samtools
# samtools sort -T ./tmp -@ $num_threads -O bam $aln_BAM > $aln_sorted_BAM
# # Mark Duplicates in the input file (using Picard tools)
# java -jar -Djava.io.tmpdir=./tmp $softPath/picard.jar MarkDuplicates I=$aln_sorted_BAM O=$aln_sorted_dedup_BAM M=$dedupMetrics ASSUME_SORTED=true
# # Add read group name
# java -jar -Djava.io.tmpdir=./tmp $softPath/picard.jar AddOrReplaceReadGroups I=$aln_sorted_dedup_BAM O=$aln_sorted_dedup_rg_BAM RGID=1 RGLB=lib1 RGPL=illumina RGPU=unit1 RGSM=NA12878
# # We need to index the BAM file
# java -jar -Djava.io.tmpdir=./tmp $softPath/picard.jar BuildBamIndex I=$aln_sorted_dedup_rg_BAM


### GATK ###
############
#### Old version ####
# Recalibrate Quality Scores
# java -jar -Djava.io.tmpdir=./tmp $softPath/GenomeAnalysisTK.jar -nct $num_threads -T BaseRecalibrator -R $ref20 -I $aln_sorted_dedup_rg_BAM -knownSites $dbsnpsFile -knownSites $Mills1KGIndels -knownSites $KGFileIndels -o $bqsr_data
# java -jar -Djava.io.tmpdir=./tmp $softPath/GenomeAnalysisTK.jar -nct $num_threads -T PrintReads -R $ref20 -I $aln_sorted_dedup_rg_BAM -BQSR $bqsr_data -o $aln_sorted_dedup_rg_recal_BAM

# Call variants using Haplotype Caller
# java -jar -Djava.io.tmpdir=./tmp $softPath/GenomeAnalysisTK.jar -T HaplotypeCaller -R $ref20 -I $aln_sorted_dedup_rg_recal_BAM --genotyping_mode DISCOVERY -stand_emit_conf $SEC -stand_call_conf $SCC -o $raw_VCF

# Call variants using Haplotype Caller
# Option 1
# java -jar -Djava.io.tmpdir=./tmp $softPath/GenomeAnalysisTK.jar -T HaplotypeCaller -R $ref20 -I $aln_BAM --genotyping_mode DISCOVERY -stand_call_conf $SCC -o $raw_VCF
# Option 2
# java -jar -Djava.io.tmpdir=./tmp $softPath/GenomeAnalysisTK.jar -T HaplotypeCaller -R $ref20 -I $aln_SAM --emitRefConfidence GVCF [--dbsnp dbSNP.vcf] [-L targets.interval_list] -o $raw_VCF

# #### New version ####
/test_gatk/software/gatk-4.1.2.0/gatk --java-options "-Xmx8G" HaplotypeCaller -R $ref20 -I $aln_BAM -O $raw_VCF

# https://software.broadinstitute.org/gatk/documentation/article?id=11050

# 	


# https://software.broadinstitute.org/gatk/documentation/article?id=23390#comparison







