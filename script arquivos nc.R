rm(list=ls())

library(raster)
library(ncdf4)

setwd("/Users/matheusribeiro/Dropbox/aaa_Matheus_Ribeiro-2014-11-06/Producao Cientifica/em andamento/ecoClimate_Chelsa/MIROC/LGM")
a <- stack("pr_day_MIROC-ESM_lgm_r1i1p1_46000101-46991231.nc") #acessa os todos os layers diarios durante 100 anos consecutivos. No nome do arquivo, veja que s simulacoes vao de 01/01/4600 a 31/12/4699.
b <- names(a) #o nome de cada layer indica a data (dia/mes/ano) da simulacao climatica

b[seq(1,36524, 365)] #esse AOGCM (MIROC) considera o ano com 365 dias, mas existem os anos bissextos com 366 dias (e.g. o ano 4604 e bissexto)
b[1461:1826] #veja os nomes dos layers do ano 4604, bissexto, com 29/02/4604 somando 366 dias. Existem outros anos bissextos!

coord <- xyFromCell(a, 1:ncell(a)) # a longitude varia de 0 a 360 (e não -180 a +180), com isso diferem dos shapes tradicionais (e.g. map(add=T) fica desconfigurado). Se quiser fazer algum mapa compativel com o map(), pode trasformar long de -180 a +180 (abaixo).
id <- which(coord[,"x"] > 180)
coord[id,"x"] <- coord[id,"x"] - 360
a1 <- rasterFromXYZ(cbind(coord, as.data.frame(a[[1]])))

#' PS1: a unidade de precipitacao eh mm/segundo. Para transformar em mm/dia, multilique pela qunantidade de segundos em um dia (24 horas * 60 min * 60 seg = 86400).
#'PS2: A unidade de temperatura eh Kelvin. Pra trasnformar em oC (graus Celsius), diminua por 273 (0K = -273 oC).



