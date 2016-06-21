#!/bin/sh
# 21-6-2016 MRC-Epid JHZ

# root directory
rt=/genetics/data/CGI/TWAS-pipeline

# The calling arguments are zfile (bmi.txt). source (ALL, EUR), population (MET, NTR, YFS)
# so that based on $rt/ALL|EUR/bmi.txt, $rt/ALL|EUR/MET|NTR|YFS/*imp are generated

zfile=$1
src=$2
pop=$3
gs=$4

# working directory
wd=$rt/$src/$pop

cd $wd
awk -v gs=$gs '($1==gs)' /genetics/bin/TWAS/$pop.lst | awk -v rt=$rt -v wd=$wd -v pop=$pop -v zfile=$zfile '
{
    gene=$1
    filename=sprintf("/genetics/bin/TWAS/WEIGHTS_%s/%s/%s.wgt",pop,gene,gene)
# zscore setup
    system(sprintf("echo SNP_ID SNP_Pos Ref_Allele Alt_Allele Z-score > %s.zscore",gene))
    system(sprintf("sort -k1,1 %s.map > %s",filename,gene))
    system(sprintf("join -j 1 %s ../%s | sort -k2,2n | awk -f %s/twas2-swap.awk >> %s.zscore",gene,zfile,rt,gene))
# imputation
    system(sprintf("TWAS.sh %s %s.zscore %s",filename,gene,gene))
}'

# mkdir -p BRCA1/YFS
# ln -sf ../menopause/menopause.txt
# sh twas2-1.sh menopause.txt BRCA1 YFS BRCA1