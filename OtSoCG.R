
######################################################
# Part 1 : Retrieve the data
######################################################


# Retrieve the data from Wikidata through SPARQL query and put in a variable named : ttrpg

library(WikidataQueryServiceR)

ttrpg <- query_wikidata('SELECT DISTINCT ?itemLabel ?cited_worksLabel 
WHERE
{
    {
      {?item wdt:P31 wd:Q1643932} 
      UNION 
      {?item wdt:P31 wd:Q2164067}
      UNION
      {?item wdt:P31 wd:Q71631512}
      UNION
      {?item wdt:P31 wd:Q4418079}      
    }. # instance = TTRPG or TTRPG system or supplement or setting
    ?item  wdt:P2860    ?cited_works. # which cites works
    {
      {?cited_works wdt:P31 wd:Q1643932}
      UNION 
      {?cited_works wdt:P31 wd:Q2164067}
      UNION
      {?cited_works wdt:P31 wd:Q71631512}
      UNION
      {?cited_works wdt:P31 wd:Q4418079} 
    }. # that are TTRPG or TTRPG system or supplement or setting  
    SERVICE wikibase:label { bd:serviceParam wikibase:language "en" }
}
ORDER BY ?item ?cited_works')



######################################################
# Part 2 : Draw a graph
######################################################

# Draw a graph from the variable : ttrpg

library(igraph)

net <- graph_from_data_frame(d=ttrpg, directed=T) 


# Use a function to weight each node with the number of cited works, from https://michael.hahsler.net/SMU/ScientificCompR/code/map.R
map <- function(x, range = c(0,1), from.range=NA) {
  if(any(is.na(from.range))) from.range <- range(x, na.rm=TRUE)
  
  ## check if all values are the same
  if(!diff(from.range)) return(
    matrix(mean(range), ncol=ncol(x), nrow=nrow(x), 
           dimnames = dimnames(x)))
  
  ## map to [0,1]
  x <- (x-from.range[1])
  x <- x/diff(from.range)
  ## handle single values
  if(diff(from.range) == 0) x <- 0 
  
  ## map from [0,1] to [range]
  if (range[1]>range[2]) x <- 1-x
  x <- x*(abs(diff(range))) + min(range)
  
  x[x<min(range) | x>max(range)] <- NA
  
  x
}



# Draw the graph

plot(net, 
     edge.arrow.size = 0.05, 
     vertex.size=map(degree(net),c(1,20)), 
     vertex.color=map(degree(net),c(1,20)),
     vertex.label.cex=1, 
     vertex.label.family="Helvetica"
     )

# Then go to Menu > Plots > Export > Save as PDF : (Device size) = 60 x 40  
