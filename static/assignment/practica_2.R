# Código Páctica 2: Descripción de variables


#1. Cargar librerías

pacman::p_load(dplyr, #Manipulación de datos
               stargazer, #Tablas
               sjmisc, # Tablas
               summarytools, # Tablas
               kableExtra, #Tablas
               sjPlot, #Tablas y gráficos
               corrplot, # Correlaciones
               sessioninfo) # Información de la sesión de trabajo

#2. Datos

## Desde internet

load(url("https://multivariada.netlify.app/assignment/data/proc/ELSOC_ess_merit2016.RData"))

names(proc_elsoc) #Ver nombres variables
dim(proc_elsoc) # Ver cantidad de casos y variables de la base

## Variables:

#[pmerit] = Indice promedio de percepción de meritocracia.

#[ess] = Estatus Social Subjetivo: Donde se ubicaria ud. en la sociedad chilena" (0 = el nivel mas bajo; 10 = el nivel mas alto)

#[edcine] = Nivel educacional(1 = Primaria incompleta menos, 2 = Primaria y secundaria baja, 3 = Secundaria alta, 4 = Terciaria ciclo corto, 5 = Terciaria y Postgrado)

#[sexo] = Sexo (O = Hombre; 1 = Mujer)

#[edad] = ¿Cuáles su edad? (años cumplidos)


# 3. Descripción de variables

## Tabla descriptiva de variables para sección metodológica

### Tabla descriptiva con stargazer

stargazer(proc_elsoc,type = "text") 

### Tablas descriptivas con descr, librería sjmisc

sjmisc::descr(proc_elsoc)

sjmisc::descr(proc_elsoc,
              show = c("label","range", "mean", "sd", "NA.prc", "n"))%>%
  kable(.,"markdown") 

### Tabla descriptiva con summarytools::dfSummary

dfSummary(proc_elsoc, plain.ascii = FALSE)

view(dfSummary(proc_elsoc, headings=FALSE))

## Extraer NA de la base de datos

proc_elsoc_original <-proc_elsoc # Respaldo base original

dim(proc_elsoc) # Dimensión base de datos

sum(is.na(proc_elsoc)) # Cantidad NA en la base

proc_elsoc <-na.omit(proc_elsoc) # Eliminar NA

dim(proc_elsoc) # Dimensión base posterior eliminación de NA

proc_elsoc <-sjlabelled::copy_labels(proc_elsoc,proc_elsoc_original) # Restaurar etiquetas de base respaldada

## Exploración de asociación entre variables

#Asociaciones dependiendo de las variables:
#Variables categóricas: tablas de contingencia.
#Variable categórica y continua: tabla de estadisticos por categoría o gráficos de caja y bigote.
#Variables continuas: correlaciones.

## Tabla de contingencia para variables categóricas

sjt.xtab(proc_elsoc$edcine, proc_elsoc$sexo) #Tabla de contingencia


sjt.xtab(proc_elsoc$edcine, proc_elsoc$sexo,
         show.col.prc=TRUE,
         show.summary=FALSE)

## Tabla de estadísticos de variable continua por categorías

tapply(proc_elsoc$pmerit, proc_elsoc$edcine, mean) #Tabla simple

proc_elsoc %>% # se especifica la base de datos
  select(pmerit,edcine) %>% # se seleccionan las variables
  dplyr::group_by(Educación=sjlabelled::as_label(edcine)) %>% # se agrupan por la variable categórica y se usan sus etiquetas con as_label
  dplyr::summarise(Obs.=n(),Promedio=mean(pmerit),SD=sd(pmerit)) %>% # se agregan las operaciones a presentar en la tabla
  kable( format = "markdown") # se genera la tabla

## Gráficos de caja y bigote por categoría

plot_grpfrq(proc_elsoc$pmerit,proc_elsoc$edcine,
            type = "box")

## Correlaciones (variables continuas)


M <- cor(proc_elsoc) # Forma básica de visualizar correlaciones
M

### Tablas de correlaciones

tab_corr(proc_elsoc) 


tab_corr(proc_elsoc,
         triangle = "lower") 

### Matriz de correlaciones

corrplot.mixed(M) 

names(proc_elsoc) # Nombres variables

### Nube de puntos (scatter plot)

plot_scatter(proc_elsoc, edad, ess)

## Nota final
sessionInfo() # Información sobre la sesión de R
session_info("sessioninfo")$platform #Información más precisa
package_info(pkgs = (.packages()), dependencies = FALSE) # Información sobre paquetes
