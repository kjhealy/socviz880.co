
# Ejemplos escenarios de regresión multiple

## Librerías

```{r}
pacman::p_load(
  lattice,
  car,
  texreg,
  corrplot
)
```


## Caso 1: No correlación entre predictores 


### Generación de datos para el ejemplo
```{r }
set.seed(23)
nobs = 100

# Matriz a simular
m<- matrix(c(1.0,0.4,0.2,
             0.4,1.0,0.0,
             0.2,0.0,1.0),nrow=3,ncol=3)

# Cholesky decomposition
l = chol(m)
nvars = dim(l)[1]
r = t(l) %*% matrix(rnorm(nvars*nobs), nrow=nvars, ncol=nobs)
r = t(r)

rdata1 = as.data.frame(r)
names(rdata1) = c('resp', 'pred1', 'pred2')
```


### Correlación datos rdata1

```{r}
m1=cor(rdata1)
m1
corrplot.mixed(m1)
```


### Regresiones

```{r}
r1dat1<-lm(resp ~ pred1, data=rdata1)
r2dat1<-lm(resp ~ pred2, data=rdata1)
r3dat1<-lm(resp ~ pred1 + pred2, data=rdata1)

screenreg(list(r1dat1, r2dat1, r3dat1), booktabs = TRUE, dcolumn = TRUE)
```


# Caso 2: Correlación entre predictores

set.seed(23)
nobs = 100

## Using a correlation matrix (let' assume that all variables
## have unit variance

m<- matrix(c(1.0,0.5,0.7,
             0.5,1.0,0.3,
             0.7,0.3,1.0),nrow=3,ncol=3)

# Cholesky decomposition
l = chol(m)
nvars = dim(l)[1]


r = t(l) %*% matrix(rnorm(nvars*nobs), nrow=nvars, ncol=nobs)
r = t(r)

rdata2 = as.data.frame(r)
names(rdata2) = c('resp', 'pred1', 'pred2')

cor(rdata2)


x1<-(lm(resp~pred1+pred2,data = rdata2))
x2<-(lm(resp~pred1,data = rdata2))
x3<-(lm(resp~pred2,data = rdata2))

stargazer(x1,x2,x3, type = "text")




#simulacion 3: predictores muy correlacionados

nobs = 100

## Using a correlation matrix (let' assume that all variables
## have unit variance

m<- matrix(c(1,0.5,0.7,
             0.5,1,0.8,
             0.7,0.8,1),nrow=3,ncol=3)

# Cholesky decomposition
l = chol(m)
nvars = dim(l)[1]

t(l)
t(l) %*% l

r = t(l) %*% matrix(rnorm(nvars*nobs), nrow=nvars, ncol=nobs)
r = t(r)

rdata3 = as.data.frame(r)
names(rdata3) = c('resp', 'pred1', 'pred2')

cor(rdata3)



x1<-(lm(resp~pred1+pred2,data = rdata3))
x2<-(lm(resp~pred1,data = rdata3))
x3<-(lm(resp~pred2,data = rdata3))

stargazer(x1,x2,x3, type = "text")





