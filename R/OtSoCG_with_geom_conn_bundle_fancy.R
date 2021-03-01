# Import ttrpg games and publishers from Wikidata, draw a nice circlized connection graph (the games are grouped by publishers)
#
# fancy colors and label orientations, still under construction because :
#   - the label orientation doesnt work
#   - I would like to color the connections with the color of the labels of the game (not game cited)

############# import data from Wikidata

#install.packages("WikidataQueryServiceR")
library(WikidataQueryServiceR) 

ttrpg <- query_wikidata('SELECT DISTINCT ?gameLabel ?publisherLabel ?gamecitedLabel ?gamecitedpublisherLabel WHERE {

    ?game wdt:P31 wd:Q1643932.
    ?game wdt:P2860 ?gamecited.
    ?game (wdt:P577|wdt:P571) ?when1. #datepub or inception
    
    ?gamecited wdt:P31 wd:Q1643932.
    ?gamecited (wdt:P577|wdt:P571) ?when2.   #datepub or inception

  # FILTER(YEAR(?when1) >= 1970 && YEAR(?when1) <= 1999)  # no filter = all years
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



# if a PUBLISHER or GAMECITEDPUBLISHER is empty : replace by a unique identifier (game+_pub)
for(i in 1:nrow(ttrpg)){
  ttrpg$publisher[i] <- ifelse(is.na(ttrpg$publisher[i]), paste(ttrpg$game[i],"pub",sep=''),ttrpg$publisher[i])
  ttrpg$gamecited_publisher[i] <- ifelse(is.na(ttrpg$gamecited_publisher[i]), paste(ttrpg$gamecited[i],"_Pub",sep=''),ttrpg$gamecited_publisher[i])
}




############## Building the structure of the graph 

# create a data frame giving the hierarchical structure of the games and publishers. 
# Origin on top, then groups (publishers), then subgroups (games). Subgroups are the leaves.

library(dplyr) #for the "distinct()" function

group1 <- data.frame("origin",ttrpg$publisher)
names(group1) <- c("from", "to")
group2 <- data.frame("origin",ttrpg$gamecited_publisher)
names(group2) <- c("from", "to")
group <- rbind (group1,group2)
group <- distinct(group, to, .keep_all = TRUE)

subgroup1 <- data.frame(ttrpg$publisher,ttrpg$game)
names(subgroup1) <- c("from","to")
subgroup2 <- data.frame(ttrpg$gamecited_publisher,ttrpg$gamecited)
names(subgroup2) <- c("from","to")
subgroup <- rbind (subgroup1,subgroup2)
subgroup <- distinct(subgroup, to, .keep_all = TRUE)

hierarchy <- rbind(group, subgroup)
hierarchy <- distinct(hierarchy, to, .keep_all = TRUE)

#hierarchy$value <- runif(nrow(hierarchy))


# create a vertices one line per game (leaf)
vertices = data.frame(
  name = unique(c(as.character(hierarchy$from), as.character(hierarchy$to)))) 



###### Preparing the graph

# Let's add a column with the group of each name. It will be useful later to color points
vertices$group  <-  hierarchy$from[ match( vertices$name, hierarchy$to ) ]


#Let's add information concerning the label we are going to add: angle, horizontal adjustement and potential flip
#calculate the ANGLE of the labels
vertices$id <- NA
myleaves <- which(is.na( match(vertices$name, hierarchy$from) ))
nleaves <- length(myleaves)
vertices$id[ myleaves ] <- seq(1:nleaves)
vertices$angle <- 90 - 360 * vertices$id / nleaves

# calculate the alignment of labels: right or left
# If I am on the left part of the plot, my labels have currently an angle < -90
vertices$hjust <- ifelse( vertices$angle < -90, 1, 0)

# flip angle BY to make them readable
vertices$angle <- ifelse(vertices$angle < -90, vertices$angle+180, vertices$angle)






######### drawing the graph

library(ggraph)
library(igraph)
library(circlize)
library(RColorBrewer)
library(tidyverse)
theme_set(theme_void())

# Create a graph object with the igraph library
mygraph <- graph_from_data_frame( hierarchy, vertices=vertices )


# With igraph: 
plot(mygraph, edge.arrow.size=1, vertex.size=2)

# The connection object refers to the ids of the leaves:
from <- match( ttrpg$game, vertices$name)
to <- match( ttrpg$gamecited, vertices$name)

# plot

ggraph(mygraph, layout = 'dendrogram', circular = TRUE) + 
  geom_conn_bundle(data = get_con(from = from, to = to), alpha=0.2, width=0.9, aes(colour=..index..), tension=0.7) +
  scale_edge_colour_distiller(palette = "RdPu") +
  
  geom_node_text(aes(x = x*1.15, y=y*1.15, filter = leaf, label=name, angle = angle, hjust=hjust, colour=group), size=2, alpha=1) +
  
  geom_node_point(aes(filter = leaf, x = x*1.07, y=y*1.07, #with 1.07 the bullets are midway between the connection and the label
                      colour=group, 
                      #size=value, 
                      alpha=0.2)) +
  scale_colour_manual(values= rep( brewer.pal(9,"Paired") , 70)) +  # I changed 30 to 70 because there was a limit in the number of colors for big graphs
  scale_size_continuous( range = c(0.1,10) ) +
  
  theme_void() +
  theme(
    legend.position="none",
    plot.margin=unit(c(0,0,0,0),"cm"),
  ) +
  expand_limits(x = c(-1.3, 1.3), y = c(-1.3, 1.3))



# now, go the "Plot" panel of RStudio : Export > Save as PDF... > PDF size = 50x50 inches




# Credits (from specific to general)
#
# Yan Holtz for his https://www.r-graph-gallery.com/hierarchical-edge-bundling.html and https://www.data-to-viz.com/graph/edge_bundling.html
#
# Mikhail Popov for his WikidataQueryServiceR package
# Hadley et al. for their tidyverse and dplyr packages
# Thomas Lin Pedersen for his ggraph package
# Gábor Csárdi et al. for their igraph package
# Zuguang Gu for his circlize package
# 
# Ross Ihaka and Robert Gentleman for the R language
# The developers of RStudio and the PDF format

