# Soccer Rating Prediction

## 1. Purpose

The main purpose for this project is to predict the response `overall_rating` using the table `rating_potential` found in the data directory. We will generally build a model using various techniques we learn in class (GAM, Smoothing Spline, Regression Tree etc.), predict players' `overall_rating` based on the model we build and measure their performances with respect to their training error, test error, model complexity, variable importance and running time etc.

## 2. Preprocessing

We preprocess the dataset from the file `database.sqlite` extracted in the `data` directory. Basically, we join two tables `player` and `player_stats` into `rating_potential` and produce the output of `rating_potential.csv` file. Noted that the variable `gk_reflexes` has a partial samples in the range of 65 to 85. In order to reduce the variability and maintain the normality, we basically transform that partial samples into the range of 0 to 20. The response variable `overall_rating` will not be affected too much because it represents the overall average of each explanatory variable and the average will not change a lot by law of large number. We decide to use the csv file `rating_potential` as our main data source for this project.

## 3. Explanatory Data Analysis

We first read in the table `rating_potential` and display the correlation plot for each explanatory variable and corresponding response `overall_rating`. This will give us some observation on the dataset and perspective on how to build the model, but this correlation only assumes the model is linear. We also want to observe any relationship between the explanatory variable and response variable if the model is non-parametric. So we want to build both linear and non-parametric models with different assumptions.

## 4. Linear Model

### 4.1. Assumption

We assume the model is linear in parameters and each variable is identically independent distributed (i.i.d).

### 4.2. Algorithms
 Try the following algorithms:
1. Multiple Linear Regression
2. LASSO Regression
3. Ridge Regression

## 5. Non-parametric Model

### 5.1. Assumption

We assume the model needs not to be linear in parameters (i.e, it can be either linear or non-linear).

### 5.2. Algorithms

Try the following algorithms:
1. Generalized Additive Model (GAM)
2. Gradient Boosting (Tree-based)
3. Regression Tree
