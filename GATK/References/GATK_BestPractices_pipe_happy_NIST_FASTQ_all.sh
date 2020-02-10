#!/bin/bash
####### Script for performing GATK best practices Variant Calling ########

### input args
tempRoot=$1
num_threads=$2
fastq1=$3
fastq2=$4
targetRegion=$5
###

## Paths
dataPath="/data/ihwang/data_genomic/resources/"
softPath="/data/ihwang/software/"

## Reference FASTA
ref=$dataPath"/human_ref/human_g1k_v37.fasta"
ref20=$dataPath"/human_ref/human_g1k_v37.chr20.fasta"
###

### Reference VCF files 
hapmapFile=$dataPath"/bundle_2.8/hapmap_3.3.b37.vcf"
omniFile=$dataPath"/bundle_2.8/1000G_omni2.5.b37.vcf"
KGFile=$dataPath"/bundle_2.8/1000G_phase1.snps.high_confidence.b37.vcf"
dbsnpsFile=$dataPath"/bundle_2.8/dbsnp_138.b37.vcf"
Mills1KGIndels=$dataPath"/bundle_2.8/Mills_and_1000G_gold_standard.indels.b37.vcf"
KGFileIndels=$dataPath"/bundle_2.8/1000G_phase1.indels.b37.vcf"
###

### Ground Truth
gt_vcf=$dataPath"/GoldStandard/NA12878_GIAB_highconf_IllFB-IllGATKHC-CG-Ion-Solid_ALLCHROM_v3.2.2_highconf.vcf.gz"
gt_bed=$dataPath"/GoldStandard/NA12878_GIAB_highconf_IllFB-IllGATKHC-CG-Ion-Solid_ALLCHROM_v3.2.2_highconf.bed"

### Haplotype Caller Sensitivity
SEC=10
SCC=30
###

### VQSR Parameters
resource1="hapmap,known=false,training=true,truth=true,prior=15.0 $hapmapFile"
resource2="omni,known=false,training=true,truth=true,prior=12.0 $omniFile"
resource3="1000G,known=false,training=true,truth=false,prior=10.0 $KGFile"
resource4="dbsnp,known=true,training=false,truth=false,prior=2.0 $dbsnpsFile"
resourceIndels="mills,known=true,training=true,truth=true,prior=12.0 $Mills1KGIndels" 
recalParams="-an DP -an QD -an FS -an SOR -an MQ -an MQRankSum -an ReadPosRankSum"
recalParamsIndels="-an DP -an QD -an FS -an SOR -an MQRankSum -an ReadPosRankSum"
filter_level="99.0"
###

### temp files
aln_SAM=$tempRoot".aln.sam"
aln_BAM=$tempRoot".aln.bam"
aln_sorted_BAM=$tempRoot".aln.sorted.bam"
aln_sorted_dedup_BAM=$tempRoot".aln.sorted.dedup.bam"
aln_sorted_dedup_rg_BAM=$tempRoot".aln.sorted.dedup.rg.bam"
aln_sorted_dedup_rg_recal_BAM=$tempRoot".aln.sorted.dedup.rg.recal.bam"
dedupMetrics=$tempRoot".dedupMetrics.txt"
bqsr_data=$tempRoot".bqsr.table"
raw_VCF=$tempRoot".raw.vcf"
recalFile=$tempRoot".vqsr.recal"
tranchesFile=$tempRoot".vqsr.tranches"
rscriptFile=$tempRoot".vqsr.R"
recalFileIndels=$tempRoot".vqsr.indels.recal"
tranchesFileIndels=$tempRoot".vqsr.indels.tranches"
rscriptFileIndels=$tempRoot".vqsr.indels.R"
recal_snps_VCF=$tempRoot".vqsr.recal.snps.vcf"
recal_snps_indels_VCF=$tempRoot".vqsr.recal.snps.indels.vcf"
###


#BWA MEM alignment
bwa mem -t $num_threads -M $ref20 $fastq1 $fastq2 > $aln_SAM
# Convert to SAM to BAM
samtools view -@ $num_threads -b -h $aln_SAM > $aln_BAM
# Sort File using samtools
samtools sort -T ./tmp -@ $num_threads -O bam $aln_BAM > $aln_sorted_BAM
# Mark Duplicates in the input file (using Picard tools)
java -jar -Djava.io.tmpdir=./tmp $softPath/picard.jar MarkDuplicates I=$aln_sorted_BAM O=$aln_sorted_dedup_BAM M=$dedupMetrics ASSUME_SORTED=true
# Add read group name
java -jar -Djava.io.tmpdir=./tmp $softPath/picard.jar AddOrReplaceReadGroups I=$aln_sorted_dedup_BAM O=$aln_sorted_dedup_rg_BAM RGID=1 RGLB=lib1 RGPL=illumina RGPU=unit1 RGSM=NA12878
# We need to index the BAM file
java -jar -Djava.io.tmpdir=./tmp $softPath/picard.jar BuildBamIndex I=$aln_sorted_dedup_rg_BAM

# Recalibrate Quality Scores
java -jar -Djava.io.tmpdir=./tmp $softPath/GenomeAnalysisTK.jar -nct $num_threads -T BaseRecalibrator -R $ref20 -I $aln_sorted_dedup_rg_BAM -knownSites $dbsnpsFile -knownSites $Mills1KGIndels -knownSites $KGFileIndels -o $bqsr_data
java -jar -Djava.io.tmpdir=./tmp $softPath/GenomeAnalysisTK.jar -nct $num_threads -T PrintReads -R $ref20 -I $aln_sorted_dedup_rg_BAM -BQSR $bqsr_data -o $aln_sorted_dedup_rg_recal_BAM

# Call variants using Haplotype Caller
java -jar -Djava.io.tmpdir=./tmp $softPath/GenomeAnalysisTK.jar -T HaplotypeCaller -R $ref20 -I $aln_sorted_dedup_rg_recal_BAM --genotyping_mode DISCOVERY -stand_emit_conf $SEC -stand_call_conf $SCC -o $raw_VCF
# java -jar -Djava.io.tmpdir=./tmp $softPath/GenomeAnalysisTK.jar -T HaplotypeCaller -R $ref -I $aln_sorted_dedup_rg_recal_BAM -L $targetRegion --genotyping_mode DISCOVERY -stand_emit_conf $SEC -stand_call_conf $SCC -o $raw_VCF

# ######################
# happy_root=$tempRoot".happy.nist"
# out_html=$tempRoot".happy.nist.html"
# # run hap.py
# python /usr/local/hap.py-31-build/bin/hap.py $gt_vcf $raw_VCF -f $gt_bed -o $happy_root -r $ref --roc VQLSOD
# 
# #run the benchmarking util rep.py
# rm -r "$happy_root".rep.tsv
# printf "method\tcomparisonmethod\tfiles\n" >> "$happy_root".rep.tsv
# printf "gatk3\tNIST\t" >> "$happy_root".rep.tsv
# printf "$happy_root.extended.csv," >> "$happy_root".rep.tsv
# for i in "$happy_root".roc.Locations.*; do printf "$i,"; done >> "$happy_root".rep.tsv
# sed -i '$ s/.$//' "$happy_root".rep.tsv
# python $softPath/benchmarking-tools/reporting/basic/bin/rep.py -o $out_html -l "$happy_root".rep.tsv
