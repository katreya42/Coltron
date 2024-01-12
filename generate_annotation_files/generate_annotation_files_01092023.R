##########################################################
# Generate annotation files for Coltron update
# Katreya Lovrenert
# Wu Lab - CWRU
# 01092023
##########################################################

library(readr)
library(dplyr)

### Mapping mm9 gene symbols to Ensembl transcript IDs
### ---------------------------------------------------------------------------------------
df <- read_delim("mm9_ensGene.txt", delim = "\t", escape_double = FALSE, col_types = cols(exonStarts = col_character(), exonEnds = col_character()), trim_ws = TRUE)
df2 <- read_delim("mm9_ensemblToGeneName.txt", delim = "\t", col_names = TRUE)

df3 <- left_join(df, df2, join_by(name == `#name`))
df3 <- df3[, c(1:12, 17, 14:16)]
header <- colnames(df)
colnames(df3) <- header

write_delim(df3, "mm9_ensGene_v2.txt", delim = "\t", col_names = TRUE)
rm(df, df2, df3, header)


### Make TFlist files (maps Ensembl transcript IDs to gene symbols)
### ---------------------------------------------------------------------------------------
hs_tf <- read_delim("Homo_sapiens_TF.txt", delim = "\t", col_names = TRUE)
mm_tf <- read_delim("Mus_musculus_TF.txt", delim = "\t", col_names = TRUE)

hg19 <- read_delim("hg19_gencodeV19_comprehensive_v2.txt", delim = "\t", col_names = TRUE)
hg38 <- read_delim("hg38_gencodeV44_comprehensive_v2.txt", delim = "\t", col_names = TRUE)
mm9 <- read_delim("mm9_ensGene_v2.txt", delim = "\t", col_names = TRUE)
mm10 <- read_delim("mm10_gencodeVM25_comprehensive_v2.txt", delim = "\t", col_names = TRUE)

# Do for human
symbols_to_match <- hs_tf[!is.na(hs_tf$Symbol), 2]
df <- hg19
TFlist <- df[df$name2 %in% symbols_to_match$Symbol, c(2, 13), ]
write_delim(TFlist, "TFlist_NMid_hg19.txt", delim = "\t", col_names = FALSE)
df <- hg38
TFlist <- df[df$name2 %in% symbols_to_match$Symbol, c(2, 13), ]
write_delim(TFlist, "TFlist_NMid_hg38.txt", delim = "\t", col_names = FALSE)

# Do for mouse
symbols_to_match <- mm_tf[!is.na(mm_tf$Symbol), 2]
df <- mm9
TFlist <- df[df$name2 %in% symbols_to_match$Symbol, c(2, 13), ]
TFlist$name2 <- toupper(TFlist$name2)
write_delim(TFlist, "TFlist_NMid_mm9.txt", delim = "\t", col_names = FALSE)
df <- mm10
TFlist <- df[df$name2 %in% symbols_to_match$Symbol, c(2, 13), ]
TFlist$name2 <- toupper(TFlist$name2)
write_delim(TFlist, "TFlist_NMid_mm10.txt", delim = "\t", col_names = FALSE)







