#Libraries-------------------
library(ISLR)
library(tidyverse)
library(magrittr)
library(glmnet)
library(grpreg)
library(mvtnorm)
library(ggplot2)
require(class)
require(pROC)
require(GGally)
require(dplyr)
require(factoextra)
require(ggplot2)
library(plotly)
library(MASS)
require(gam)
library(mvtnorm)
library(cluster)
library(ggpubr)
library(mclust)
require(gridExtra)
library(splines)
require(gam)
require(grid)
require(splines)
require(mgcv)
require(rmarkdown)
library(magrittr)
library(dplyr) 
require(dplyr)
#data load
data <- read_delim("WineQuality.csv", delim=",")
glimpse(data) #first let's look at the data
summary(data)
dim(data)#size of the dataset

#all the variables are numeric 
#omitting the NAs
data <- na.omit(data)
#deleting the duplicates
any(duplicated(data)) #we see that there are some duplicates
data <-distinct(data)  #so we get rid of it
#Removing outliers
dim(data) #dim of rows and cols
boxplot(data)
data <- data.frame(data)
#remove the outliers from every predictor except quality
for(i in colnames(data)[1:11]) { 
  print(colnames(data))
  boxplot(data[,i],ylab=i,col="lightblue") #making for every variable a boxplot before taking out the outliers
  quartiles <- quantile(data[,i], probs=c(.15, .95), na.rm = FALSE)
  IQR <- IQR(data[,i])
  Lower <- quartiles[1] - 1.5*IQR
  Upper <- quartiles[2] + 1.5*IQR 
  data<- subset(data, data[,i] > Lower & data[,i] < Upper)
  boxplot(data[,i],ylab=i,col="lightblue") #making for every variable a boxplot
}
#check that outliers have been removed
boxplot(data, font.main=3, cex.main=1.2, xlab="quality",col="darkgreen")

#Insights on data-----------

#variable quality seems to be discrete
plot(data$quality, ylab="quality", col="lightgreen")
table(data$quality)
table(data$quality)/length(data$quality)
#we want to look at the most significant variables: we choose the correlation matrix
#let's see at the correlations
data %>% cor() %>% corrplot::corrplot() 
data %>%  ggcorr()
#we observe that there is very high correlation in absolute values between 
#alcohol and quality
#residual sugar and density
#alcohol and density

#Then we plot the relationship between the density and the alcohol and residual.sugar. We observe that density seems to be directly proportional to residual.sugar while alcohol is inversely proportional to density. They also both seem to be linearly dependent to density.
p1 = 
  ggplot(data, aes(x=alcohol, y=density))+
  geom_point(alpha=0.5,col="lightsalmon")

p2 =
  ggplot(data, aes(x=residual.sugar, y=density))+
  geom_point(alpha=0.5,col="forestgreen")

grid.arrange(p1,p2)

#Barplot to show the distribution of quality in wines: most have quality around 4 and 8
data2 <-data.frame(data)
quality_count <- data2 %>%
  group_by(quality) %>%
  summarise(counts = n())
ggplot(quality_count, aes(x = quality, y = counts)) +
  geom_bar(fill = "#0073C2FF", stat = "identity") +
  geom_text(aes(label = counts), vjust = -0.3) + 
  theme_pubclean()

#We confirm that there is a positive linear relationship between alcohol and quality: for high values of quality (6,7,8) there are high values of alcohol
#install.packages("fmsb")
require(radarchart)
options(repr.plot.width=7, repr.plot.height=5.5)  #Setting the plot size
alcohol.quality <- data %>%
  group_by(quality) %>%
  summarise(alcohol_mean = mean(alcohol))
require(fmsb)
alcohol_quality <- as.data.frame(t(alcohol.quality))
names(alcohol_quality) <- paste('Quality',alcohol_quality[1,], sep = '-')
alcohol_quality <- alcohol_quality[2,]
alcohol_quality=rbind(rep(12.4,6) , rep(9.6,6) , alcohol_quality)
radarchart(alcohol_quality, axistype=1, calcex = 0.8, vlcex=0.9,
           caxislabels = c('8,40','','10.50','','14.20'),
           title="Values of alcohol by quality labels")

