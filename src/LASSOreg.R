# ---
# title: "Soccer Player Rating Prediction"
# responsiblity: LASSO Regression
# author: 
# Junqi Liao 20650701
# 
# 
# 
# date: "31 July 2019"
# output: data plot 
# ---
#  

# Visualize the data plot and see if each player attribute has correlation to each other
library(RSQLite)
library(dplyr)
library(glmnet)
library(caret)

set.seed(123)
# extract the zip database file in the data folder and set your own db path
con <- dbConnect(SQLite(), dbname="/Users/peterliao/Desktop/stat/stat444/project1/data/database.sqlite")
dbListTables(con)

rating_potential<- tbl_df(dbGetQuery(con,"SELECT * FROM rating_potential"))

rating_potential$set <- ifelse(runif(n=nrow(rating_potential))>0.8, yes=2, no=1)
df.rating_potential <- as.data.frame(rating_potential)
ytrain <- as.matrix(rating_potential[which(rating_potential$set==1),2])
xtrain <- as.matrix(rating_potential[which(rating_potential$set==1),c(3:32)])
xtrain.scaled <- scale(xtrain)
ytest <- as.matrix(rating_potential[which(rating_potential$set==2),2])
xtest <- as.matrix(rating_potential[which(rating_potential$set==2),c(3:32)])
xtest.scaled <- scale(xtest)

lasso.1 <- glmnet(y=ytrain, x= xtrain, family="gaussian")

# Coefficent path without scaling
plot(lasso.1)

lasso.2 <- glmnet(y=ytrain, x= xtrain.scaled, family="gaussian")

# Coefficent path with scaling
plot(lasso.2)

# use cross validation to estimate optimal lambda
cv.lasso.1 <- cv.glmnet(y=ytrain, x= xtrain, family="gaussian")
cv.lasso.2 <- cv.glmnet(y=ytrain, x= xtrain.scaled, family="gaussian")

plot(cv.lasso.1)
plot(cv.lasso.2)

# Predict both halves using first-half fit
predict.train <- predict(cv.lasso.1, newx=xtrain)
predict.test <- predict(cv.lasso.1, newx=xtest)
MSE.lasso <- mse(ytrain, predict.train)
MSPE.lasso <- mse(ytest,predict.test)

predict.train.scaled <- predict(cv.lasso.2, newx=xtrain.scaled)
predict.test.scaled <- predict(cv.lasso.2, newx=xtest.scaled)
MSE.lasso.scaled <- mse(ytrain, predict.train.scaled)
MSPE.lasso.scaled <- mse(ytest,predict.test.scaled)
t<-as.table(rbind(c(MSE.lasso,MSE.lasso.scaled),c(MSPE.lasso,MSPE.lasso.scaled)))
colnames(t) <- c("without scaling","with scaling")
rownames(t) <- c("MSE","MSPE")

# variable importance function
varImp <- function(object, lambda = NULL, ...) {
  
  ## skipping a few lines
  
  beta <- predict(object, s = lambda, type = "coef")
  if(is.list(beta)) {
    out <- do.call("cbind", lapply(beta, function(x) x[,1]))
    out <- as.data.frame(out)
  } else out <- data.frame(Overall = beta[,1])
  out <- abs(out[rownames(out) != "(Intercept)",,drop = FALSE])
  out
}

# plot variable importance
vari<-varImp(cv.lasso.2,lambda = cv.lasso.1$lambda.min)
sort(vari[,1])
varImp(cv.lasso.2,lambda = cv.lasso.1$lambda.1se)






