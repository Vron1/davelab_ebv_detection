#!usr/bin/sh
#Veronica Russell
#05/04/20

#unmapped reads to masked ebv genome last used
#takes input bam of all rna reads after human alignment using STAR and marking of PCR duplicates (aka bam filed directly from gsuti analysis bucket)
#STAR run on only masked ebv ref genome


ANALYSIS_ID=$1 #Davelab anlysis ID
IN_BAM=$2 #pcr marked duplicates file from gs://analysis_results/${ANLYSIS_ID}/picard_markduplicates__rna/picard_markduplicates__rna_Picard_MarkDuplicates.mrkdup.bam
PREFIX_PATH=$3 #gsutil bucket path up to point in which sample_id must be used
REF_IDX_DIR=$4 #intended use: EBV masked reference (virus_masked_hg38_NC007605.fa) from VirDetect workflow
#indexing from VirDetect workflow follows:
#STAR --runThreadN 1 --runMode genomeGenerate --genomeSAindexNbases 7 --genomeDir ${REF_IDX_DIR} --genomeFastaFiles ${REF_IDX_FASTA}
${NThreads}=$5


#filter input bam and convert to fastqs

samtools fastq -f 4 -F 1024 ${IN_BAM} -1 ${PREFIX_PATH}/human_unmapped_to_masked_ebv_${ANALYSIS_ID}_STAR1.fastq -2 ${PREFIX_PATH}/human_unmapped_to_masked_ebv_${ANALYSIS_ID}_STAR2.fastq -s ${PREFIX_PATH}/human_unmapped_to_masked_ebv_${ANALYSIS_ID}_STARs.fastq

#currently must account for singletons separately
#STAR RUN for pairs
STAR --genomeDir ${REF_IDX_DIR} --readFilesIn ${OUT_PATH}/human_unmapped_to_masked_ebv_${ANALYSIS_ID}_STAR1.fastq ${OUT_PATH}/human_unmapped_to_masked_ebv_${ANALYSIS_ID}_STAR2.fastq --runThreadN ${NThreads} --outFilterMismatchNmax 5 --outFilterMultimapNmax 10 --limitOutSAMoneReadBytes 1000000 --outFileNamePrefix ${OUT_PATH}/ebv_alignments/human_unmapped_to_masked_ebv_${ANALYSIS_ID}_STAR_pairs

#STAR RUN for singletons
STAR --genomeDir ${REF_IDX_DIR} --readFilesIn ${OUT_PATH}/human_unmapped_to_masked_ebv_${ANALYSIS_ID}_STARs.fastq --runThreadN ${NThreads} --outFilterMismatchNmax 5 --outFilterMultimapNmax 10 --limitOutSAMoneReadBytes 1000000 --outFileNamePrefix ${OUT_PATH}/ebv_alignments/human_unmapped_to_masked_ebv_${ANALYSIS_ID}_STAR_singles_