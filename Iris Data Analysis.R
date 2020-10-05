---
title: "Iris Data Analysis"
output: html_document
editor_options: 
  chunk_output_type: console
---

```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = TRUE)
```

## R Markdown

This is an R Markdown document. Markdown is a simple formatting syntax for authoring HTML, PDF, and MS Word documents. For more details on using R Markdown see <http://rmarkdown.rstudio.com>.

When you click the **Knit** button a document will be generated that includes both content as well as the output of any embedded R code chunks within the document. You can embed an R code chunk like this:

```{r cars}
summary(cars)
```

## Including Plots

You can also embed plots, for example:

```{r pressure, echo=FALSE}
plot(pressure)
```

Note that the `echo = FALSE` parameter was added to the code chunk to prevent printing of the R code that generated the plot.

```{r}
#Load Libraries

library(dplyr)

library(ggplot2)

library(gridExtra)

library(cluster) 

library(fpc)

library(factoextra)

library(knitr)
```
The Iris flower data set or Fisher's Iris data set is a multivariate data set introduced by the British statistician, eugenicist, and biologist Ronald Fisher in his 1936 paper The use of multiple measurements in taxonomic problems as an example of linear discriminant analysis.

```{r}
#Load Dataset Iris

dim(iris)

#Examine dataset information

head(iris, 4)

tail(iris, 2)

summary(iris)

names(iris)
```

```{r}
#Examine Iris data information

#Chart matrix
pairs(iris[,1:4], col=iris$Species)



```
Initial Results from the chart matrix shows there there appears to be some clustering in the data based on length and width of the sepals and petals of the iris flowers that were measured for the data set.
```{r}
#Grid analysis of histograms of the Sepal Lengt and Width and the Petal Length and Width.

p1 <- ggplot(aes(x = Sepal.Length, fill = Species), data = iris) +
  facet_wrap(~Species) + geom_histogram()

p2 <- ggplot(aes(x = Sepal.Width, fill = Species), data = iris) +
  facet_wrap(~Species) + geom_histogram()

p3 <- ggplot(aes(x = Petal.Length, fill = Species), data = iris) +
  facet_wrap(~Species) + geom_histogram()

p4 <- ggplot(aes(x = Petal.Width, fill = Species), data = iris) +
  facet_wrap(~Species) + geom_histogram()


grid.arrange(p1, p2, p3, p4, ncol = 2)
```
Histograms show some patterns that show some relationship between the widths and lengths of the sepals and petals of the flowers.

```{r}

#Relook at the relationship between width and length with scatterplot
sp1 <- ggplot(aes(x = Sepal.Length, y = Sepal.Width, color = Species), data = iris) +
  facet_wrap(~Species) + geom_point()

sp2 <- ggplot(aes(x = Petal.Length, y = Petal.Width, color = Species), data = iris) +
  facet_wrap(~Species) + geom_point()



grid.arrange(sp1, sp2, ncol = 1)

```
Again, at first blush, there appears to be a relationship between length and width of sepals and petals.

```{r}
#Relook of the Iris data using boxplots
bp1 <- ggplot(aes(x = Petal.Width, y = Petal.Length, color = Species), data = iris) +
  geom_boxplot()

bp2 <- ggplot(aes(x = Sepal.Width, y = Sepal.Length, color = Species), data = iris) +
  geom_boxplot()

grid.arrange(bp1, bp2, ncol = 1)

```
Cluster analysis of the Iris data. 

```{r}
#Cluster analysis, droping species colum to clean dataset.

data_for_clustering <- iris[,-5] 

#kmeans data clustering partitioning (assuming 3 centers or clusters).

clusters_iris <- kmeans(data_for_clustering, centers = 3) 

#ploting of the final dataset

plotcluster(data_for_clustering,clusters_iris$cluster) 




```
Another look at clustering of the Iris data.
```{r}
clusplot(data_for_clustering, clusters_iris$cluster, color = TRUE, shade = TRUE)
```
Based on the last plot, it appears that there are two cluster groups, Iris setosa, while the other cluster contains both Iris virginica and Iris versicolor. The data provided in the Iris set doesn't provide enough separation between virginica and versicolor.