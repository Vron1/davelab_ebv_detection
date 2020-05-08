README.txt
Veronica Russell (veronica.russell@duke.edu)
Rotation Project
Davelab 05/07/2020
---------------------------------------

PROJECT:
EBV Detection in FFPE Tumor Samples

---------------------------------------

OBJECTIVE:
Detection of Epstein-Barr virus presence from tumor sample sequencing data from 1MB, 8MB, or 110MB davelab panel. Designed as a preliminary, base module to obtain further data and insight with regard to development of dianostic cut offs/benchmarking. 

---------------------------------------

FULL ROTATION PROJECT AND MODULE SCRIPT INVENTORY AND LOCATIONS:

Dockerfile - sets up docker environment specific to module (basic ubuntu functionality, STAR, samtools)
-location: copy at github Vron1/davelab_ebv_detection, hosted on docker container

ebv_detection.sh - bash file used by EBV_detection.py, takes sample rna bam files after alignment to human genome in davelab pipeline and aligns human unmapped, non-PCR duplicate reads to masked ebv genome
-location: copy at github Vron1/davelab_ebv_detection, hosted on docker container

quantify_ebv_detection.sh - takes as input sample id and all four outputs of ebv_detection module in the order paired sam, singles sam, paired final log, single final log and outputs quantification of reads (single reads)
-location: Vron1/davelab_ebv_detection

visualize_ebv_detection.Rmd - R code that takes as input a .csv file with information on sample ids, analysis ids, panel used, sample mean coverage, ebv read count, and other samples characteristic to generate plots of sample id versus log(ebv read count)
-location: Vron1/davelab_ebv_detection

EBV_detection.py - python script for module, uses Dockerfile, and ebv_detection.sh
-location: davelab github on CloudConductor CloudConductor/Modules/Tools/EBV_detection.py

Configuration files - three .config scripts and one .json script
    ebv_detection_graph_template.config
    ebv_detection_platformtemplate.config
    ebv_detection_resource_template.config
    ebv_detection_sample_sheet.json
-location: davelab github cc-config-template/ebv_detection/

---------------------------------------

USAGE:
Under analysis on db.davelab.org select desired samples -> Add Analysis -> Select Pipeline ebv_detection

---------------------------------------

WORKFLOW:
Input data to ebv_detection module - sample rna bam files from davelab TNA pipeline after alignment to human GRCh38 genome and picard marking of PCR duplicates. As of 05/07/202 google bucket path for these is of form gs://analysis_results/{ANALYSIS_ID}/picard_markduplicates__rna/picard_markduplicates__rna_Picard_MarkDuplicates.mrkdup.bam and input is defined in ebv_detection_sample_sheet.json

Module Internal Workflow:
filtering - filters input bam using samtools -f 4 -F 1024 (selects human unmapped reads and excludes PCR duplicates)
file conversion - convert to paired and singletons fastq files
alignments - run STAR alignment on paired fastq files and singletons separately
    parameters:
        --genomeDir ref_masked_ebv (masked NC_007605.1 EBV genome)
        ---runThreadN 8
        --outFilterMismatchNmax 5
        --outFilterMultimapNmax 10
        --limitOutSAMoneReadBytes 1000000
        --outFileNamePrefix 

Output
- two Aligned.out.sam files (one for paired reads and one for singles)
        gs://analysis_results/{EBV_ANALYSIS_ID}/ebv_detection/ebv_detection_EBV_detection.{SAMPLE_ID}_A{ANALYSIS_ID}_ebv_paired_Aligned.out.sam
        gs://analysis_results/{EBV_ANALYSIS_ID}/ebv_detection/ebv_detection_EBV_detection.{SAMPLE_ID}_A{ANALYSIS_ID}_ebv_single_Aligned.out.sam
- two Log.final.out files (one for paired reads and one for singles)
        gs://analysis_results/{EBV_ANALYSIS_ID}/ebv_detection/ebv_detection_EBV_detection.{SAMPLE_ID}_A{ANALYSIS_ID}_ebv_paired_Log.final.out
        gs://analysis_results/{EBV_ANALYSIS_ID}/ebv_detection/ebv_detection_EBV_detection.{SAMPLE_ID}_A{ANALYSIS_ID}_ebv_single_Log.final.out

Quantification and Visualization:
quantify_ebv_detect.sh - for quantification of all and unique ebv reads detected and summation of paried and singleton runs
visualize_ebv_detect.Rmd - R script for visualization of multiple sample ebv read counts given user defined .csv file (further details on .csv file formatting and required column headers in .Rmd script)


---------------------------------------










