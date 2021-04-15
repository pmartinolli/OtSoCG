# extract from GitHub

epigraph_tab <- read.csv("https://raw.githubusercontent.com/pmartinolli/OtSoCG/master/data/epigraph_data.csv")



# install.packages("sqldf")
library(sqldf)


## TTRPGs with the most forged epigraphs

most_forged <- sqldf("SELECT label,edition,nb_forged FROM epigraph_tab 
      ORDER BY nb_forged DESC 
      LIMIT 20", row.names = TRUE)
most_forged



## TTRPGs with the most cited works in their epigraphs

most_citedworks <- sqldf("SELECT label,edition,nb_work FROM epigraph_tab 
      ORDER BY nb_work DESC 
      LIMIT 10", row.names = TRUE)
most_citedworks



## TTRPGs with confusing mix of true and fictive epigraphs

### counting
confusing_mix_count <- sqldf("SELECT COUNT(confusing_mix)
FROM epigraph_tab
WHERE confusing_mix='x';", row.names = TRUE)
confusing_mix_count

### listing
confusing_mix_list <- sqldf("SELECT label,edition
      FROM epigraph_tab 
      WHERE confusing_mix='x'
      ORDER BY label ASC", row.names = TRUE)
confusing_mix_list



# creating a table with counting data on types of epigraphs

most_types <- matrix(c(sum(epigraph_tab$academic!="",na.rm = TRUE),
                       sum(epigraph_tab$literature!="",na.rm = TRUE),
                       sum(epigraph_tab$historical!="",na.rm = TRUE),
                       sum(epigraph_tab$music!="",na.rm = TRUE),
                       sum(epigraph_tab$religious!="",na.rm = TRUE),
                       sum(epigraph_tab$game!="",na.rm = TRUE),  
                       sum(epigraph_tab$unknown!="",na.rm = TRUE),
                       sum(epigraph_tab$bd!="",na.rm = TRUE),
                       sum(epigraph_tab$cinema!="",na.rm = TRUE),
                       sum(epigraph_tab$videogame!="",na.rm = TRUE),
                       sum(epigraph_tab$franchise!="",na.rm = TRUE),
                       sum(epigraph_tab$confusing_mix!="",na.rm = TRUE)
),ncol=1,byrow=TRUE)
colnames(most_types) <- c("Count")
rownames(most_types) <- c("academic","literature","historical","music","religious","game","unknown","bd, comic, manga","cinema","videogame","franchise","confusing mix")

#turn it in a dataframe
most_types <- as.data.frame(most_types) 

most_types

