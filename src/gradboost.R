# ---
# title: "Soccer Player Rating Prediction"
# author: 
# Junqi Liao 20650701
# 
# 
# 
# date: "31 July 2019"
# output: data plot 
# ---
#  
set.seed(123)
# Visualize the data plot and see if each player attribute has correlation to each other
library(RSQLite)
library(dplyr)
library(mgcv)
library(gbm)
library(caret)
library(xgboost)
library(Metrics)

# extract the zip database file in the data folder and set your own db path
con <- dbConnect(SQLite(), dbname="/Users/peterliao/Desktop/stat/stat444/project1/data/database.sqlite")
dbListTables(con)

rating_potential<- tbl_df(dbGetQuery(con,"SELECT * FROM rating_potential"))

rating_potential$set <- ifelse(runif(n=nrow(rating_potential))>0.75, yes=2, no=1)
df.rating_potential <- as.data.frame(rating_potential)
nrow(as.matrix(df.rating_potential[which(df.rating_potential$set==1),c(3:32)]))

# check dimension
dim(df.rating_potential)

# split the dataset into training set and test set
xtrain<-as.matrix(df.rating_potential[which(df.rating_potential$set==1),c(3:32)])
ytrain<-df.rating_potential[which(df.rating_potential$set==1),2]
dtrain<- xgb.DMatrix(data=xtrain,label=ytrain)
xtest<-as.matrix(df.rating_potential[which(df.rating_potential$set==2),c(3:32)])
ytest<-df.rating_potential[which(df.rating_potential$set==2),2]
dtest<- xgb.DMatrix(data=xtest,label=ytest)

# tune parameters using gradient boosting
caret::train(method="xgbTree",x=xtrain,y=ytrain)

# define parameters from tuning results
params = list(metric=list("rmse","auc"),
              tuneLength=150,
              model="xgb",
              max_depth=3,
              eta=1,
              cvfolds=5,
              gamma = 0, colsample_bytree = 0.8, min_child_weight = 1,subsample=1)


watchlist<- list(train = dtrain, eval = dtest)

rating.boost <-xgb.train(booster="dart",data=dtrain,nrounds = 150,params = params,metrics=list("rmse","auc"),watchlist = watchlist)

# compute predicted value for training set and test set
pred.test.rating<-predict(rating.boost,xtest)
pred.train.rating<-predict(rating.boost,xtrain)

# evaluate MSPE and sMSE
sqrt(mse(ytest,pred.test.rating))
sqrt(mse(ytrain,pred.train.rating))

plot(rating.boost$evaluation_log$iter,rating.boost$evaluation_log$train_rmse,xlab='# of iteration',ylab='training error',main='training error vs. # of iteration')
plot(rating.boost$evaluation_log$iter,rating.boost$evaluation_log$eval_rmse,xlab='# of iteration',ylab='test error', main='test error vs. # of iteration')

# plot variable importance
xgb.plot.importance(xgb.importance(model=rating.boost),xlab='Gain',main='Variable Importance Plot')

# plot model complexity
xgb.plot.deepness(rating.boost)

# save the model locally for self using purpose
xgb.save(rating.boost,'rating.boost.Rdata')

# more exploration on grid search method
cv.ctrl <- trainControl(method = "repeatedcv", repeats = 1,number = 5)

xgb.grid <- expand.grid(nrounds = c(50,150,300,600,1200,2400),
                        max_depth = 3,
                        eta =seq(0.1,1,0.1),
                        gamma = 0,
                        colsample_bytree = 0.8,
                        min_child_weight=1,
                        subsample=1
)

xgb_tune <-train(overall_rating ~.,
                 data=df.rating_potential[which(df.rating_potential$set==1),c(2:32)],
                 method="xgbTree",
                 metric = "RMSE",
                 trControl=cv.ctrl,
                 tuneGrid=xgb.grid
)

pred2.test.rating <- predict(xgb_tune, xtest)
pred2.train.rating <-predict(xgb_tune, xtrain)
sqrt(mse(ytest,pred2.test.rating))
sqrt(mse(ytrain, pred2.train.rating))

# plot variable importance
xgb.plot.importance(xgb.importance(model=xgb_tune$finalModel),xlab='Gain',main='Variable Importance Plot')

# plot model complexity
xgb.plot.deepness(xgb_tune$finalModel)

