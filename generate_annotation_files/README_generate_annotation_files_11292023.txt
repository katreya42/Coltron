# 11292023

hg19_gencodeV19_comprehensive.txt
-----------------------------------
Downloaded from UCSC table browser
clade: Mammal
genome: Human
assembly: Feb. 2009 (GRCh37/hg19)
group: Genes and Gene Predictions
track: GENCODE Genes V19    
table: Comprehensive (wgEncodeGencodeCompV19)
  

hg38_gencodeV44_comprehensive.txt
hg38_gencodeV44_attrs.txt
-----------------------------------
clade: Mammal
genome: Human
assembly: Dec. 2013 (GRCh38/hg38)
group: Genes and Gene Predictions
track: All GENCODE V44    
table: 
Comprehensive (wgEncodeGencodeCompV44)
wgEncodeGencodeAttrsV44
  

mm9_ensGene.txt
mm9_ensemblToGeneName.txt
----------------------------
Downloaded from UCSC table browser
clade: Mammal
genome: Mouse
assembly: July 2007 (NCBI37/mm9)
group: Genes and Gene Predictions
track: Ensembl Genes 
table: 
ensGene
ensemblToGeneName
  

mm10_gencodeVM25_comprehensive.txt
--------------------------------------
Downloaded from UCSC table browser
clade: Mammal
genome: Mouse
assembly: Dec. 2011 (GRCm38/mm10)
group: Genes and Gene Predictions
track: All GENCODE VM25  
table: Comprehensive (wgEncodeGencodeCompVM25)
  

For Coltron, annotation files need to have the following columns:
#bin	name	chrom	strand	txStart	txEnd	cdsStart	cdsEnd	exonCount	exonStarts	exonEnds	score	name2	cdsStartStat	cdsEndStat	exonFrames


# Strip transcript version off of transcript IDs (for hg19, hg38, and mm10)
awk -F'\t' 'BEGIN {OFS="\t"} {sub(/\..*$/, "", $2); print}' hg19_gencodeV19_comprehensive.txt > hg19_gencodeV19_comprehensive_v2.txt
awk -F'\t' 'BEGIN {OFS="\t"} {sub(/\..*$/, "", $2); print}' hg38_gencodeV44_comprehensive.txt > hg38_gencodeV44_comprehensive_v2.txt
awk -F'\t' 'BEGIN {OFS="\t"} {sub(/\..*$/, "", $2); print}' mm10_gencodeVM25_comprehensive.txt > mm10_gencodeVM25_comprehensive_v2.txt




# 01092023
Consult generate_annotation_files_01092023.R to turn mm9_ensGene.txt into an appropriate form for use with Coltron.

Annotation file filename is hard-coded into utils.py, therefore, the filenames need to have the form:
<genome_build>_refseq.ucsc
mkdir for_coltron_update
cp hg19_gencodeV19_comprehensive_v2.txt for_coltron_update/hg19_refseq.ucsc
cp hg38_gencodeV44_comprehensive_v2.txt for_coltron_update/hg38_refseq.ucsc
cp mm10_gencodeVM25_comprehensive_v2.txt for_coltron_update/mm10_refseq.ucsc
cp mm9_ensGene_v2.txt for_coltron_update/mm9_refseq.ucsc



Get the set of human and mouse transcription factors. Download the list of TFs from AnimalTFDB 4.0 (https://guolab.wchscu.cn/AnimalTFDB4//#/Download)
Homo_sapiens_TF.txt 	1660 TFs (1637 that have a gene symbol)
Mus_musculus_TF.txt 	1612 TFs (all have a gene symbol)
(Note that Lambert's 2018 Cell paper PMID:29425488 has 1639 human TFs)
Consult for_coltron_update_01092023.R to create the TFlist files needed for each genome.
mv TFlist*.txt for_coltron_update/

(base) katreya@katreyadesktop:~/Desktop/Coltron_stuff/for_coltron_update$ cat TFlist_NMid_hg19.txt | awk '{print $2}' | sort | uniq | wc -l
    1601
(base) katreya@katreyadesktop:~/Desktop/Coltron_stuff/for_coltron_update$ cat TFlist_NMid_hg38.txt | awk '{print $2}' | sort | uniq | wc -l
    1631
(base) katreya@katreyadesktop:~/Desktop/Coltron_stuff/for_coltron_update$ cat TFlist_NMid_mm9.txt | awk '{print $2}' | sort | uniq | wc -l
    1466
(base) katreya@katreyadesktop:~/Desktop/Coltron_stuff/for_coltron_update$ cat TFlist_NMid_mm10.txt | awk '{print $2}' | sort | uniq | wc -l
    1601



For the VertebratePWMs, there are 2196 unique TFs with 3281 motif matrices.
(base) katreya@katreyadesktop:~/Desktop/Coltron_stuff/coltron/data/annotation$ cat VertebratePWMs.txt | grep "MOTIF" | awk '{print $3}' | wc -l
    3281
(base) katreya@katreyadesktop:~/Desktop/Coltron_stuff/coltron/data/annotation$ cat VertebratePWMs.txt | grep "MOTIF" | awk '{print $3}' | sort | uniq | wc -l
    2196
    


For the MotifDictionary, there are 700 unique TFs that map to 3282 motifs.
(base) katreya@katreyadesktop:~/Desktop/Coltron_stuff/coltron/data/annotation$ cat MotifDictionary.txt | awk '{print $2}' | wc -l
    3282
(base) katreya@katreyadesktop:~/Desktop/Coltron_stuff/coltron/data/annotation$ cat MotifDictionary.txt | awk '{print $2}' | sort | uniq | wc -l
     700



# ==> We will use the VertebratePWM.txt and MotifDictionary.txt files that come packaged with the Coltron release. It will take substantial effort to build a fully updated comprehensive database of vertebrate motifs to use - we can do this for a future update.


TFlist files need to have column 1 be NM or ENST ID, while column 2 is the gene symbol. This maps transcript ID to gene name.

MotifDictionary files map motif to gene name. Here is an example:
Transfac.V$RORBETA_Q2	RORB
Transfac.V$PAX9_B	PAX9
Coltron's installed MotifDictionary has motifs from Transfac, Homedomain, Jaspar2014, Jolma2013, Uniprobe, Wei2010






