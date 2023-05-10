# install.packages("remotes") si necessaire
remotes::install_github("InseeFrLab/doremifasol", build_vignettes = TRUE)
install.packages("labelled")
install.packages("rmarkdown")
install.packages("tinytex")
tinytex::install_tinytex() 



library(tidyverse)
library(dplyr)
library(labelled)
library(foreign)
library(rmarkdown)
library(ggplot2)



library(utilrp)
