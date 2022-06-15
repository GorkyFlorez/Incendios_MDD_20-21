##--------------------------  LIBRERIAS
library(sf)
library(mapedit)
library(raster)
library(ggplot2)
library(tmap)
library(rgee)
library(mapedit)
library(rgee)
library(googledrive)
library(rgee)
library(mapedit)
library(tibble)
library(sf)
library(cptcity)
library(tidyverse)
library(sp)
library(leaflet.extras2)
library(raster)
library(stars)
library(geojsonio)
library(ggmap)
library(leaflet.extras)
##--------------------------USUARIO
ee_Initialize("gflorezc", drive = T)
# Cargar el punto
Poligono <-ee$FeatureCollection("users/gflorezc/Depa_MDD")

box <- ee$Geometry$Rectangle(coords= c(-72.40404, -13.36179, -68.65311, -9.879849),
                             proj= "EPSG:4326", geodesic = F)

sentinel2 <- ee$ImageCollection("COPERNICUS/S2_SR")

Trueimage <-sentinel2$filterBounds(Poligono)$ 
  filterDate("2021-01-01", "2021-12-31")$ 
  sort("CLOUDY_PIXEL_PERCENTAGE", FALSE)$
  mosaic()$
  clip(Poligono)

True_2020 <-sentinel2$filterBounds(Poligono)$ 
  filterDate("2020-01-01", "2020-12-31")$ 
  sort("CLOUDY_PIXEL_PERCENTAGE", FALSE)$
  mosaic()$
  clip(Poligono)
# Análisis de severidad de incendios con índice NBR
NBRPostIncendio = Trueimage$normalizedDifference(c('B8','B12'))
NBRPostInce_2020 = True_2020$normalizedDifference(c('B8','B12'))
NDWIincendio <- c('#ffc8dd', '#9d0208', '#ffb703', '#55a630', '#006400', '#F6D53B')


# Visualizacion
Map$centerObject(Poligono)
Map$addLayer(eeObject =NBRPostInce_2020 , "Incendios 2020", visParams = list(                                   # LLamamos a NDWI y ponemos parametro de colores
  min=0,   max=1, palette= NDWIincendio)) |
  Map$addLayer(eeObject =NBRPostIncendio , "Incendios 2021", visParams = list(                                   # LLamamos a NDWI y ponemos parametro de colores
    min=0,   max=1, palette= NDWIincendio))