#Alcohol in wines
curve1 <- ggplot(data, aes(x = alcohol,)) +
  geom_density(color="#FF66FF", fill="salmon") + labs(title="alcohol in the wines")
curve1+geom_vline(aes(xintercept=mean(alcohol)),
                  color="blue", linetype="twodash", size=0.25)

#Most wines have a density value between 0,90 and 1 
data2 %>%
  ggplot(aes(x = density, fill = cut(quality, 100))) + 
  geom_histogram(show.legend = FALSE, bins=50) 

#insights on volatile acidity against density: there seems to be a normal distribution 
curve1<-ggplot(data, aes(x = volatile.acidity)) +
  geom_density(color="#FF66FF", fill="lightblue") + labs(title="distribution of volatile.acidity against density")
curve1+geom_vline(aes(xintercept=mean(volatile.acidity)),
                  color="blue", linetype="twodash", size=0.25)

#Barplot of correlation between every feature and the wine quality
#We can observe that the variables with highest correlation with quality in absolute value are alcohol, density and chlorides
data.cor <- as.matrix(cor(data))
data.cor
Wine_Feature<-c(colnames(data))
Wine_Feature<-Wine_Feature[-12]
Correlation_with_WineQuality<-c(data.cor[12,])
Correlation_with_WineQuality<-Correlation_with_WineQuality[-12]
df.corr<-data.frame(Wine_Feature,Correlation_with_WineQuality)
library(data.table)
df.corr<-setDT(df.corr)[order(-abs(Correlation_with_WineQuality)), .SD, by = Wine_Feature]
df.corr
df.corr$Wine_Feature <- factor(df.corr$Wine_Feature, levels = df.corr$Wine_Feature)
ggplot(df.corr,aes(x=Wine_Feature,y=Correlation_with_WineQuality))+geom_bar(stat='identity',fill='lightblue', color="darkblue")

#scale the dataset
data %<>% scale()

#Meaningful variables--------------------------------
#Try to fit a simple linear model to see at first sight which predictors may be significant
linear_model <- lm(quality~., data = data2)
confint(linear_model, level = 0.95)
summary(linear_model)
summary(linear_model)$r.squared
summary(linear_model)$adj.r.squared
#from the very beginning we may observe that these predictors are not significant ant that
#total sulfur dioxide,chlorides ,citric acid, this has low significance :fixed acidity
#we can see that these predictors instead have very low p-values and so high significance
#`volatile acidity`,`residual sugar`,density,alcohol
#we can conclude with 95% confidence that there is no evidence of a relationship between citric acid or total.sulfur.dioxide and the wine quality because 0 is included in their confint.

#consequently we try to fit some models only with the expected significant predictors
#Models--------
#Multiple linear regression
poly <- lm(quality~alcohol + volatile.acidity, data = data2) 
confint(poly, level = 0.95)
summary(poly)
#The model is: E[quality] = beta0 + beta1alcohol + beta2volatile.acidity= 
 # 2,64 + alcohol * 0,34 – volatile.acidity* 1,57 in this case both predictors are significant
#We observe that if the alcohol increase of 1 unit the expected quality to increases by around 0,34 , but an increase in volatile.acidity will decrease the expected quality by 1,57 We can be 95% confident that the true value of alcohol is between 0,32 and 0,36 while for volatile.acidity it is between -1,85 and -1,29

#Adding an interaction term
inter <- lm(quality~ alcohol+ volatile.acidity + volatile.acidity*alcohol, data=data2) #alternative and more compact way
confint(inter, level = 0.95)
summary(inter)

#The model is: E[quality] = beta0 + beta1*alcohol + beta2*volatile.acidity + beta3*alcoholvolatile.acidity = 
#5,22 + 0.1*alcohol -10.31*volatile.acidity +0.82*alcohol*volatile.acidity
#Notice that the term B2 is estimated to be negative, so, for example:
#  An increase of alcohol increases the response of 0.1 + 0.82*volatile.acidity, but when volatile.acidity increases of one unit the response decreases by 10.31 but increases by 0.82* alcohol

