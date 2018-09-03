# Charles Perin, extendet by Johannes Liem
library(ggplot2)
library(grid)
library(scales)

integer_formatter <- function(x) {
    label <- sprintf('%d', x)
    return (label)
}

percent_formatter <- function(x) {
    label <- sprintf('%d %%', x)
    return (label)
}

score_formatter <- function(x) {
    label <- sprintf('%.1f', x)
    return (label)
}

score_formatter_1f <- function(x) {
  label <- sprintf('%.1f', x)
  return (label)
}

score_formatter_2f <- function(x) {
  label <- sprintf('%.2f', x)
  return (label)
}

score_formatter_3f <- function(x) {
  label <- sprintf('%.3f', x)
  return (label)
}

millis_to_seconds_formatter <- function(x) {
    label <- sprintf('%.0f', x/1000)
    return (label)
}

plotCI <- function(){
	dev.new(width=5, height=3)
}

# A SIMPLE SET OF PLOTTING FUNCTIONS

hplot <- function(analysisData, title, datasetName, x, ymin, ymax, ylabelFormatter, width=12, height=4, facets=NULL, pdf=NULL, png=NULL) {

	dev.new(width=width, height=height)
	
	if(is.null(facets) == FALSE){
		plot <- ggplot(analysisData, aes_string(x=x, y="pointEstimate")) + facet_grid(facets)
	}
	else{
		plot <- ggplot(analysisData, aes_string(x=x, y="pointEstimate"))
	} 

	plot <- plot + 
		coord_flip() +
		geom_point(fill="white", color="white", size=5 , pch=21)+#the pointEstimate style
		geom_point(fill="#333333", size=0.5, pch=21)+#the pointEstimate style
	  geom_pointrange(aes(ymin=ci.min, ymax=ci.max), size=0.75) +#the pointEstimate style
		theme_bw() + 
		theme( # remove the vertical grid lines
			plot.background = element_blank(),
			legend.position = "none",
			#axis.ticks.margin=unit(c(0.5,-4.0),'mm'),
			#axis.text.margin=unit(c(0.5,-4.0),'mm'),
			axis.title.x = element_text(size=16, vjust=-0.5),#x axis Title
			axis.text.x = element_text(size=12, colour="#000000"),#x axis labels
			axis.text.y = element_text(size=12, colour="#000000FF"),#Y axis labels  #, face="bold"
	   	panel.border = element_blank(),
        	panel.grid.major.y = element_blank(),
        	panel.grid.minor.y = element_blank(),
        	axis.line = element_line(size=0.1, color="#000000"),
        	axis.ticks = element_line(size=0.1, color="#000000"),
        	axis.line.y = element_blank(),#y axis line
        	axis.ticks.y = element_blank(),#y axis ticks
        	panel.grid.minor.x = element_line(size=0.01, color="#BBBBBB"),#x Minor ticks
        	panel.grid.major.x = element_line(size=0.03, color="#BBBBBB"),#x Major ticks
        	strip.background = element_rect(colour="#EEEEEE", fill="#EEEEEE"),#y Facets design
        	strip.text.y = element_text(size=12),#y Facets design
        	strip.text.x = element_text(size=8)#x Facets design
	    ) +
	    #scale_x_discrete(name="", labels = analysisData$label) +
	    scale_y_continuous(name=title, limits = c(ymin, ymax), oob = rescale_none, labels=ylabelFormatter) #,breaks = scales::pretty_breaks(n = 1)) #
	print(plot)
	if(is.null(pdf)==FALSE){
		ggsave(pdf, dpi=600, useDingbats=FALSE, width=8, height=2)
	}
	if(is.null(png)==FALSE){
	  ggsave(png, device="png", dpi=600, width=8, height=2)
	}
}

hplotNoLabels <- function(analysisData, title, datasetName, x, ymin, ymax, ylabelFormatter, width=12, height=4, facets=NULL, pdf=NULL, png=NULL, cbbPalette=NULL) {
  
  dev.new(width=width, height=height)
  
  if(is.null(facets) == FALSE){
    plot <- ggplot(analysisData, aes_string(x=x, y="pointEstimate")) + facet_grid(facets)
  }
  else{
    plot <- ggplot(analysisData, aes_string(x=x, y="pointEstimate", fill=x, colour=x))
  } 
  
  plot <- plot + 
    coord_flip() +
    geom_point(fill="white", colour="white", size=2 , pch=21)+#the pointEstimate style
    geom_point(size=1, pch=21, stroke=0.01)+#the pointEstimate style
    scale_fill_manual(values=cbbPalette) +
    scale_colour_manual(values=cbbPalette) +
    #geom_point(fill)
    #geom_segment(aes(xend=x,y=ci.min, yend=ci.max), size=3, color="orange") +
    geom_pointrange(aes(ymin=ci.min, ymax=ci.max), size=0.2) + #the pointEstimate style
    
    theme_bw() + 
    theme( # remove the vertical grid lines
      plot.background = element_blank(),
      legend.position = "none",
      #axis.ticks.margin=unit(c(0.5,-4.0),'mm'),
      #axis.text.margin=unit(c(0.5,-4.0),'mm'),
      #axis.title.x = element_text(size=16, vjust=-0.5),#x axis Title
      axis.title.x = element_blank(),
      axis.title.y = element_blank(),
      axis.text.x = element_text(size=8, colour="#000000"),#x axis labels
      #axis.text.y = element_text(size=12, colour="#000000FF"),#Y axis labels  #, face="bold"
      axis.text.y = element_blank(),
      panel.border = element_blank(),
      panel.grid.major.y = element_blank(),
      panel.grid.minor.y = element_blank(),
      axis.line = element_line(size=0.1, color="#000000"),
      axis.ticks = element_line(size=0.1, color="#000000"),
      axis.line.y = element_blank(),#y axis line
      axis.ticks.y = element_blank(),#y axis ticks
      panel.grid.minor.x = element_line(size=0.01, color="#BBBBBB"),#x Minor ticks
      panel.grid.major.x = element_line(size=0.03, color="#BBBBBB"),#x Major ticks
      strip.background = element_rect(colour="#EEEEEE", fill="#EEEEEE"),#y Facets design
      strip.text.y = element_text(size=12),#y Facets design
      strip.text.x = element_text(size=8)#x Facets design
    ) +
    scale_y_continuous(name=title, limits = c(ymin, ymax), oob = rescale_none, labels=ylabelFormatter) #,breaks = scales::pretty_breaks(n = 1)) #
  print(plot)
  if(is.null(pdf)==FALSE){
    ggsave(pdf, dpi=600, useDingbats=FALSE, width=width, height=height)
  }
  if(is.null(png)==FALSE){
    ggsave(png, device="png", dpi=600, width=width, height=height)
  }
}