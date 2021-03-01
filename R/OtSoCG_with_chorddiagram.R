# Import ttrpg games and publishers from Wikidata, draw a nice circlized chord diagram graph (by publishers)
# A significant part of citations are coming from other games of the same publisher



############# import data from Wikidata

#install.packages("WikidataQueryServiceR")
library(WikidataQueryServiceR) 
library(tidyverse)

ttrpg <- query_wikidata('SELECT DISTINCT ?gameLabel ?publisherLabel ?gamecitedLabel ?gamecitedpublisherLabel WHERE {

    ?game wdt:P31 wd:Q1643932.
    ?game wdt:P2860 ?gamecited.
    ?game (wdt:P577|wdt:P571) ?when1. #datepub or inception
    
    ?gamecited wdt:P31 wd:Q1643932.
    ?gamecited (wdt:P577|wdt:P571) ?when2.   #datepub or inception

 # FILTER(YEAR(?when1) >= 1970 && YEAR(?when1) <= 1999)
 # FILTER(YEAR(?when2) >= 1970 && YEAR(?when2) <= 1999)

  SERVICE wikibase:label { bd:serviceParam wikibase:language "en". }

  OPTIONAL {?game wdt:P123 ?publisher.}
  OPTIONAL {?gamecited wdt:P123 ?gamecitedpublisher.}
}
ORDER BY ?publisherLabel 
')

# adding manually some data
ttrpg <- rbind(ttrpg, c("Dungeons & Dragons: 1st ed. 1st print  « Woodgrain box »","TSR","Blackmoor",NA))





############# data cleaning

# renaming the columns
names(ttrpg) <- c("game", "publisher","gamecited","gamecited_publisher")

# merging similar publishers
for(i in 1:nrow(ttrpg)){
  ttrpg$publisher[i] <- ifelse((ttrpg$publisher[i]=="TSR"),"TSR-WotC",ttrpg$publisher[i])
  ttrpg$publisher[i] <- ifelse((ttrpg$publisher[i]=="Wizards of the Coast"),"TSR-WotC",ttrpg$publisher[i])
  ttrpg$gamecited_publisher[i] <- ifelse((ttrpg$gamecited_publisher[i]=="TSR"),"TSR-WotC",ttrpg$gamecited_publisher[i])
  ttrpg$gamecited_publisher[i] <- ifelse((ttrpg$gamecited_publisher[i]=="Wizards of the Coast"),"TSR-WotC",ttrpg$gamecited_publisher[i])  
}

# >>>>> to do <<<<<<
# remove rows when a GAME or GAMECITED have 2 differents publishers or replace by a new publisher which is the concatenation of Publisher1+Publisher1+...



# if a PUBLISHER or GAMECITEDPUBLISHER is empty : remove the row (a way to mitigate the size of the graph, if it is too big there is a bug)
ttrpg <- ttrpg[!is.na(ttrpg$publisher), ]
ttrpg <- ttrpg[!is.na(ttrpg$gamecited_publisher), ]


# formating and ordering
data <- data.frame(ttrpg$publisher,ttrpg$gamecited_publisher)



# drawing the graph
library(ggraph)
library(igraph)
library(circlize)

# Drawing the graph
chordDiagram(data, 
             transparency = 0.25,
             directional = 1,
             order = data$game,
             direction.type = c("arrows", "diffHeight"), 
             diffHeight  = -0.01,
             annotationTrack = "grid", 
             annotationTrackHeight = c(0.05, 0.1),
             preAllocateTracks = 1, 
             link.arr.type = "big.arrow", 
             link.sort = TRUE, 
             link.decreasing = TRUE,
)

# now, the image with rotated labels
circos.trackPlotRegion(track.index = 1, panel.fun = function(x, y) {
  xlim = get.cell.meta.data("xlim")
  ylim = get.cell.meta.data("ylim")
  sector.name = get.cell.meta.data("sector.index")
  circos.text(mean(xlim), ylim[1] + .1, cex = 0.7, sector.name, facing = "clockwise", niceFacing = TRUE, adj = c(0, 0.5))
  circos.axis(h = "top", labels.cex = 0.5, major.tick.length = 0.2, sector.index = sector.name, track.index = 2)
}, bg.border = NA)



# now, go the "Plot" panel of RStudio : Export > Save as PDF... > PDF size = 10x10 inches




# Credits (from specific to general)
#
# Yan Holtz and Conor Healy for their https://www.data-to-viz.com/graph/chord.html and https://www.r-graph-gallery.com/123-circular-plot-circlize-package-2.html 
#
# lukeA for rotating the labels https://stackoverflow.com/questions/31943102/rotate-labels-in-a-chorddiagram-r-circlize
#
# Mikhail Popov for his WikidataQueryServiceR package
# Hadley et al. for their tidyverse and dplyr packages
# Thomas Lin Pedersen for his ggraph package
# Gábor Csárdi et al. for their igraph package
# Zuguang Gu for his circlize package
# 
# Ross Ihaka and Robert Gentleman for the R language
# The developers of RStudio and the PDF format

