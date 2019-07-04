# ---
# title: "Quick gam model"
# author: "Junqi Liao, Raymond Tan and "
# date: "10 dicembre 2016"
# output: html_document
# ---
#  **Quick Gam Model**
  

# Importing data and join together player_attributes with player

library(RSQLite)
library(dplyr)
con <- dbConnect(SQLite(), dbname="/Users/peterliao/Desktop/stat/stat444/project/data/database.sqlite")
dbListTables(con)

# processing the data
player<- tbl_df(dbGetQuery(con,"SELECT * FROM player"))
player_stats<- tbl_df(dbGetQuery(con,"SELECT * FROM Player_Attributes"))

# join player and player_stats into one table
joint_player_stats<-  player_stats %>%
  rename(player_stats_id = id) %>%
  left_join(player, by = "player_api_id")

#average of overall rating , average of potential 
rating_potential<-aggregate(cbind(overall_rating,potential,crossing,finishing,heading_accuracy,short_passing,volleys,dribbling,curve,free_kick_accuracy,long_passing,ball_control,acceleration,sprint_speed,       
                                  agility,reactions, balance  ,           
                                  shot_power,jumping,stamina  ,           
                                  strength,long_shots,aggression    ,      
                                  interceptions,positioning,vision   ,           
                                  penalties,marking,standing_tackle ,    
                                  sliding_tackle,gk_reflexes)~factor(player_name),data=joint_player_stats,mean)
colnames(rating_potential)[1]<-"player_name"

# write the table rating_potential.csv to Github for teammate use
write.table(rating_potential, file = "rating_potential.csv")
dbDisconnect(con)
