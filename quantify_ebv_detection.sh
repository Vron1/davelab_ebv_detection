#!usr/bin/sh
#Veronica Russell
#05/06/20

#This script takes as INPUT the davelab Sample ID and four files corresponding to a single sample run through the ebv_detection module:
#Two STAR Align.out.sam alignment files (one for sample pairs and other or singletons)
#and two STAR Log.final.out log files (one for sample pairs and other or singletons)

#This script generates as OUTPUT corresponding read counts of each input file in order 
#as well as sum of reads from paired and single SAM and LOG files respectively
#Output is printed to the terminal but can be subsequently piped to a txt file if desired


SAMPLE_ID=$1
IN_SAM_PAIR=$2
IN_SAM_SINGLE=$3
IN_LOG_PAIR=$4
IN_LOG_SINGLE=$5

#Quantify sample alignments to masked NC_007605 EBV genome as performed by STAR
#paired
paired_sam=$(samtools view -S ${IN_SAM_PAIR} | cut -f 3 | sort | uniq -c | grep "NC_007605.1" | awk '{print $1}')
length1=(`expr length "$paired_sam"`)
#if no value returned, 0 aligned reads found
if [ $length1 == 0 ]
then
    paired_sam=0
fi
#singles
single_sam=$(samtools view -S ${IN_SAM_SINGLE} | cut -f 3 | sort | uniq -c | grep "NC_007605.1" | awk '{print $1}')
#if no value returned, 0 aligned reads found
length2=(`expr length "$single_sam"`)
if [ $length2 == 0 ]
then
    single_sam=0
fi
#total
total_sam=`expr $paired_sam + $single_sam`


#Quantify unique sample alignments to masked NC_007605 EBV genome as performed by STAR
#paired
unique_paired=$(sed '9q;d' ${IN_LOG_PAIR} | awk '{print $6}')
#singles
unique_single=$(sed '9q;d' ${IN_LOG_SINGLE} | awk '{print $6}')
#total
unique_total=`expr $unique_single + $unique_paired`


#print out
printf '%s\n' "Sample_ID" "paired_sam" "single_sam" "total_sam" "unique_paired" "unique_single" "unique_total" | paste -sd ' '
printf '%s\n' ${SAMPLE_ID} $paired_sam $single_sam $total_sam $unique_paired $unique_single $unique_total | paste -sd ' '
