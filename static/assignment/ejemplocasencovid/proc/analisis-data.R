# Codigo de Analisis

# 1. Cargar librerías -----
pacman::p_load(dplyr, #Manipulacion de datos
               sjmisc, # Tablas
               summarytools, #Tablas
               sjPlot,  # Correlaciones
               ggplot2, # Graficos
               webshot) # Para guardar tablas

webshot::install_phantomjs( force = T)

# 2. Cargar base de datos
setwd("C:/Users/Valentina Andrade/Dropbox/3. Docencia/Estadistica Multivariada/05-code")
load(file = "CASEN-COVID19.RData")

# 3. Descriptivos de variables -----
# 3.1 Tabla de variables
view(dfSummary(casen_covid19, headings=FALSE), file = "tabla1.html")
# Guardar
webshot("tabla1.html","tabla1.png")

# 3.2 Graficar asociacion entre hacinamiento y contagio

# 1. Se crea un gráfico scatterplot "g" con la librería ggplot
# Y es nuestra variable dependiente
# X = es nuestra variable independiente
g=ggplot(casen_covid19, aes(x=hacinamiento, y=t_contagio)) +
  geom_point()
g
# Guardar
# Deben indicar el nombre primero, y luego como lo van a guardar
ggsave("grafico1.png",
       g)

# 3.3 Correlacion

# Excluimos comuna pues las correlaciones son entre variables numéricas y comuna es un carácter
casen_covid19 <-
  casen_covid19 %>% select(-nombre_comuna, -nombre_region) 

# Hacer tabla con correlaciones
sjPlot::sjt.corr(casen_covid19,
                 triangle = "lower", file = "tabla2.html")

# Guardar matriz de correlaciones
webshot("tabla2.html","tabla2.png")

# 4. Modelo de regresion ----

# 4.1 Estimar modelo de regresion
reg1 <-lm(t_contagio ~ hacinamiento, data = casen_covid19)

# 4.2 Resumen del modelo de regresion
sjPlot::tab_model(reg1, show.ci=FALSE, file = "reg1_tab.html")

# 4.3 Guardar modelo de regresion
webshot("reg1_tab.html","reg1_tab.png")

# 5. Bondad de ajuste

# 5.1 Variable de valores predichos
casen_covid19$estimado<- (6.441 + casen_covid19$hacinamiento*2158.467)

# 5.2 Estimamos el residuo
casen_covid19$residuo <- casen_covid19$t_contagio - casen_covid19$estimado

#  5.3 Graficar residuos
g2 <- ggplot(casen_covid19, aes(x=hacinamiento, y=t_contagio))+
  geom_smooth(method="lm", se=FALSE, color="lightgrey") +#Pendiente de regresion
  geom_segment(aes(xend=hacinamiento, yend=estimado), alpha = .2) + #Distancia entre estimados y datos en lineas
  geom_point(aes(color = abs(residuo), size = abs(residuo))) +
  scale_color_continuous(low = "black", high = "red") +
  guides(color = FALSE, size = FALSE) +
  geom_point(aes(y=estimado), shape =1) + labs(title = "Gráfico 2. Residuos modelo de regresión", caption = "Fuente: Elaboración propia en base a CASEN-COVID19 (2020)", y = "tasa de contagio", x = "hacinamiento del hogar (media)")
theme_bw()
g2

# Guardar
ggsave("grafico2.png",
       g2)