#using gam to individuate the best most meaningful variables
library(gam)
ooGam <- gam::gam(quality~., data = data2, control = gam.control(maxit=100))
summary(ooGam)

#SPLITTING---------------------------------
set.seed(123)
idx <- sample(nrow(data), 0.75*nrow(data))
d_train <- data[idx, ]
d_train
d_test <- data[-idx,]
d_test
d_ft <-data.frame(d_train)
d_ftest <-data.frame(d_test)
d_ftest
test_quality <- d_ftest$quality
summary(d_ftest)
d_ftest1 <- d_ftest
d_ftest = d_ftest %>% dplyr::select(-quality)


#Metric:BIC, SUBSET SELECTION-------------------------
library (leaps)
regfit.full <- regsubsets(quality~., d_ft, nvmax= 11)
summary(regfit.full)
#best 2 variable model contains only volatile.acidity and alcohol
reg.summary <- summary(regfit.full)
reg.summary$bic
#bic decreases as the number of variables inside the model increase until more than 9 variables are inserted
par(mfrow = c(2, 2))
plot(reg.summary$bic , xlab = "Number of Variables",
     ylab = " BIC ", type = "l")
which.min(reg.summary$bic)
#the model with lowest bic is with 9 variables
points(9, reg.summary$bic[9], col = " red ", cex = 2,pch = 20)
coef(regfit.full , 9)#coefficient for the model with lowest bic
#fitting the model with the 9 best predictors resulting from the bic
bic_best <- lm(quality~fixed.acidity+volatile.acidity+residual.sugar+chlorides+free.sulfur.dioxide+density+pH+sulphates+sulphates, data = d_ft)
#perform the predictions
predbic= predict(bic_best, d_ftest)
#Calculate the MSE
msebic = mean((predbic - test_quality)^2)
msebic

#STEPWISE SELECTION
#AIC
lin = lm(quality~.,data = d_ft)
summary(lin)
AIC_both = step(lin,direction = "both", k=2)
#for AIC metric total.sulfur.dioxide is the only meaningful predictor defintely in contrast with the previous affirmations
linaic = lm(quality~total.sulfur.dioxide,data = d_ft)
pred_aic= predict(linaic, d_ftest)
mse_aic = mean((pred_aic - test_quality)^2)
mse_aic
#as expected mse is very high
#BIC 
rows = nrow(d_ft)
BIC_both = step(lin,direction = "both", k = log(rows))
linbic = lm(quality~chlorides+citric.acid+total.sulfur.dioxide,data = d_ft)
pred_bic= predict(linbic, d_ftest)
mse_bic = mean((pred_bic - test_quality)^2)
mse_bic
 
#AIC and BIC (fitted with forward and backward selection) suggest to use just the total.sulfur.dioxide to to implement the model, BIC uses also citric.acid and chlorides 
#we perform best subset selection on the full data set, and select
#the best variable model. It is important that we make use of the
#full data set in order to obtain more accurate coefficient estimates

#CROSS VALIDATION
#use k fold cross validation to choose among all dimension models
k <- 10
n <- nrow(data2)
set.seed (1)
folds <- sample( rep (1:k, length = n))
cv.errors <- matrix (NA, k, 11, dimnames = list (NULL , paste (1:11)))
#there is no predict method for the library so we implemented one
predict.regsubsets = function(object, newdata, id, ...) {
  form = as.formula(object$call[[2]])
  mat = model.matrix(form, newdata)
  coefi = coef(object, id = id)
  mat[, names(coefi)] %*% coefi
}
#test= j #train=i
for (j in 1:k) {
  best.fit <- regsubsets(quality~.,data = data2[folds != j, ], nvmax = 11)
  for (i in 1:11) {
    pred <- predict(best.fit , data2[folds == j, ], id = i)
    cv.errors[j, i] <-mean((data2$quality[folds == j] - pred)^2)
  }
}

