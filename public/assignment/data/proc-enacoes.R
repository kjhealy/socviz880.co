library(dplyr)
library(sjlabelled)
library(sjmisc)
load("data/ENACOES2014.RData")


find_var(enacoes,"Edad")



coes <- enacoes %>% select(voto=F3,sexo=P1,edad=P2,educ=P4) %>% filter(edad>=18)

coes$voto <- car::recode(coes$voto,"2=0;9=NA")
coes$sexo <- car::recode(coes$sexo,"1=0;2=1;9=NA")
coes$edad <- car::recode(coes$edad,"99=NA")
coes$educ <- car::recode(coes$educ,"c(1,2)=1;3=2;c(4,5)=3;c(6,7,8)=4;c(9,10)=5;c(88,99)=NA")



enacoes <- coes %>% select(voto,sexo,edad,educ) 

enacoes$voto <- as_factor(enacoes$voto)
enacoes$voto <- set_label(x = enacoes$voto,"Votó en última elección") 

enacoes$voto <- set_labels(x = enacoes$voto,labels = c("Votó"=1, "No votó"=0)) 

enacoes$sexo <- as_factor(enacoes$sexo )
enacoes$sexo <- set_label(x = enacoes$sexo,"Sexo entrevistado") 
enacoes$sexo <- set_labels(x = enacoes$sexo,labels = c("Mujer"=1, "Hombre"=0))

enacoes$edad <- as.numeric(enacoes$edad)
enacoes$edad <- set_label(x = enacoes$edad,"Edad entrevistado") 

enacoes$educ <- factor(enacoes$educ)
enacoes$educ <- set_label(x = enacoes$educ,"Nivel Educacional") 
enacoes$educ <- set_labels(x = enacoes$educ,labels = c("Primaria incompleta o menos"=1, 
                                                       "Primaria"=2,
                                                       "Secundaria"=3,
                                                       "Técnica Superior"=4,
                                                       "Universitaria o postgrado"=5))
enacoes <- na.omit(enacoes)
sjPlot::view_df(enacoes,show.frq = T, show.prc = T)
save(enacoes,file = "data/enacoes.RData")

# Calcule la probabilidad predicha de que una persona asista a votar según diferentes niveles de confianza social. Considere los siguientes niveles: (a) No confía (código 0), (b) Confianza baja (código 1), (c) Confianza media (código 2), y (d) Confianza alta (código 3). Para sus cálculos considere las siguientes especificaciones:
#   
#   a. Una mujer, de 46 años, soltera, de derecha y con educación media completa (educon = 5) 

m3=glm(voto~sexo+edad+educon+ecivil+ppol+socconf+ppol*socconf, 
       data=coes, family="binomial") #Interacción Posición Política*Confianza Social 


library(car)
#----Determinamos las especificaciones conf=0--------
phat.conf0 <- deltaMethod(object = m3,
                          g="exp(b0*1+b1*1+b2*46+b3*5+b4*1+b5*0+b6*0+b7*0+b8*1+b9*0+ b9*0 +b10*0+ b11*0 +b12*0+b13*0)/
                          (1+exp(b0*1+b1*1+b2*46+b3*5+b4*1+b5*0+b6*0+b7*0+b8*1+b9*0+ b9*0 +b10*0+ b11*0 +b12*0+b13*0))",
                          parameterNames = paste("b",0:13,sep = ""))

cbind("Pr(Y=1)"=    phat.conf0$Estimate, #Probabilidad  predicha
      "SE(Pr(Y=1))"=phat.conf0$SE, #Error estándar
      "Inf"=        phat.conf0$`2.5 %`, # Intervalo de confianza inferior
      "Sup"=        phat.conf0$`97.5 %`) #Intervalo de Confianza superior

#----Calcular los IC al 95% a mano--------
cbind("Inf"=phat.conf0$Estimate-1.96*phat$SE,
      "Sup"=phat.conf0$Estimate+1.96*phat$SE)

#----Determinamos las especificaciones conf=1--------
phat.conf1 <- deltaMethod(object = m3,
                          g="exp(b0*1+b1*1+b2*46+b3*5+b4*1+b5*0+b6*0+b7*0+b8*1+b9*0+ b9*0 +b10*0+ b11*0 +b12*0+b13*1)/
                          (1+exp(b0*1+b1*1+b2*46+b3*5+b4*1+b5*0+b6*0+b7*0+b8*1+b9*0+ b9*0 +b10*0+ b11*0 +b12*0+b13*1))",
                          parameterNames = paste("b",0:13,sep = ""))

cbind("Pr(Y=1)"=    phat.conf1$Estimate, #Probabilidad  predicha
      "SE(Pr(Y=1))"=phat.conf1$SE, #Error estándar
      "Inf"=        phat.conf1$`2.5 %`,  # Intervalo de confianza inferior
      "Sup"=        phat.conf1$`97.5 %`) #Intervalo de Confianza superior

#----Calcular los IC al 95% a mano--------
cbind("Inf"=phat.conf1$Estimate-1.96*phat$SE,
      "Sup"=phat.conf1$Estimate+1.96*phat$SE)


#----Determinamos las especificaciones conf=2--------
phat.conf2 <- deltaMethod(object = m3,
                          g="exp(b0*1+b1*1+b2*46+b3*5+b4*1+b5*0+b6*0+b7*0+b8*1+b9*0+ b9*0 +b10*0+ b11*0 +b12*0+b13*2)/
                          (1+exp(b0*1+b1*1+b2*46+b3*5+b4*1+b5*0+b6*0+b7*0+b8*1+b9*0+ b9*0 +b10*0+ b11*0 +b12*0+b13*2))",
                    parameterNames = paste("b",0:13,sep = ""))

cbind("Pr(Y=1)"=    phat.conf2$Estimate, #Probabilidad  predicha
      "SE(Pr(Y=1))"=phat.conf2$SE, #Error estándar
      "Inf"=        phat.conf2$`2.5 %`,  # Intervalo de confianza inferior
      "Sup"=        phat.conf2$`97.5 %`) #Intervalo de Confianza superior

#----Calcular los IC al 95% a mano--------
cbind("Inf"=phat.conf2$Estimate-1.96*phat$SE,
      "Sup"=phat.conf2$Estimate+1.96*phat$SE)

#----Determinamos las especificaciones conf=3--------
phat.conf3 <- deltaMethod(object = m3,
                    g="exp(b0*1+b1*1+b2*46+b3*5+b4*1+b5*0+b6*0+b7*0+b8*1+b9*0+ b9*0 +b10*0+ b11*0 +b12*0+b13*3)/
                    (1+exp(b0*1+b1*1+b2*46+b3*5+b4*1+b5*0+b6*0+b7*0+b8*1+b9*0+ b9*0 +b10*0+ b11*0 +b12*0+b13*3))",
                    parameterNames = paste("b",0:13,sep = ""))

cbind("Pr(Y=1)"=    phat.conf3$Estimate, #Probabilidad  predicha
      "SE(Pr(Y=1))"=phat.conf3$SE, #Error estándar
      "Inf"=        phat.conf3$`2.5 %`,  # Intervalo de confianza inferior
      "Sup"=        phat.conf3$`97.5 %`) #Intervalo de Confianza superior

#----Calcular los IC al 95% a mano--------
cbind("Inf"=phat.conf3$Estimate-1.96*phat$SE,
      "Sup"=phat.conf3$Estimate+1.96*phat$SE)
