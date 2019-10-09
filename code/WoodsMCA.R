setwd("C:/dev/code/Woods2019/code")
library(cluster) #for gower distance
library(dplyr)
library(Rtsne)
library(ggplot2)
library(factoextra)
library(Gifi)
library(ggfortify)
library(FactoMineR)

#using factomineR for multiple correspondence analysis


woods = read.csv("../data/woodprops.csv", stringsAsFactors = TRUE, header = TRUE)
woods.qual = woods[,c(2,3,4,5)]
woods.qualMCA = MCA(woods,
                    ind.sup = c(2:9),
                    quanti.sup = c(6,7,8,9), 
                    quali.sup = c(2,3,4,5),
                    ncp = 2,
                    graph = TRUE)

fviz_mca_biplot(woods.qualMCA, 
                repel = TRUE, 
                ggtheme = theme_minimal())
