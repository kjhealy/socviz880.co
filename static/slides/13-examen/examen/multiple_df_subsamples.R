# Exportar múltiples sub muestras de base de datos

# 1. Cargar librerias -----------------------------------------------------
pacman::p_load(haven, dplyr)
setwd("static/slides/13-examen/examen")

# 2. Datos ----------------------------------------------------------------
issp <- read_sav("datos/issp.sav")

issp <- issp[!is.na(issp$sindicatos),]

issp$sindicatos_dummy <- car::recode(issp$sindicatos, recodes =c("c(5,4,3)=1;c(1,2)=0"), as.factor = T)

# 3. Generar datasets -----------------------------------------------------
set.seed(12072018)

grupos <- c("grupo1", "grupo2", "grupo3")

grupos <- iconv(grupos, to='ASCII//TRANSLIT')

for (i in 1:length(grupos)) {
  write_sav(issp[sample(nrow(issp),800),],
            paste0("datos/",
                   grupos[i], ".Rdata"))
}

setwd("../../../..")
getwd()
