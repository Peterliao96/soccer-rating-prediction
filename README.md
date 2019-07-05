# Soccer Rating Prediction

## 1. Purpose

The main purpose for this project is to predict the response `overall_rating` using the table `rating_potential` found in the data directory. We will generally build a model using various techniques we learn in class (GAM, Smoothing Spline, Regression Tree etc.), predict players' `overall_rating` based on the model we build and see which method we use have the best performance.

## 2. Preprocessing

We preprocess the dataset from the file `database.sqlite` extracted in the data directory. Basically, we join two tables `player` and `player_stats` into `rating_potential` and produce the output of `rating_potential.csv` file. We decide to use this csv file as our main data source for this project.

## 3. Data Visualization

We first read in the table `rating_potential` and display the correlation plot for each explanatory variable and corresponding response `overall_rating`. This will give us some observation on the dataset and perspective on how to build the model, but this correlation only assumes the model is linear. We also want to observe any relationship between the explanatory variable and response variable if the model is non-linear. So we want to build both linear and non-linear model with different assumptions.

## 4. Linear Model

### 4.1. Assumption

We assume the model is linear in parameters and each variable is identically independent distributed (i.i.d).

### 4.2. Algorithms
 Try the following algorithms:
1. Multiple Linear Regression
2. LASSO Regression
3. Ridge Regression

## 5. Non-linear Model

### 5.1. Assumption

We assume the model needs not to be linear in parameters (i.e, it can be either linear or non-linear).

### 5.2. Algorithms

Try the following algorithms:
1. s Smooth in Generalized Additive Model (GAM)
2. Tensor Product Smoothing
3. Regression Tree
