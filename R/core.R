library(gplots)

filter_matrix = function(data, minRowSum, minColSum) {

    # columns first
    data = data[, colSums(data) >= minColSum]

	# then rows
    data[rowSums(data) >= minRowSum,]

    return(data)
}


counts_to_cpm = function(counts_matrix) {

    cs = colSums(counts_matrix)

	t(apply(counts_matrix, 1, function(x) x*1e6/cs))

}

do_PCA = function(prin_comp_data, plot_title="PCA", sampleColors=NULL) {

    # Z-scale gene expr in rows
    prin_comp_data = t(apply(prin_comp_data, 1, function(x) { (x-mean(x))/sd(x) }))

    pc = princomp(prin_comp_data, cor=TRUE)


	if (is.null(sampleColors)) {
		sampleColors = rainbow(ncol(prin_comp_data))
	}

        
	plot(pc$loadings[,1], pc$loadings[,2], col=sampleColors, pch=19, main=plot_title)

	return(pc)
}

get_colors_spanning_range = function(num_vec, start_color, middle_color, end_color) {

	num_colors = 256

	min_val = min(num_vec)
	max_val = max(num_vec)

    myColors = colorpanel(num_colors, start_color, middle_color, end_color)
       
    color_indices = ceiling((num_vec - min_val) / (max_val - min_val) * num_colors)

	ret_colors = myColors[color_indices]

	return(ret_colors)
}


