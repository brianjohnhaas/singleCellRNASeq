library(gplots) # useful colorpanel func
library(edgeR)
source("R/core.R")


par(mfrow=c(1,2))

data = read.table("data/plate_A.counts.matrix.gz", header=T, com='', sep="\t", row.names=1, check.names=F)
data = as.matrix(data)

# filter low count cells and low count genes
data = filter_matrix(data, minRowSum=10, minColSum=50000);

# convert to cpm
cs = colSums(data)
cell_colors = get_colors_spanning_range(cs, 'green', 'black', 'red')

cpm = counts_to_cpm(data)

# log2 transform cpm
logcpm = log2(data+1)
logcpm = logcpm[rowSums(logcpm) > 0,]

do_PCA(logcpm, plot_title="PCA before tot counts batch correction", sampleColors=cell_colors)

## Remove batch effect due to total read counts:

logcpm_minus_totRead_batchEff = removeBatchEffect(logcpm, covariates=cs)

do_PCA(logcpm_minus_totRead_batchEff, plot_title="PCA after tot counts batch correction", sampleColors=cell_colors)



