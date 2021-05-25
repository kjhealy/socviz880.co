rm(list=ls())

# Código práctica 4: Regresión simple 2

# 1. Cargar librerías
pacman::p_load(stargazer, ggplot2, dplyr,webshot)

# 2. Cargar datos
datos <- read.csv("https://multivariada.netlify.app/slides/03-regsimple1/tacataca.txt", sep="")
datos

## Gráfico de distribución de los datos y recta de regresión
g2=ggplot(datos, aes(x=juegos_x, y=puntos_y)) +
  geom_point() +
  geom_smooth(method=lm, se=FALSE)
g2

# 3. Residuos
## La recta de regresión simplifica la variabilidad de los datos. Los residuos son
## la diferencia entre el valor predicho y el observado: la mejor recta es aquella
## que minimice al máximo los residuos. Para sumar los residuos estos se elevan
## al cuadrado (SSresidual), respecto de lo cual debemos buscar el menor
## valor posible. Este procedimiento se llama OLS o mínimos cuadrados ordinarios

# 4. Modelo y cálculo de parámetros
reg1 <-lm(puntos_y ~juegos_x, data = datos)
reg1

## Generar tabla
stargazer(reg1, type="text")
sjPlot::tab_model(reg1, show.ci=FALSE)

### Guardar tablas
stargazer(reg1, type="html",  out = "reg1.html")
webshot("reg1.html","reg1.png")

sjPlot::tab_model(reg1, show.ci=FALSE, file = "reg1_tab.html")
webshot("reg1_tab.html","reg1_tab.png")

# 5. Bondad de ajuste: Residuos y R2
## Siempre tendremos una impresición en nuestro modelo, representado por las 
## diferencias entre datos observados y datos predichos. La precisión se
## relaciona con el concepto Bondad de ajuste, y se evalúa a partir del 
## estadístico R2. 

#summary(lm(puntos_y~juegos_x, data=datos))
#beta=0.5 intercepto=2.5

#Variable de valores predichos
datos$estimado<- (2.5 + datos$juegos_x*0.5)

# Alternativa por comando
#datos$estimado <- predict(reg1)

#Estimamos el residuo
datos$residuo <- datos$puntos_y - datos$estimado

# Alternativa por comando
#datos$residuo <- residuals(reg1)

datos %>% select(id, estimado, residuo)

## Suma de cuadrados y R2
## Usando la media como modelo podemos calcular las diferencias entre valores 
## observados y valores predichos.Calculamos la suma total de cuadrados, es decir,
## la suma de las diferencias del promedio de Y al cuadrado (asociado a varY)

ss_tot<- sum((datos$puntos_y-mean(datos$puntos_y))^2); ss_tot

## Suma de cuadrados de la regresión: suma de diferencias al cuadrado entre el
## valor estimado y la media. Expresa cuánto de la varianza de Y predecimos con X

ss_reg<-sum((datos$estimado-mean(datos$puntos_y))^2) ; ss_reg

## Suma de reisudos al cuadrado: los residuos representan la parte de la
## varianza de Y que no alcanzamos a abarcar en nuestro modelo. Es decir,
## representan el error en la predicción

ss_err<- sum((datos$puntos_y - datos$estimado)^2);ss_err

## A partir de lo anterior, podemos calcular R2

### Opción 1
ss_reg/ss_tot

### Opción 2
1-ss_err/ss_tot

### por comando
summary(lm(puntos_y~juegos_x, data=datos))$r.squared

# 6. Visualización 
#Visualizacion
library(ggplot2)

ggplot(datos, aes(x=juegos_x, y=puntos_y))+
  geom_smooth(method="lm", se=FALSE, color="lightgrey") +#Pendiente de regresion
  geom_segment(aes(xend=juegos_x, yend=estimado), alpha = .2) + #Distancia entre estimados y datos en lineas
  geom_point() + #Capa 1
  geom_point(aes(y=estimado), shape =1) +
  theme_bw()

ggplot(datos, aes(x=juegos_x, y=puntos_y))+
  geom_smooth(method="lm", se=FALSE, color="lightgrey") +#Pendiente de regresion
  geom_segment(aes(xend=juegos_x, yend=estimado), alpha = .2) + #Distancia entre estimados y datos en lineas
  geom_point(aes(color = abs(residuo), size = abs(residuo))) + #tamaño de residuoes
  scale_color_continuous(low = "black", high = "red") + # color de los residuos
  guides(color = FALSE, size = FALSE) +
  geom_point(aes(y=estimado), shape =1) +
  theme_bw()

# 7. Coeficiente de regresión versus coeficiente de correlación
## Tanto la correlación entre xy y el beta de regresión son medidas
## de relación entre X e Y, que están formuladas: 
## B1= rxy(Sy/Sx)

beta<-cor(datos$juegos_x,datos$puntos_y)*(sd(datos$puntos_y)/sd(datos$juegos_x));beta
reg1$coefficients[2] #llamamos al coeficiente beta (en posición 2) en el objeto reg1

## Existe una reación entre rxy y R2
###Correlación (Pearson) entre juegos_x y puntos_y (r)
cor(datos$juegos_x,datos$puntos_y)

###Correlación entre juegos_x y puntos_y al cuadrado.
(cor(datos$juegos_x,datos$puntos_y))^2

##Mientras en la correlación no importa el orden, en la regresión si