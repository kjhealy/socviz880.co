# Partials & multiple regression


```{r}

pacman::p_load(dplyr,
               corrplot,
               ggplot2,
               scatterplot3d,
               texreg,
               kable,
               stargazer)

datos=read.csv("ingedexp.csv", sep="")
stargazer(datos, type = "text", digits=0)

cormat=datos %>% select(ingreso,educacion,experiencia) %>% cor()
round(cormat, digits=2)
corrplot.mixed(cormat)

# Scatters

ggplot(datos, aes(x=educacion, y=ingreso)) + geom_point() +
  geom_smooth(method=lm, se=FALSE) 

ggplot(datos, aes(x=experiencia, y=ingreso)) + geom_point() +
  geom_smooth(method=lm, se=FALSE) 

ggplot(datos, aes(x=educacion, y=experiencia)) + geom_point() +
  geom_smooth(method=lm, se=FALSE) 

attach(datos)
s3d <-scatterplot3d(educacion,experiencia,ingreso, pch=16, highlight.3d=TRUE,
                    type="h", main="3D Scatterplot")
s3d$plane3d(reg_y_x1_x2)


reg_y_x1=lm(ingreso ~ educacion, data=datos)
reg_y_x2=lm(ingreso ~ experiencia, data=datos)
reg_y_x1_x2=lm(ingreso ~ educacion + experiencia , data=datos)


screenreg(list(reg_y_x1,reg_y_x2,reg_y_x1_x2,reg_y_x1_x2_x1x2))

# Residuals


reg_x1_x2=lm(educacion ~ experiencia , data=datos)

x1_fit_x2=fitted.values(reg_x1_x2)
resx1_2=residuals(reg_x1_x2)

datos=cbind(datos, x1_fit_x2,resx1_2)
datos

regy_resx1_2=lm(datos$ingreso ~ resx1_2)


screenreg(list(reg_y_x1,reg_y_x2,reg_y_x1_x2,regy_resx1_2), booktabs = TRUE, dcolumn = TRUE, doctype = FALSE, caption=" ")

```


$$b_1=(\frac{s_y}{s_1})(\frac{r_{y1}-r_{y2}r_{12}}{1-r^2_{12}})$$

  
  
$$b_2=(\frac{s_y}{s_2})(\frac{r_{y2}-r_{y1}r_{12}}{1-r^2_{12}})$$
