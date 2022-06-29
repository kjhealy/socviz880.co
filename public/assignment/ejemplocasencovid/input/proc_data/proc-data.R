# Código de Preparación de datos

# 1. Cargar librerías ----

pacman::p_load(dplyr, summarytools, sjmisc)

# 2. Cargar datos ----

## Base de datos COVID 19 al 25 de abril de 2020

covid <- read.csv("/cloud/project/2020-05-29-CasosConfirmados.csv")
  
## Base de datos CASEN 2017
load("/cloud/project/casen2017_sub.RData"); casen17 <- BCASEN1;remove(BCASEN1)

# 3. Seleccion de variables a utilizar y renombrar variables ----

# Para CASEN
names(casen17)
casen1 <- casen17 %>% select(cod_comuna=comuna,"dorm_hh"=v27a,tot_per) %>% mutate(hacinamiento=tot_per/dorm_hh)
#Para COVID
names(covid)
covid1 <- covid %>% select(comuna=Comuna,cod_comuna=Codigo.comuna,poblacion=Poblacion,casos_conf=Casos.Confirmados) %>% mutate(t_contagio = (casos_conf*100000)/poblacion)

# 4. Procesamiento de variables ----

# 4.1 Descriptivo por cada variable

view(dfsummary(casen1, plan.ascii = F))
view(dfsummary(casen1, plan.ascii = F))

# 4.2 Recodificación
casen1$dorm_hh[casen17$dorm_hh==99] <-NA
casen1$dorm_hh[casen17$dorm_hh==0]  <-NA

# 4.3 Calcular índice de hacinamiento

casen2 <- casen1 %>% group_by(cod_comuna) %>% summarise(mean_hacinamiento=mean(hacinamiento,na.rm = T))

# 4.4 Desetiquetar variables
casen2 <- sjlabelled::remove_all_labels(casen2)

# 4.5 Unir bases de datos
casen_covid19 <- left_join(x = covid1,y =casen2)

# 5. Guardar bases de datos ----
save(casen_covid19, file = "CASEN-COVID19.RData")