df.n50fixed<-xgb_tune$results[which(xgb_tune$results$nrounds == 50),c(1,7,8)]
df.n150fixed<-xgb_tune$results[which(xgb_tune$results$nrounds == 150),c(1,7,8)]
df.n300fixed<-xgb_tune$results[which(xgb_tune$results$nrounds == 300),c(1,7,8)]
df.n600fixed<-xgb_tune$results[which(xgb_tune$results$nrounds == 600),c(1,7,8)]
df.n1200fixed<-xgb_tune$results[which(xgb_tune$results$nrounds == 1200),c(1,7,8)]
df.n2400fixed<-xgb_tune$results[which(xgb_tune$results$nrounds == 2400),c(1,7,8)]
plot(df.n50fixed$eta,df.n50fixed$RMSE,type='l',col='blue',ylim = c(1,2),xlab='shrinkage',ylab='MSPE',main = 'MSPE vs. shrinkage')
lines(df.n150fixed$eta,df.n150fixed$RMSE,type='l',col='orange')
lines(df.n300fixed$eta,df.n300fixed$RMSE,type='l',col='red')
lines(df.n600fixed$eta,df.n600fixed$RMSE,type='l',col='purple')
lines(df.n1200fixed$eta,df.n1200fixed$RMSE,type='l',col='green')
lines(df.n2400fixed$eta,df.n2400fixed$RMSE,type='l',col='lightblue')
# Add a legend
legend(0.67, 1.52, legend=c("nrounds = 50", "nrounds = 150",
                       "nrounds = 300", "nrounds = 600",
                       "nrounds = 1200", "nrounds = 2400"),
       col=c("blue", "orange","red","purple", "green","lightblue"), lty=1:1)

df.eta0.1fixed<-xgb_tune$results[which(xgb_tune$results$eta == 0.1),c(1,7,8)]
df.eta0.2fixed<-xgb_tune$results[which(xgb_tune$results$eta == 0.2),c(1,7,8)]
df.eta0.3fixed<-xgb_tune$results[which(xgb_tune$results$eta == 0.3),c(1,7,8)]
xgb_tune$results$eta[1] == 0.1
df.eta0.4fixed<-xgb_tune$results[which(xgb_tune$results$eta == 0.4),c(1,7,8)]
df.eta0.5fixed<-xgb_tune$results[which(xgb_tune$results$eta == 0.5),c(1,7,8)]
df.eta0.6fixed<-xgb_tune$results[which(xgb_tune$results$eta == 0.6),c(1,7,8)]
df.eta0.7fixed<-xgb_tune$results[which(xgb_tune$results$eta == 0.7),c(1,7,8)]
df.eta0.8fixed<-xgb_tune$results[which(xgb_tune$results$eta == 0.8),c(1,7,8)]
df.eta0.9fixed<-xgb_tune$results[which(xgb_tune$results$eta == 0.9),c(1,7,8)]
df.eta1.0fixed<-xgb_tune$results[which(xgb_tune$results$eta == 1),c(1,7,8)]
plot(df.eta0.1fixed$nrounds,df.eta0.1fixed$RMSE,type='l',col='blue',ylim=c(1,4.5),xlab='iteration',ylab='MSPE',main='MSPE vs. # of iteration')
lines(df.eta0.2fixed$nrounds,df.eta0.2fixed$RMSE,type='l',col='orange')
lines(df.eta0.4fixed$nrounds,df.eta0.4fixed$RMSE,type='l',col='purple')
lines(df.eta0.5fixed$nrounds,df.eta0.5fixed$RMSE,type='l',col='green')
lines(df.eta0.6fixed$nrounds,df.eta0.6fixed$RMSE,type='l',col='lightblue')
lines(df.eta0.8fixed$nrounds,df.eta0.8fixed$RMSE,type='l',col='grey')
lines(df.eta0.9fixed$nrounds,df.eta0.9fixed$RMSE,type='l',col='pink')
lines(df.eta1.0fixed$nrounds,df.eta1.0fixed$RMSE,type='l',col='darkgreen')
legend(1850,4.63, legend=c("eta = 0.1", "eta = 0.2",
                            "eta = 0.4", "eta = 0.5",
                            "eta = 0.6", "eta = 0.8",
                            "eta = 0.9", "eta = 1.0"),
       col=c("blue", "orange","purple", "green","lightblue","grey","pink","darkgreen"), lty=1:1)










