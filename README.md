# Soccer Rating Prediction

## 1. Purpose

The main purpose for this project to predict the response `overall_rating` using the table `rating_potential` found in the data directory. We will generally build a model using various techniques we learn in class (GAM, Smoothing Spline, Regression Tree etc.), predict players' `overall_rating` based on the model we build and see which method we use have the best performance.

## 2. Preprocessing

We preprocess the dataset from the file `database.sqlite` extracted in the data directory. Basically, we join two tables `player` and `player_stats` into `rating_potential` and produce the output of `rating_potential.csv` file. We decide to use this csv file as our main data source for this project.

## 3. Data Visualization

We first read in the table `rating_potential` and display the correlation plot for each explanatory variable and corresponding response `overall_rating`. This will give us some observation on the dataset and perspective on how to build the model, but this correlation only assumes the model is linear. We also want to observe any relationship between the explanatory variable and response variable if the model is non-linear.

## 4. Multiple Linear Regression

### 4.1. Assumption

We assume the model is linear in parameters.

### 4.2. Step

Model Selection (BIC, stepwise selection etc) -> fit the model -> evaluate the model

## 5. Generalized Additive Model (GAM)

### 5.1. Assumption

We assume the model needs not to be linear in parameters (i.e, it can be either linear or non-linear).