#find the MSE
mses <- apply(cv.errors , 2, mean)
mses

#plot
par(mfrow = c(1, 1))
plot(mses , type = "b")
min <-which.min(mses)
min #least is the one with 10 variables
#The best subset selection based on the MSE is a 10-variable model
#the only excluded is total.sulfur.dioxide

cross_mse <- mses[min]
cross_mse

#RIDGE AND LASSO--------
dat = as.data.frame(data) #%>%dplyr::select(-quality)
X <- model.matrix(quality~.-1, data = dat)
Y <- dat$quality
Xtr <- model.matrix(quality~.-1, data = d_ft)
Ytr <- d_ft$quality
Xte <- model.matrix(quality~.-1, data =d_ftest1 )
Yte <- test_quality

#Lasso-----------
#we fit the model
lasso.fit <- glmnet(Xtr, Ytr, alpha=1)
#the set of coefficients estimates βˆ for the sequence of lambda provided by glmnet
lasso.fit$beta
lasso.fit$lambda
#We now plot the ridge regression coefficients as a function of log(lambda) and of the L1 norm
plot(lasso.fit, label=T)
plot(lasso.fit, label=T, xvar = "lambda")
#We can see from these plots that depending on the value of the tuning parameter lambda, some of the coefficients will be =0
#We now want to pick the best lambda, we're going to do it using k-fold using k=5
Lasso.cv <- cv.glmnet(Xtr, Ytr, lambda=seq(0.001, 2, length.out = 100), alpha=1, nfolds=5,
                      family="gaussian")
plot(Lasso.cv) 
bestlam <- Lasso.cv$lambda.min
#Prediction on the test set and MSE
Lasso.pred <- predict(lasso.fit, s=bestlam, newx=Xte)
mse_Lasso<-mean((Lasso.pred-Yte)^2)
mse_Lasso
#And now we show the coefficients for the chosen lambda 
out <- glmnet(X,Y, alpha=1)
lasso.coef <- predict(out, type="coefficients", s= bestlam)[1:12,]
round(lasso.coef,2)
lasso.coef <-lasso.coef[lasso.coef!=0]

#Ridge-------------
#to perform the ridge the procedure is the same but we need to set alpha to 0
ridge.fit <- glmnet(Xtr, Ytr, alpha=0)
ridge.fit$beta
ridge.fit$lambda
#We now plot the ridge regression coefficients as a function of the L2 norm
l2Betas <- apply(ridge.fit$beta, 2, function(x) sqrt(sum(x^2)))
matplot(l2Betas, t(ridge.fit$beta), type="l")
#and of log(lambda)
plot(ridge.fit, label=T, xvar = "lambda")
log(ridge.fit$lambda)
#we perform the k-fold validation to find the best lambda
Ridge.cv <- cv.glmnet(Xtr, Ytr, lambda=seq(0.001, 2, length.out = 100), alpha=0, nfolds=5,
                      family="gaussian")
plot(Ridge.cv) 
bestlam <- Ridge.cv$Ridge.min
#Prediction on the test set and MSE
Ridge.pred <- predict(ridge.fit, s=bestlam, newx=Xte)
mse_Ridge<-mean((Ridge.pred-Yte)^2)
mse_Ridge
#We can conclude that the shrinkage models that yield the lowest MSE is the Lasso

#Splines-------------
nSpars <- 100
spars <- seq(0.1, 0.99, length.out=nSpars)
#approximation of cross validation scores
gcvScores <- matrix(NA, nrow=2, ncol=length(spars))
#rownames(gcvScores) <- c("SS", "LOESS")
#always linear model cause beta*X
#deg_free <- matrix(NA, nrow=2, ncol=length(spars))
#rownames(deg_free) <- c("SS", "LOESS")


#We now use manual cross-validation for choosing the degrees of freedom 
#Use 3 degrees
deg_free <- 3

# Boundary knots
bKnots <- range(data2$alcohol)

# Folds
nfolds <- 10
n <- nrow(data2)
foldid <- sample(1:nfolds, n, replace = T)


