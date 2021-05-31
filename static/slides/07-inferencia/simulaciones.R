
library(stargazer)
library(texreg)
#
set.seed(123)
#simulaciones
n<-200000
nota_1<-round(rnorm(n,5.2,1),2) #Nota
sexo<-rbinom(n,1,.4)            #Sexo
asis<-round(rnorm(n,0.70,0.20),1)#asistencia
b0 <- 1
b1 <- 0.65
b2 <- 0.05
b3 <- 0.8
e  <- rnorm(n,0,1)
nota_2 <- round((b0 + b1*nota_1  + b2*sexo  + b3*asis + e),2)

datos<- as.data.frame(cbind(nota_1,sexo,asis,nota_2))
head(datos)
dim(datos)
summary(datos)

#regresión en la población
m_poblacion <-lm(nota_2~nota_1+as.factor(sexo)+asis, data = datos) 
screenreg(m_poblacion)

#regresión en una muestra
index <- sample(1:nrow(datos), 500, replace=F)
muestra<-datos[index,]
head(muestra)
dim(muestra)

m_muestra <-lm(nota_2~nota_1+as.factor(sexo)+asis, data = muestra) 
screenreg(m_muestra)
summary(m_muestra)
m_muestra$coefficients[2]

#valor T
valor_t <- (0.66499-0)/0.04953
#DF: grados de libertad
grados_libertad<-(500-3-1)
2*pt(-abs(valor_t),df=496)
2 * pnorm(valor_t)

( pval  <- 2*pt(-abs(tstat),137) )

regtable <- summary(m_muestra)$coefficients
bhat <- regtable[,1]
se   <- regtable[,2]

# Reproduce t statistic
( tstat <- bhat / se )
# Reproduce p value
( pval  <- 2*pt(-abs(tstat),137) ) #la significación esta en el borde, reducir poder estadístico


#Intervalos de confianza
confint(m_muestra)
confint(m_muestra,level = 0.99)

# Distribución del beta en 100 muestras aleatorias ------------------------



beta_j<-100
#funcion de regresion
regresion<-function(muestra){
  lm(nota_2~nota_1+as.factor(sexo)+asis, data = muestra)
}
#loop
for(j in 1:100){
  sampl<-datos[sample(1:nrow(datos),500, replace = F),]
  beta_j[j]<-regresion(sampl)$coefficients[2]
  }
mean(beta_j)
plot(density(beta_j))
summary(beta_j)



# Gráfico de Distribución T -----------------------------------------------
# sacado de
# https://www.econometrics-with-r.org/5-1-testing-two-sided-hypotheses-concerning-the-slope-coefficient.html



# Plot the standard normal on the support [-6,6]
t <- seq(-6, 6, 0.01)

plot(x = t, 
     y = dnorm(t, 0, 1), 
     type = "l", 
     col = "steelblue", 
     lwd = 2, 
     yaxs = "i", 
     axes = F, 
     ylab = "", 
     main = expression("Calculating the p-value of a Two-sided Test when" ~ t^act ~ "=-0.47"), 
     cex.lab = 0.7,
     cex.main = 1)

tact <- -4.75

axis(1, at = c(0, -1.96, 1.96, -tact, tact), cex.axis = 0.7)

# Shade the critical regions using polygon():

# critical region in left tail
polygon(x = c(-6, seq(-6, -1.96, 0.01), -1.96),
        y = c(0, dnorm(seq(-6, -1.96, 0.01)), 0), 
        col = 'orange')

# critical region in right tail

polygon(x = c(1.96, seq(1.96, 6, 0.01), 6),
        y = c(0, dnorm(seq(1.96, 6, 0.01)), 0), 
        col = 'orange')

# Add arrows and texts indicating critical regions and the p-value
arrows(-3.5, 0.2, -2.5, 0.02, length = 0.1)
arrows(3.5, 0.2, 2.5, 0.02, length = 0.1)

arrows(-5, 0.16, -4.75, 0, length = 0.1)
arrows(5, 0.16, 4.75, 0, length = 0.1)

text(-3.5, 0.22, 
     labels = expression("0.025"~"="~over(alpha, 2)),
     cex = 0.7)
text(3.5, 0.22, 
     labels = expression("0.025"~"="~over(alpha, 2)),
     cex = 0.7)

text(-5, 0.18, 
     labels = expression(paste("-|",t[act],"|")), 
     cex = 0.7)
text(5, 0.18, 
     labels = expression(paste("|",t[act],"|")), 
     cex = 0.7)

# Add ticks indicating critical values at the 0.05-level, t^act and -t^act 
rug(c(-1.96, 1.96), ticksize  = 0.145, lwd = 2, col = "darkred")
rug(c(-tact, tact), ticksize  = -0.0451, lwd = 2, col = "darkgreen")







# ejemplo de wooldridge ---------------------------------------------------
rm(list=ls())
library(wooldridge)
library(haven)
gpa1 <- read_dta("C:/Users/Fondecyt R. Sociales/Desktop/Suplementos multivariable/gpa1.dta")

# Store results under "sumres" and display full table:
( sumres <- summary( lm(colGPA ~ hsGPA+ACT+skipped, data=gpa1) ) )

# Manually confirm the formulas: Extract coefficients and SE
regtable <- sumres$coefficients
bhat <- regtable[,1]
se   <- regtable[,2]

# Reproduce t statistic
( tstat <- bhat / se )
# Reproduce p value
( pval  <- 2*pt(-abs(tstat),137) )



