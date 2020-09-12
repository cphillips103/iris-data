
library(dplyr)

library(ggplot2)

library(gridExtra)

library(cluster) 

library(fpc)

library(factoextra)

library(knitr)

data(USArrests)

head(USArrests)

data("iris")

dim(iris)

head(iris, 4)

tail(iris, 2)

summary(iris)

names(iris)

pairs(iris[,1:4], col=iris$Species)

table(iris$Species)

prop.table(table(iris$Species))

mean_virginic_sepal.length <- subset(iris, Species == 'virginica')

head(mean_virginic_sepal.length)

str(mean_virginic_sepal.length)

names(mean_virginic_sepal.length)

mean_virginic_sepal.length %>%
  summarise(mean = mean(Sepal.Length), n = n())

ggplot(aes(x = Sepal.Length), data = iris) + facet_wrap(~Species)  + geom_histogram(aes(color = Species))


ggplot(aes(x = Sepal.Length, y = Sepal.Width), data = iris) + geom_point(aes(color = Species)) +geom_smooth()


p1 <- ggplot(aes(x = Sepal.Length, fill = Species), data = iris) +
  facet_wrap(~Species) + geom_histogram()

p2 <- ggplot(aes(x = Sepal.Width, fill = Species), data = iris) +
  facet_wrap(~Species) + geom_histogram()

p3 <- ggplot(aes(x = Petal.Length, fill = Species), data = iris) +
  facet_wrap(~Species) + geom_histogram()

p4 <- ggplot(aes(x = Petal.Width, fill = Species), data = iris) +
  facet_wrap(~Species) + geom_histogram()


grid.arrange(p1, p2, p3, p4, ncol = 2)

sp1 <- ggplot(aes(x = Sepal.Length, y = Sepal.Width, color = Species), data = iris) +
  facet_wrap(~Species) + geom_point()

sp2 <- ggplot(aes(x = Petal.Length, y = Petal.Width, color = Species), data = iris) +
  facet_wrap(~Species) + geom_point()



grid.arrange(sp1, sp2, ncol = 1)


bp1 <- ggplot(aes(x = Petal.Width, y = Petal.Length, color = Species), data = iris) +
  geom_boxplot()

bp2 <- ggplot(aes(x = Sepal.Width, y = Sepal.Length, color = Species), data = iris) +
  geom_boxplot()

grid.arrange(bp1, bp2, ncol = 1)


data_for_clustering <- iris[,-5] 

clusters_iris <- kmeans(data_for_clustering, centers = 3) 

plotcluster(data_for_clustering,clusters_iris$cluster) 

clusplot(data_for_clustering, clusters_iris$cluster, color = TRUE, shade = TRUE)


sample_data <- 
  tibble(State = state.name,
         Region = state.region) %>%
  bind_cols(as_tibble(state.x77)) %>%
  bind_cols(USArrests)

kable(head(sample_data))

df <- USArrests

df <- na.omit(df)

names(df)

distance <- get_dist(df)
fviz_dist(distance, gradient = list(low = "#00AFBB", mid = "white", high = "#FC4E07"))

k2 <- kmeans(df, centers = 2, nstart = 25)
str(k2)

k2

fviz_cluster(k2, data = df)
    
    
df %>%
  as_tibble() %>%
  mutate(cluster = k2$cluster,
         state = row.names(USArrests)) %>%
  ggplot(aes(UrbanPop, Murder, color = factor(cluster), label = state)) +
  geom_text()   

k3 <- kmeans(df, centers = 3, nstart = 25)
k4 <- kmeans(df, centers = 4, nstart = 25)
k5 <- kmeans(df, centers = 5, nstart = 25)

# plots to compare
p1 <- fviz_cluster(k2, geom = "point", data = df) + ggtitle("k = 2")
p2 <- fviz_cluster(k3, geom = "point",  data = df) + ggtitle("k = 3")
p3 <- fviz_cluster(k4, geom = "point",  data = df) + ggtitle("k = 4")
p4 <- fviz_cluster(k5, geom = "point",  data = df) + ggtitle("k = 5")


grid.arrange(p1, p2, p3, p4, nrow = 2)

set.seed(123)

# function to compute total within-cluster sum of square 
wss <- function(k) {
  kmeans(df, k, nstart = 10 )$tot.withinss
}

# Compute and plot wss for k = 1 to k = 15
k.values <- 1:15

# extract wss for 2-15 clusters
wss_values <- map_dbl(k.values, wss)

plot(k.values, wss_values,
     type="b", pch = 19, frame = FALSE, 
     xlab="Number of clusters K",
     ylab="Total within-clusters sum of squares")
