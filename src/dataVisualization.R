# ---
# title: "Soccer Player Rating Prediction"
# author: 
# Junqi Liao 20650701
# Raymond Tan 
# 
# 
# date: "31 July 2019"
# output: data plot 
# ---
#  

# Visualize the data plot and see if each player attribute has correlation to each other
library(RSQLite)
library(dplyr)

# extract the zip database file in the data folder and set your own db path
con <- dbConnect(SQLite(), dbname="/Users/peterliao/Desktop/stat/stat444/project1/data/database.sqlite")
dbListTables(con)

rating_potential<- tbl_df(dbGetQuery(con,"SELECT * FROM rating_potential"))

# correlation plot
library(corrplot)
corrplot(cor(rating_potential[,-c(1,32)]))

# since short_passing, long_passing, reactions, vision have a higher correlation,
# we pair them with the response variable overall_rating and see the scatterplot 
# matrix
pairs(overall_rating~short_passing  +  long_passing+reactions+
        vision,data=rating_potential, 
      main="Simple Scatterplot Matrix")


