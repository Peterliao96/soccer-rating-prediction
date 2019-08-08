# ---
# title: "Soccer Player Rating Prediction"
# author: 
# Junqi Liao 20650701
# Raymond Tan 
# 
# 
# date: "31 July 2019"
# output: csv file
# ---
#  
  

# Importing data and join together player_attributes with player

library(RSQLite)
library(dplyr)

# extract the zip database file in the data folder and set your own db path
con <- dbConnect(SQLite(), dbname="/Users/peterliao/Desktop/stat/stat444/project/data/database.sqlite")
dbListTables(con)

# processing the data
player<- tbl_df(dbGetQuery(con,"SELECT * FROM player"))
player_stats<- tbl_df(dbGetQuery(con,"SELECT * FROM Player_Attributes"))

# join player and player_stats into one table
joint_player_stats<-  player_stats %>%
  rename(player_stats_id = id) %>%
  left_join(player, by = "player_api_id")

# check dimension
dim(joint_player_stats)

#average of overall rating , average of potential 
rating_potential<-aggregate(cbind(overall_rating,potential,crossing,finishing,heading_accuracy,short_passing,volleys,dribbling,curve,free_kick_accuracy,long_passing,ball_control,acceleration,sprint_speed,       
                                  agility,reactions, balance  ,           
                                  shot_power,jumping,stamina  ,           
                                  strength,long_shots,aggression    ,      
                                  interceptions,positioning,vision   ,           
                                  penalties,marking,standing_tackle ,    
                                  sliding_tackle,gk_reflexes)~factor(player_name),data=joint_player_stats,mean)
colnames(rating_potential)[1]<-"player_name"

# check dimension again
dim(rating_potential)

# some observations for specific attributes
hist(rating_potential[,2:32]$gk_reflexes, xlab='gk_reflexes', main='Histogram of gk_reflexes before transformation')

transform.gk_reflexes<-function(x){
  ifelse(x > 25,x-55,x)
}
rating_potential[,2:32]$gk_reflexes<- transform.gk_reflexes(rating_potential[,2:32]$gk_reflexes)
hist(rating_potential$gk_reflexes,xlab='gk_relexes',main='Histogram of gk_reflexes after transformation')

# check if there is NA
colSums(is.na(rating_potential))
# dbWriteTable(con, 'rating_potential',rating_potential,overwrite = TRUE)
# write the table rating_potential.csv to Github for teammate use
write.table(rating_potential, file = "rating_potential.csv")
dbDisconnect(con)
