library(gplots) # useful colorpanel func
library(edgeR)
source("R/core.R")


par(mfrow=c(1,2))

data = read.table("data/both_plates.counts.matrix.gz", header=T, com='', sep="\t", row.names=1, check.names=F)
data = as.matrix(data)

# filter low count cells and low count genes
data = filter_matrix(data, minRowSum=10, minColSum=50000);

# get plate types
plate_assignments = as.factor(substr(colnames(data), 0, 2))
plate_types = levels(plate_assignments)

# color cells by plate

cell_colors = rainbow(length(plate_types))[as.numeric(plate_assignments)]

# convert to cpm
cpm = counts_to_cpm(data)

# log2 transform cpm
logcpm = log2(data+1)
logcpm = logcpm[rowSums(logcpm) > 0,]

do_PCA(logcpm, plot_title="before removeBatchEffect()", sampleColors=cell_colors)

## Remove batch effect due to total read counts:

logcpm_minus_totRead_batchEff = removeBatchEffect(logcpm, batch=plate_assignments)

do_PCA(logcpm_minus_totRead_batchEff, plot_title="after removeBatchEffect()", sampleColors=cell_colors)

