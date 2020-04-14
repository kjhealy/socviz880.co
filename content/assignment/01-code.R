## ----setup, include=FALSE------------------------------------------------
knitr::opts_chunk$set(cache = TRUE)


## pre, code {white-space:pre !important; overflow-x:auto}


## ----eval=FALSE----------------------------------------------------------
## install.packages("pacman")


## ------------------------------------------------------------------------
pacman::p_load(dplyr, sjmisc, car, sjlabelled, stargazer)


## ------------------------------------------------------------------------
rm(list=ls())       # borrar todos los objetos en el espacio de trabajo
options(scipen=999) # valores sin notación científica


## ----eval=TRUE-----------------------------------------------------------
#cargamos la base de datos desde internet
load(url("https://multivariada.netlify.com/assignment/data/original/ELSOC_W01_v3.10.RData"))


## ------------------------------------------------------------------------
dim(elsoc_2016) # dimension de la base


## ------------------------------------------------------------------------
View(elsoc_2016)


## ------------------------------------------------------------------------
find_var(data = elsoc_2016,"esfuerzo")


## ------------------------------------------------------------------------
proc_elsoc <- elsoc_2016 %>% select(c18_09, # percepción meritocracia esfuerzo
                          c18_10, # percepción meritocracia talento
                          d01_01, # estatus social subjetivo
                          m01,    # nivel educacional
                          m0_sexo,# sexo
                          m0_edad)# edad


## ------------------------------------------------------------------------
frq(proc_elsoc$c18_09)
frq(proc_elsoc$c18_10)


## ------------------------------------------------------------------------
proc_elsoc$c18_09 <- recode(proc_elsoc$c18_09, "c(-888,-999)=NA")
proc_elsoc$c18_10 <- recode(proc_elsoc$c18_10, "c(-888,-999)=NA")


## ------------------------------------------------------------------------
proc_elsoc <- proc_elsoc %>% rename("mesfuerzo"=c18_09, # meritocracia esfuerzo
                          "mtalento" =c18_10) # meritocracia talento



## ------------------------------------------------------------------------
proc_elsoc$pmerit <- (proc_elsoc$mesfuerzo+proc_elsoc$mtalento)/2
summary(proc_elsoc$pmerit)


## ------------------------------------------------------------------------
frq(proc_elsoc$mesfuerzo)
frq(proc_elsoc$mtalento)
frq(proc_elsoc$pmerit)



## ------------------------------------------------------------------------
frq(proc_elsoc$m01)


## ------------------------------------------------------------------------
proc_elsoc$m01 <- recode(proc_elsoc$m01, "c(-888,-999)=NA")


## ------------------------------------------------------------------------
# recodificacion usando funcion 'recode' de la libreria car
proc_elsoc$m01 <- car::recode(proc_elsoc$m01, "c(1,2)=1; c(3)=2;c(4,5)=3;c(6,7)=4;c(8,9,10)=5")


## ------------------------------------------------------------------------
frq(proc_elsoc$m01)


## ------------------------------------------------------------------------
proc_elsoc$m01 <- set_labels(proc_elsoc$m01,
            labels=c( "Primaria incompleta menos"=1,
                      "Primaria y secundaria baja"=2,
                      "Secundaria alta"=3,
                      "Terciaria ciclo corto"=4,
                      "Terciaria y Postgrado"=5))


## ------------------------------------------------------------------------
proc_elsoc <- rename(proc_elsoc,"edcine"=m01)


## ---- results='hold'-----------------------------------------------------
frq(proc_elsoc$d01_01)
summary(proc_elsoc$d01_01)


## ------------------------------------------------------------------------
proc_elsoc$d01_01 <- recode(proc_elsoc$d01_01, "c(-888,-999)=NA")


## ------------------------------------------------------------------------
proc_elsoc <- proc_elsoc %>% rename("ess"=d01_01) # estatus social subjetivo


## ------------------------------------------------------------------------
frq(proc_elsoc$m0_sexo)


## ------------------------------------------------------------------------
proc_elsoc$m0_sexo <- car::recode(proc_elsoc$m0_sexo, "1=0;2=1")


## ------------------------------------------------------------------------
proc_elsoc$m0_sexo <- set_labels(proc_elsoc$m0_sexo,
            labels=c( "Hombre"=0,
                      "Mujer"=1))


## ------------------------------------------------------------------------
proc_elsoc <- rename(proc_elsoc,"sexo"=m0_sexo)



## ------------------------------------------------------------------------
frq(proc_elsoc$sexo)


## ------------------------------------------------------------------------
frq(proc_elsoc$m0_edad)


## ------------------------------------------------------------------------
proc_elsoc <- rename(proc_elsoc,"edad"=m0_edad)


## ------------------------------------------------------------------------
stargazer(proc_elsoc, type="text")


## ----eval=FALSE----------------------------------------------------------
## save(proc_elsoc,file = "[ruta hacia carpeta local/ELSOC_ess_merit2016.RData")


## ------------------------------------------------------------------------
save(proc_elsoc,file = "data/proc/ELSOC_ess_merit2016.RData")