# Looping
cvScores <- matrix(NA, nrow=3, ncol=nfolds)
rownames(cvScores) <- c("Polynomial", "Natural Splines", "B-Spline")

for (i in 1:nfolds)
{
  datIn <- data2 %>% filter(foldid!=i)
  datOut <- data2 %>% filter(foldid==i)
  
  oo1 <- lm(quality~poly(alcohol, degree = deg_free), data=datIn)
  pred1 <- predict(oo1, datOut)
  cvScores[1, i] <- mean((pred1-datOut$quality)^2)
  oo2 <- lm(quality~ns(x=alcohol, df = deg_free, Boundary.knots = bKnots), data=datIn)
  pred2 <- predict(oo2, datOut)
  cvScores[2, i] <- mean((pred2-datOut$quality)^2)
  oo3 <- lm(quality~bs(x=alcohol, df = deg_free, Boundary.knots = bKnots), data=datIn)
  pred3 <- predict(oo3, datOut)
  cvScores[3, i] <- mean((pred3-datOut$quality)^2)
}

#Errors on each fold for every model
t(cvScores) %>% as_tibble() %>% mutate(id=1:nrow(.)) %>% gather(Model, MSE, -id) %>%  
  ggplot() + geom_point(aes(x=id, y=MSE, col=Model, shape=Model), size=2, alpha=0.7) + theme_bw()
# Average error for every method used, we see that Natural Splines have least error 
rowMeans(cvScores)

#Now we valuate the average error of each model for different degrees of freedom

# Double looping
# dfs
dfree <- 3:12

# Double looping
cvScores1 <- matrix(NA, nrow=3, ncol=length(dfree))
rownames(cvScores1) <- c("Polynomial", "Natural Splines", "B-Spline")
colnames(cvScores1) <- dfree

for (j in 1:length(dfree))
{
  # Looping
  cvScores2 <- matrix(NA, nrow=3, ncol=nfolds)
  for (i in 1:nfolds)
  {
    datIn <- data2 %>% filter(foldid!=i)
    datOut <- data2 %>% filter(foldid==i)
    
    oo1 <- lm(quality~poly(alcohol, degree = dfree[j]), data=datIn)
    pred1 <- predict(oo1, datOut)
    cvScores2[1, i] <- mean((pred1-datOut$quality)^2)
    oo2 <- lm(quality~ns(x=alcohol, df = dfree[j], Boundary.knots = bKnots), data=datIn)
    pred2 <- predict(oo2, datOut)
    cvScores2[2, i] <- mean((pred2-datOut$quality)^2)
    oo3 <- lm(quality~bs(x=alcohol, df = dfree[j], Boundary.knots = bKnots), data=datIn)
    pred3 <- predict(oo3, datOut)
    cvScores2[3, i] <- mean((pred3-datOut$quality)^2)
  }
  
  # Saving for current df
  cvScores1[, j] <- rowMeans(cvScores2)
}

t(cvScores1) %>% as_tibble() %>% mutate(df=dfree) %>% gather(key, MSE, -df) %>%  
  ggplot() + geom_line(aes(x=df, y=MSE, col=key)) + theme_bw()
# The best choice of degrees of freedom seems to be somewhere between 5 and 8
#we can go a bit further with degree of freedom for natural splines
#with too much complexity polynomial is the one performing worse cause it has non additional constraints
#as soon dfs increase we go down and then increase again
#we would pick the minimus for natural is at 8 and for b-splines is 10
# Fit the models-------------------------
#since the least MSE for B-splines is achieved through 10 df we fit a model with this parameter
b_splines <- lm(quality~bs(alcohol, df = 10), data = d_ft)
summary(b_splines)
predbsplines= predict(b_splines, d_ftest)
#Calculate the MSE
msebsplines = mean((predbsplines- test_quality)^2)

#We then fit natural splines
n_splines <-lm(quality~ns(alcohol, df = 8), data = d_ft)
summary(n_splines)
prednsplines= predict(n_splines, d_ftest)
#Calculate the MSE
msensplines = mean((prednsplines- test_quality)^2)

