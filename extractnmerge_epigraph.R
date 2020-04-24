# extracting the data from wikidata and merging with local data

# more specifically : merge with epigraph variable, coded as follow :
# l : literary, written arts
# a : academic, essay
# h : historical
# r : religious
# p : pseudo-historical
# f : in fiction / purely diegetic
# s : several (more than 10)
# g : game designers
# m : music
# c : cinema/tv
# v : videogame
# b : bd, manga, comics
# u : unknown


shell("cls") # clear console
library(WikidataQueryServiceR) # calling of packages
setwd("C:/Users/martinop/OneDrive - Universite de Montreal/perso/en_cours/OtSoCG/R")

# Retrieve the data from Wikidata through SPARQL query and put in a variable named : ttrpg_base
# Only retrieve rpgs that cite another

wikidata_data <- query_wikidata('SELECT DISTINCT ?citing ?citingLabel WHERE {
  {
    { ?citing wdt:P31 wd:Q1643932. }
    UNION
    { ?citing wdt:P31 wd:Q2164067. }
    UNION
    { ?citing wdt:P31 wd:Q71631512. }
    UNION
    { ?citing wdt:P31 wd:Q4418079. }
  }
 # ?citing wdt:P2860 ?cited. #unactivated, if activated it will select only the one that cites work
  SERVICE wikibase:label { bd:serviceParam wikibase:language "en". }
}
ORDER BY (?citingLabel)')

# importing local csv containing other data and creating a backup (without column #1)
local_data <- read.csv("data/local_epigraph_data.csv")
write.csv(local_data[,-1],"data/local_epigraph_data.csv.bak")

# merging 

merged_data <- merge(wikidata_data, local_data, by.x="citing", by.y="citing", all = TRUE)

# deleting the useless columns (#3 = csv_id; #4 = citingLabel)
merged_data <- merged_data[,-c(3,4)]  #deleting the csv_id column

# replace the old local_data by the new one
write.csv(merged_data,"data/local_epigraph_data.csv")

