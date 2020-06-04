# C??digo Pr??ctica 1: Preparaci??n de datos en R.

# 1. Cargar librer??as
install.packages("pacman")
pacman::p_load(dplyr, sjmisc, car, sjlabelled, stargazer)

# 2. Cargar datos
## Ajustar espacio de trabajo
rm(list=ls())       # borrar todos los objetos en el espacio de trabajo
options(scipen=999) # valores sin notaci??n cientifica

## Desde internet 
load(url("https://multivariada.netlify.com/assignment/data/original/ELSOC_W01_v3.10.RData"))

## Chequeo basico de la base de datos
dim(elsoc_2016) # dimension de la base
View(elsoc_2016)

# 3. Seleccion de variables 
## Identificar variables de interes 
find_var(data = elsoc_2016,"esfuerzo")

## Seleccion de variables 
proc_elsoc <- elsoc_2016 %>% select(c18_09, # percepcipn meritocracia esfuerzo
                                    c18_10, # percepcion meritocracia talento
                                    d01_01, # estatus social subjetivo
                                    m01,    # nivel educacional
                                    m0_sexo,# sexo
                                    m0_edad)# edad

## Comprobar
names(proc_elsoc)

## Obtener etiquetas de las variables 
sjlabelled::get_label(proc_elsoc)

# 4. Procesamiento de variables
## Descriptivo
frq(proc_elsoc$c18_09) 
frq(proc_elsoc$c18_10)

## Recodificacion
proc_elsoc$c18_09 <- recode(proc_elsoc$c18_09, "c(-888,-999)=NA")
proc_elsoc$c18_10 <- recode(proc_elsoc$c18_10, "c(-888,-999)=NA")

## Etiquetado 
proc_elsoc <- proc_elsoc %>% rename("mesfuerzo"=c18_09, # meritocracia esfuerzo
                                    "mtalento" =c18_10) # meritocracia talento
get_label(proc_elsoc$mesfuerzo)
proc_elsoc$mesfuerzo <- set_label(x = proc_elsoc$mesfuerzo,label = "Recompensa: esfuerzo")

get_label(proc_elsoc$mtalento)
proc_elsoc$mtalento  <- set_label(x = proc_elsoc$mtalento, label = "Recompensa: talento")

## Otros ajustes
proc_elsoc$pmerit <- (proc_elsoc$mesfuerzo+proc_elsoc$mtalento)/2
summary(proc_elsoc$pmerit)
get_label(proc_elsoc$pmerit)
proc_elsoc$pmerit  <- set_label(x = proc_elsoc$pmerit, label = "Meritocracia promedio")

## Revision final
frq(proc_elsoc$mesfuerzo)
frq(proc_elsoc$mtalento)
frq(proc_elsoc$pmerit)

# 5. Generacion de base de datos procesada para el analisis
## Revision de datos
stargazer(proc_elsoc, type="text")

## Guardar base de datos
save(proc_elsoc,file = "[ruta hacia carpeta local en su computador]/ELSOC_ess_merit2016.RData")

## Estructura carpeta de datos
save(proc_elsoc,file = "content/assignment/data/proc/ELSOC_ess_merit2016.RData")