#lastly the polynomial
polynomial <- lm(quality~poly(alcohol, df = 3), data = d_ft)
summary(polynomial)
polynomial= predict(polynomial, d_ftest)
#Calculate the MSE
msepolynomials = mean((polynomial- test_quality)^2)
data2<-data.frame(data)
#REGRESSION TREES -------------------------------------------------------------
library(tree)
require(tree)
#Regression tree fit
fit_tr = tree(quality~., data=d_ft)
summary(fit_tr)
plot(fit_tr, col="grey")
text(fit_tr, pretty=0, cex = 0.7)
#make the predictions
pred_test = predict(fit_tr, d_ftest)
#Calculate the MSE
msedecisiontree<-mean((pred_test - test_quality)^2)
msedecisiontree
var(test_quality)
#We want to see if tree pruning improves the performance of the tree: to do so we run a K-fold cross-validation
#and we evaluate the mean squared prediction error on the data in the left-out kth fold, as a function of k.
fit_cvtr = cv.tree(fit_tr)
fit_cvtr
par(mfrow = c(1,2))
#We now plot the error against the cost-complexity parameter k and the size of the tree
plot(fit_cvtr$size, fit_cvtr$dev/nrow(d_ftest), type = "b",col="blue", xlab="Size", ylab="Err")
plot(fit_cvtr$k, fit_cvtr$dev/nrow(d_ftest), type="b", col=3, xlab="k", ylab="Err")
#From the plot we can see that the pruning would not benefit to the performance of the model
#We perform the tree pruning anyways (to confirm our assumption) with tree size=5 and pruning parameter=50
fit_pr = prune.tree(fit_tr, best = 5, k=50)
par(mfrow=c(1,1))
plot(fit_pr, col="grey")
text(fit_pr, pretty=0, cex = 0.7)
#We use our pruned tree to make predictions on the test set and compute the MSE
par(mfrow=c(1,1))
pred_pr = predict(fit_pr, d_ftest)
msepruning<-mean((pred_pr - test_quality)^2)
msepruning
plot(pred_pr, test_quality, col="darkblue", xlab="predicted", ylab="test")
abline(0,1, col=2)

library(randomForest)
#firstly we perform a bagging 
#We perform bagging by exploiting the randomForest function and considering all of our predictors for each split of the tree
fit_bag = randomForest(quality~., data = d_ft, mtry = ncol(d_ft)-1, importance = T)
#make the predictions
pred_bag = predict(fit_bag, d_ftest)
msebagging<-mean((pred_bag - test_quality)^2)
msebagging
plot(pred_bag, test_quality, col="darkblue", xlab="predicted", ylab="test")
abline(0,1, col=2)
#The test set MSE associated with the bagged regression tree is 0.4159197. Lower than the one obtained with the regression tree.

#Performing random forest with just 2 predictors
fit_rf = randomForest(quality~., data = d_ft, mtry = 2, importance = T, ntree=1e3 )
pred_rf = predict(fit_rf, d_ftest)
mse_randomf<-mean((pred_rf - test_quality)^2)
mse_randomf
plot(pred_rf, test_quality, col="darkblue", xlab="predicted", ylab="test")
abline(0,1, col=2)
#the MSE is 0.4107522 so the random forest yields an improvement over the bagging 
#Plot the importance of each variable
importance(fit_rf)
varImpPlot(fit_rf)
#The alcohol is the most important variables followed by the free.sulfur.dioxide and volatile acidity

#COMPARE THE RESULTS-------------------------------
mse_vector<-c(msebic,mse_aic,mse_bic,cross_mse,mse_Ridge,mse_Lasso,msebsplines,msensplines,msepolynomials,msedecisiontree,msepruning, msebagging, mse_randomf)
mse_vector
min(mse_vector)

#the model with the least MSE is the model fitted with the cross validation selection knit

