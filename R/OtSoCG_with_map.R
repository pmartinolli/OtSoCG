

shell("cls") # clear console
setwd("C:/Users/martinop/Downloads/ttrpg-r-gv")


library(WikidataQueryServiceR) # calling of packages
library(igraph)


# Retrieve the data from Wikidata through SPARQL query and put in a variable named : ttrpg



ttrpg <- query_wikidata('SELECT DISTINCT ?citingLabel ?citedLabel 
WHERE
{
    {
      {?citing wdt:P31 wd:Q1643932}   # instance = TTRPG
      UNION                           # OR 
      {?citing wdt:P31 wd:Q2164067}   # instance = TTRPG system 
    }.
    ?citing  wdt:P2860    ?cited.     # which cites works
    {                                 # that are... (same)  
      {?cited wdt:P31 wd:Q1643932}
      UNION 
      {?cited wdt:P31 wd:Q2164067}
    }. 
    SERVICE wikibase:label { bd:serviceParam wikibase:language "en" }
}
ORDER BY ?citing ?cited')







#######################################################################
# arulesViz - Visualizing Association Rules and Frequent Itemsets
# Copyrigth (C) 2011 Michael Hahsler and Sudheer Chelluboina
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License along
# with this program; if not, write to the Free Software Foundation, Inc.,
# 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.

## mapping helper

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







net <- graph_from_data_frame(d=ttrpg, directed=T)  # directed=F => no arrow head






# Draw graph

plot(net, 
     edge.arrow.size = 0.05, 
     vertex.size=map(degree(net),c(1,20)), 
     vertex.color=map(degree(net),c(1,20)),
     vertex.label.cex=1, 
     vertex.label.family="Helvetica"
)




