library(tidyverse)
library(dplyr)
library(ggplot2)
library(GGally)
library(gridExtra)

data.unprepared <- read.csv("HiddenFraudulentURLs.csv", sep = ";")

summary(data.unprepared)
glimpse(data.unprepared)

table(data.unprepared$compromissionType)
table(data.unprepared$isHiddenFraudulent)
table(data.unprepared$contentLength)
table(data.unprepared$serverType)
table(data.unprepared$poweredBy)
table(data.unprepared$contentType)
table(data.unprepared$lastModified)

plot1 <- ggplot(data.unprepared, aes(x=reorder(compromissionType, compromissionType, function(x)-length(x)))) +
  geom_bar(fill='Yellow') +  labs(x='CompromissionType')

plot2 <- ggplot(data.unprepared, aes(x=reorder(isHiddenFraudulent, isHiddenFraudulent, function(x)-length(x)))) +
  geom_bar(fill='Yellow') +  labs(x='isHiddenFraudulent')

plot3 <- ggplot(data.unprepared, aes(x=reorder(poweredBy, poweredBy, function(x)-length(x)))) +
  geom_bar(fill='Yellow') +  labs(x='PoweredBy')

plot4 <- ggplot(data.unprepared, aes(x=reorder(serverType, serverType, function(x)-length(x)))) +
  geom_bar(fill='Yellow') +  labs(x='serverType')

plot5 <- ggplot(data.unprepared, aes(x=reorder(contentType, contentType, function(x)-length(x)))) +
  geom_bar(fill='Yellow')+ labs(x="contentType")

grid.arrange(plot1, plot2,plot3, plot4,plot5,
             layout_matrix = rbind(c(1,2),
                                   c(5,4),
                                   c(3)))


ggplot(data.unprepared, aes(contentLength)) +
  geom_histogram(fill ='Yellow') + labs(x ='contentLength')


sum(is.na(data.unprepared))


data.unprepared[data.unprepared == ""] <- NA

sum(is.na(data.unprepared))

data.na <- colSums(is.na(data.unprepared))
data.na <- data.frame(t(data.na))

sum(duplicated(data.unprepared))
data.duplicated <- data.unprepared %>% 
  filter(duplicated(.))


data.fraudulent <- read.csv("dataset.csv", sep = ";")

plot1 <- ggplot(data.fraudulent, aes(x=reorder(compromissionType, compromissionType, function(x)-length(x)))) +
  geom_bar(fill='BLUE') +  labs(x='CompromissionType')

plot2 <- ggplot(data.fraudulent, aes(x=reorder(isHiddenFraudulent, isHiddenFraudulent, function(x)-length(x)))) +
  geom_bar(fill='BLUE') +  labs(x='isHiddenFraudulent')

plot3 <- ggplot(data.fraudulent, aes(x=reorder(poweredBy, poweredBy, function(x)-length(x)))) +
  geom_bar(fill='BLUE') +  labs(x='PoweredBy')

plot4 <- ggplot(data.fraudulent, aes(x=reorder(serverType, serverType, function(x)-length(x)))) +
  geom_bar(fill='BLUE') +  labs(x='serverType')

plot5 <- ggplot(data.fraudulent, aes(x=reorder(contentType, contentType, function(x)-length(x)))) +
  geom_bar(fill='BLUE') +  labs(x='contentType')

plot6 <- ggplot(data.fraudulent, aes(ulrLenght)) +
  geom_histogram(fill='BLUE') +  labs(x='urlLength')

grid.arrange(plot1,plot2,plot3,plot4,plot5,plot6, 
             layout_matrix = rbind(c(1,2),
                                   c(3,4),
                                   c(5,6)))


data.compType <- read.csv('datasetcomptype.csv', sep = ';')