#CLUSTERING-----------------
data <- read_delim("WineQuality.csv", delim=",")
#omitting the NAs
data <- na.omit(data)
#deleting the duplicates
any(duplicated(data)) #we see that there are some duplicates
data <- distinct(data)  #so we get rid of it
data$quality = as.factor(ifelse(data$quality<6, "bad wine", "good wine"))
qual <- data$quality
data_noqual = data %>% dplyr::select(-quality)

#Then we perform PCA on the clean dataset (without the response) in order to shape the best parameters to perform the clustering.
#PCA-----------------

#scale the variables
apply(data_noqual, 2, mean)
apply(data_noqual, 2, var)
#There is no need to scale the data since we put "cor=T"
pca = princomp(data_noqual, cor=T) #Apply the principal components analysis using correlation matrix
summary(pca)
fviz_eig(pca)
pc.comp <- pca$scores
pc.comp
pc.comp1 <- -1*pc.comp[,1] #We extract principal component 1 scores 
pc.comp2 <- -1*pc.comp[,2]
pc.comp3 <- -1*pc.comp[,3]
pc.comp4 <- -1*pc.comp[,4]
pc.comp5 <- -1*pc.comp[,5]
data_pca <- data_noqual
data_pca$pc.comp1 <- pc.comp1
data_pca$pc.comp2 <- pc.comp2
data_pca$pc.comp3 <- pc.comp3
data_pca$pc.comp4 <- pc.comp4
data_pca$pc.comp5 <- pc.comp5
data_pca <- data_pca %>% dplyr::select(pc.comp1, pc.comp2,pc.comp3,pc.comp4,pc.comp5) 
data_pca
#With this plot we see which variables contribute more in the components
fviz_pca_var(pca,
             col.var = "contrib",
             gradient.cols = c("#00AFBB", "#E7B800", "#FC4E07"),
)

# Eigenvalues
eig.val <- get_eigenvalue(pca)
eig.val
# Results for Variables
res.var <- get_pca_var(pca)
res.var$coord          # Coordinates
res.var$contrib        # Contributions to the PCs
res.var$cos2           # Quality of representation 
# Results for individuals
res.ind <- get_pca_ind(pca)
res.ind$coord          # Coordinates
res.ind$contrib        # Contributions to the PCs
res.ind$cos2           # Quality of representation

# K-Means -----------------------------------------------------------------
#after many trials we found that the best number of cluster is 2 
data_pca <- data.frame(data_pca)
fviz_nbclust(data_pca, FUNcluster = kmeans, method = "wss")
fviz_nbclust(data_pca, FUNcluster = kmeans, method = "silhouette")
# Silhouette on KMEANS finds 2 clusters
km2 <- kmeans(data_pca, centers = 2)
km2
#The main difference between the two clusters is that in cluster 1 (bad wine) the influence of the first component is negative while in cluster 2 (good wine) the influence of the first component is the only one that is positive.

# Clusters plot
fviz_cluster(object=km2,data_pca) + theme_bw()
#Now we compare if the clustering on the considered numerical variables result of the pca agrees
#with one of the original categorical variable: Quality ( good wine or bad wine)
datWC <- data_pca %>% mutate(clust=km2$cluster)
# We can show a contingency table
datWC$quality <-  qual
(contTable <- datWC %>% dplyr::select(quality, clust) %>% table())
chisq.test(contTable) #p-value is low
prop.table(contTable, margin=1) 
#"good wine" and "bad wine" have not so different distribution across the first clusters,
#while in the second cluster around 3/4 of data points have good wine prediction
mclust::adjustedRandIndex(datWC$quality, datWC$clust)

#Since ARI is low (0.085) in the cluster labels the wines tend to belong to the same cluster 
#even if they have not similar characteristics

#Conclusion:
#Unfortunately the result of the ARI index shows that the 2 clusters don't tend to show evident propensity for having good quality or bad quality in wines.
#But analizing the pca components and the variables from which they are composed of, we can state that the first component is the one with more weight.This component is for the most influenced by residual.sugar, density, total.sulfur.dioxide and alcohol.
#So we can deduce that negative values for the first component tend to worsen the quality of the wine, conversely positive values lead to good wines.

