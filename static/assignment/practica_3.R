# Código Práctica 3: Regresión Simple 1.

# 1. Cargar librerías

pacman::p_load(stargazer, ggplot2, dplyr)

# 2. Cargar datos

## Desde internet 
datos <- read.csv("https://multivariada.netlify.app/slides/03-regsimple1/tacataca.txt", sep="")

## Desde el computador
datos <- read.csv("C:/users/catalina/desktop/estadistica/tacataca.txt", sep="") # (esta es la ruta local)

## 3. Descripción de variables 
View(datos)

## Tabla descriptiva
stargazer(datos, type = "text")
stargazer(datos %>% select(juegos_x,puntos_y) , type = "text")

## Gráficos
g=ggplot(datos, aes(x=juegos_x, y=puntos_y)) +
  geom_point()
g

## Correlación
cor(datos$juegos_x,datos$puntos_y)

## Gráfico de medias condicionales del ejemplo
g2=ggplot(datos, aes(x=juegos_x, y=puntos_y)) +
  geom_point() +
  geom_smooth(method=lm, se=FALSE)
g2

# 4. Modelo e hipótesis

## Cálculo paso a paso de parámetros del ejemplo

datos$difx=datos$juegos_x-mean(datos$juegos_x)
datos$dify=datos$puntos_y-mean(datos$puntos_y)
#Creamos un vector para Juegos_x y para Puntos_y en funci?n de sus medias.

datos$difcru=datos$difx*datos$dify
datos$difx2=datos$difx^2
datos
sum(datos$difcru) #Suma de los productos o diferencia cruzada
sum(datos$difx2) #Suma de la diferencia del promedio de X al cuadrado

## Estimación modelo de regresión simple
reg1 <-lm(puntos_y ~ juegos_x, data = datos)
reg1

stargazer(reg1, type = "text") # Tabla
