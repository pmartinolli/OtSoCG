# Import ttrpg games and publishers from Wikidata, draw a nice circlized connection graph (the games are grouped by publishers)
#
# simple design, no colors

############# import data from Wikidata

#install.packages("WikidataQueryServiceR")
library(WikidataQueryServiceR) 

ttrpg <- query_wikidata('SELECT DISTINCT ?gameLabel ?publisherLabel ?gamecitedLabel ?gamecitedpublisherLabel WHERE {

    ?game wdt:P31 wd:Q1643932.
    ?game wdt:P2860 ?gamecited.
    ?game (wdt:P577|wdt:P571) ?when1. #datepub or inception
    
    ?gamecited wdt:P31 wd:Q1643932.
    ?gamecited (wdt:P577|wdt:P571) ?when2.   #datepub or inception

  #FILTER(YEAR(?when1) >= 1970 && YEAR(?when1) <= 1999)
  #FILTER(YEAR(?when2) >= 1970 && YEAR(?when2) <= 1999)

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



# create a vertices one line per game (leaf)
vertices = data.frame(
  name = unique(c(as.character(hierarchy$from), as.character(hierarchy$to)))) 



######### drawing the graph

library(ggraph)
library(igraph)
library(circlize)
library(tidyverse)
theme_set(theme_void())

# Create a graph object with the igraph library
mygraph <- graph_from_data_frame( hierarchy, vertices=vertices )


# With igraph: 
plot(mygraph, edge.arrow.size=1, vertex.size=2)

ggraph(mygraph, layout = 'dendrogram', circular = TRUE) + 
  geom_edge_diagonal() +
  geom_node_text(aes( label=name, filter=leaf)) +
  geom_node_point(aes(filter = leaf, x = x*1.07, y=y*1.07,  alpha=0.2)) +
  theme_void()

# The connection object refers to the ids of the leaves:
from <- match( ttrpg$game, vertices$name)
to <- match( ttrpg$gamecited, vertices$name)

# plot
ggraph(mygraph, layout = 'dendrogram', circular = TRUE) + 
  geom_conn_bundle(data = get_con(from = from, to = to), colour="skyblue") + 
  geom_node_point(aes(filter=leaf, x = x, y = y)) +
  geom_node_text(aes(filter=leaf, label=name )) +
  theme_void()

# now, go the "Plot" panel of RStudio : Export > Save as PDF... > PDF size = 70x70 inches


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
