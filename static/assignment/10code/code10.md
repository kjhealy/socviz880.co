
# Introducción

Un aspecto crucial cuando construimos modelos de regresión es la evaluación de la calidad del modelo. Hasta ahora habíamos conocido algunos algunos índices que nos permitían saber "la bondad de ajuste del modelo", lo que nos indicaban qué tan bien ajustan los modelos construidos a los datos recopilados. Ahora bien la evaluación del modelo consta más bien de tres ejes

**1. Supuestos**: un punto que hasta ahora habíamos pasado por alto tiene que ver con que los modelos de regresión tienen una serie de supuestos o "reglas" que se deben cumplir para que las estimaciones que estemos realizando sean **fidedignas** y *no se deban más bien a que estamos pasando por alto algunas propiedades de estos*. Hay algunas propiedades que conocemos de ante mano, por ejemplo, que los modelos de regresión **lineal** utilizan variables dependientes continuas y los modelos de regresión logística **dicotómicas**, esto debido a que el método de estimación se ajustará a la forma de distribución que tiene su variable dependiente.

Ahora bien, es esperable que el diagnóstico previo del modelo (o *pre hoc* como encontrarán en la literatura), considere algunas otras propiedades de la regresión. En esa sesión consideraremos los supuestos más esenciales: casos influyentes, normalidad de residuos, homogeneidad de la varianza,  multicolinealidad y linealidad de las relaciones. Evidentemente este último solo corre para las regresiones lineales.


**2. Ajuste**: una vez que decimos que nuestro modelo pasa la "prueba" de los supuestos, podemos abordar qué tan bien ajustan nuestros modelos con los datos utilizados (o cómo lo habíamos abordado antes, cuál es su *bondad de ajuste*). Este procedimiento que ocurre a posterior al chequeo de supuestos y estimación (y por ello se les llama diagnóstico **post hoc**) consta principalmente de considerar

2.1 Si trabajamos una regresión lineal: el R^2 ajustado

2.2 Si trabajamos una regresión logística: Pseudo R^2 y los *Criterios de Información* BIC y AIC (ambos nos dicen cuánta información se está "perdiendo" con las variables que se ocupan en cada modelo. Por ello elegiremos el modelo que tenga un BIC y AIC más bajo)

Pero ¡no te asustes! que no se cumplan algunos supuestos no implica que debas abandonar el **lindo mundo de las regresiones**. Como veremos, existen formas de solucionar los problemas de supuestos y ajuste de los modelos.

**3. Comparación**: una vez que hacemos **transformaciones** a los modelos, una etapa importante para la selección de estos es compararlos. Para ello consideraremos toda la información que tenemos de ellos en su diagnóstico de **pre y post hoc.**

En R existen diversas  funciones para crear un diagnóstico de supuestos y de ajuste a nuestros modelos. Ahora bien la gran parte de ello se desenvuelve en distintos paquetes, sobre todo  considerando que, como vimos, no existe un único enfoque para evaluar la calidad de nuestros modelos (más aún cuando son su variable dependiente tiene un nivel distinto de medición).

La buena noticia es que Daniel Lüdecke ha construido el paquete `performace` que reune todas estas herramientas, y que los tres ejes de la **calidad de los modelos** también las distingue en una función para cada una.

![](https://github.com/easystats/performance/blob/master/paper/figure_workflow.png?raw=true)

# Diagnóstico de la calidad de los modelos

## 1. Supuestos{#supuestos}

No dejemos las tareas a medias. Antes de interpretar un modelo (ver el tamaño efecto y significancia de sus coeficientes) y ver su ajuste, es evidente que primero debemos chequear la validez. En el siguiente apartado les presentaremos uno de los 5 supuestos más básicos, y que en caso de no cumplirse se presentan una serie de problemas que **debemos** solucionar.

### 1.1 Linealidad{#linealidad}

Para la regresión lineal múltiple, un supuesto importante es que existe una relación lineal entre la variable dependiente e independiente.

Es decir, podemos saber si se cumple este supuesto a partir de un gráfico de dispersión de datos, que relacione la variable dependiente y la independiente, y verificar de manera "intuitiva" si la **tendencia** de esta relación se puede describir por una **línea recta** (ascendente y decente como se ve en la figura)

![]

En este caso podemos notar claramente que no hay una relación lineal.


En caso de que no sea claro, una forma numérica para chequear este supuesto es que el valor promedio de los residuos sea cero. Si esto no es así los residuos están sesgados sistemáticamente, entonces probable que el modelo no sea realmente lineal, y esta desviación de los residuos deba corregirse re-especificando (medir de otra manera la variable) algún término de la ecuación de regresión al cuadrado o al cubo. Un modo que se ocupa para testear la necesidad de esta re-especificación es el test RESET de Ramsey que indica que:

$H_o$ cuando el modelo tiene algún término al cuadrado o cubo, la media de los residuos es cero. Es decir, que si no podemos rechazar $H_0$, nuestro modelo está bien especificado (es decir, es lineal). Como en este caso es claro que se necesita respecificar el predictor elevamos edad al cuadrado.

### 1.2 Homocedasticidad{#homocedasticidad}

Homoce ¿qué? Sí, *homocedasticidad*. Con este concepto indica que**los residuos** se distribuyen de forma **homogénea** (por eso el sufijo *homo*). Como ya podrás haber notado este supuesto se vincula con el de [linealidad](#linealidad)

Al igual que la linealidad también puede comprobarse con un gráfico de dispersión entre la variable dependiente (Y) e independiente X,  donde podamos ver de manera clara la recta de regresión estimada y la distribución de los residuos. Aceptaremos el supuesto de **homocedasticidad** si la variación de los residuos es homogénea, es decir, no veremos un patrón claro y más bien se *distribuirán de forma aleatoria*. De manera gráfica veremos una nube de puntos que tiene una *forma similar* en todo el rango de las observaciones de la variable independiente.

Para comprobar el supuesto de homocedasticidad de manera más certera utilizaremos la prueba Breusch-Pagan Godfrey cuya hipótesis nula indica que

$H_0$: La varianza de los residuos del modelo de regresión es constante

En este caso, buscaremos que aceptar la $H_0$ pues esto implica que "en suma y resta" si bien hay residuos, estos tienen una variación **homogénea** en todos los tramos de la relación de la variable dependiente con la independiente.

Cuando no hay una variación constante de los residuos hablamos de que estamos en prescencia de **heterocedasticidad**


## 1.3 Normalidad de residuos{#normalidad}

Además de la linealidad (media 0), la homocedasticidad (varianza mínima y constante), el método de estimación de la regresión lineal (*OLS* o *MCO* en español) requiere asegurar una **distribución normal** de los residuos pues en caso contrario el modelo no es consistente a través de las variables y observaciones (esto significa que los errores no son alteatorios).

Al igual que con los otros supuestos, la **normalidad** de los residuos se puede evaluar con métodos numéricos con pruebas que ya conocemos de otros cursos como la prueba de *Shapiro-Wilk* y Kolmogorov-Smirnov


### 1.4 Independencia{#independencia}

Evidentemente si los residuos no siguen una distribución normal, es probable que estos no sean independientes entre sí. Esto significa que buscaremos que los errores asociados a nuestro modelo de regresión sean **independientes**. Para saber si se cumple ese criterio se utiliza la prueba de Durbin-Watson, donde la $H_0$ supone que **los residuos son independientes**

check_autocorrelation

En síntesis sabemos la regresión lineal requiere de una relación lineal entre sus variables independientes y dependiente. Para ello no solo es importante chequear la distribución de los residuos, sino
dos posibilidades que pueden *tendenciar* esa relación lineal: como casos influyentes en la muestra y predictores que están altamente relacionados. Revisaremos la última de estas

### 1.5 Multicolinealidad{#multicolinealidad}

La multicolinealidad es la relación de dependencia lineal fuerte entre más de dos predictores de un modelo. Si esto ocurre uno podrá esperar que el valor de alguno de los predictores esté afectado por el otro. Esto hará dificil cuantificar con exactitud el efecto de cada predictor sobre la variable dependiente, precisamente pues puede ocurrir que el efecto que una variable predictora tenga sobre el fenómeno que se busca estudiar dependa del valor de otra variable del modelo.

En ese sentido hablaremos de una dependencia entre variables, un claro problema  para la regresión múltiple pues suponemos que podemos "controlar" o parcializar por el otro valor de la variable.
Comúnmente esta relación **endógena** entre variables la podemos examinar ante la existencia de altas correlaciones (*lineales*) entre variables. Ahora bien, la aproximación numérica a esto utilizada es el *VIF* (factor de inflación de varianza) que indica hasta que punto la varianza de los coeficientes de regresión se debe a la colinealidad (o dependencia) entre otras variables del modelo.

Es esperable que en ciencias sociales exista una relación entre las variables (pensemos por ejemplo, en percepción de justicia y percepción de desigualdad). Esto no quiere decir que necesariamente estas variables sean "endógenas". Por ello, el criterio convencional que se ocupa para evaluar la *multicolinealidad* en nuestra disciplina es evitar valores del VIF mayores a 2.5. Una solución *rápida* a este problema es eliminar alguno de los predictores o evaluar si es que estas variables más bien son parte de un mismo constructo, y por ello tomaremos como enfoque la construcción de un índice.

**Construcción de un índice**


### 1.6 Casos influyentes{#outliers}

Un último supuesto que revisaremos, y es el que probablemente parte del que más nos enfrentamos en las ciencias sociales, son los **casos influyentes** (también llamados en inglés, *outliers*). Un ejemplo claro de esto son las variables como ingresos, donde muchas veces tenemos casos extremos con muy bajos salarios y otros muy altos, y que pueden tendenciar nuestras rectas de regresión pese a que no es evidente una relación lineal(o algún tipo de relación) entre la variable independiente y dependiente.

Para verificar si un "caso es *influyente*" examinaremos si la ausencia o presencia de ese caso genera un cambio importante en la estimación del modelo de regresión. Este enfoque se aborda a partir del cálculo de la **Distancia de Cook** (Cook,1977)


## 2. Ajuste del modelo{#fit}

Sabemos por la [práctica 5](https://multivariada.netlify.app/assignment/05-code/) que podemos evaluar qué tan bien ajustan nuestros modelos con los datos utilizados. Sabemos que:

2.1 Si trabajamos una regresión lineal: el R^2 ajustado

2.2 Si trabajamos una regresión logística: Pseudo R^2 y los *Criterios de Información* BIC y AIC (ambos nos dicen cuánta información se está "perdiendo" con las variables que se ocupan en cada modelo. Por ello elegiremos el modelo que tenga un BIC y AIC más bajo).

```{r}
performance_model()
```

Es probable que estos ajustes coincidan mejor con el fenómeno que queremos analizar una vez que hicimos el chequeo de supuestos. Esto no implica necesariamente que el ajuste mejore, sino que seremos más *fieles* a la información que realmente nos están otorgando las variables.

Ya hemos dado una serie de  recomendaciones de transformaciones a las variables para manejar el problema de supuestos. En la siguiente tabla sistematizamos algunas de ellas.


### 2.1 Transformar predictor al cuadrado o cubo

Si estamos ante problemas de linealidad, indicamos que el término cuadrático o al cubo de algún predictor produce que la media de los residuos sea 0. Por lo general, por su distribución, esta variable es edad.

```{r}
movid_proc <- movid_proc %>% mutate(edad2 = (edad)^2)
```

### 2.2 Logaritmizar variable dependiente

Otro caso similar ocurre con *ingresos*, donde lo que se hace frecuentemente es transformar ingresos en un logaritmo de ingresos (*log(ingresos)*).

#### 2.2.1 Recuperar casos perdidos

¡Pero antes! Es común que en las encuestas sociales cierta variables posean una alta proporción de datos perdidos. Un ejemplo común es en el reporte de los ingresos de los hogares o individuos. Esto generalmente puede generarse por características de la persona (eg. desempleado, estudiante) o por deseabilidad social (eg. personas de altos ingresos desisten de reportar). Por lo general, existen dos estrategias para solicitar que las personas reporten sus ingresos: (1) reporte directo del monto y (2) si la persona no reporta los ingresos, se le presenta la posibilidad de ubicar los ingresos del hogar en tramos.

```{r, results='asis'}
movid_proc %>% select(ingreso, tingreso) %$%
print(dfSummary(., headings = FALSE, method = "render", varnumbers = F, lang = "es"))
```


Si observamos la tabla de descriptivos para la variable ingreso del hogar (`ingreso`), tenemos un porcentaje 25,3% de datos perdidos. Por esta razón, emplearemos los datos disponibles en `tingreso` para recuperar información en los ingresos del hogar.

La estrategia posee los siguientes pasos:

- **Paso 1:** Calcular la media por cada tramo
- **Paso 2:** En el caso de no tener información, remplazar por la media del tramo

```{r}
movid_proc <- movid_proc %>%
  mutate(tingreso = case_when(tingreso == "Menos de $200 mil pesos" ~ 200000,
                              tingreso == "Entre $200 y 350 mil pesos" ~ 275000,
                              tingreso == "Entre $351 y 500 mil pesos" ~ 425500,
                              tingreso == "Entre 501 y 800 mil pesos" ~ 650500,
                              tingreso == "Entre 801 mil y 1 millón 200 mil pesos" ~ 1000500,
                              tingreso == "Entre 1 millón 201 mil y 2 millones de pesos" ~ 1600500,
                              tingreso == "Entre 2 millones y 5 millones de pesos" ~ 3500000,
                              tingreso == "Más de 5 millones de pesos" ~ 5000000), #Paso 1
         ingreso = if_else(is.na(ingreso), tingreso, ingreso))
```

- **Paso 3:** Comparar el resultado de los tramos


```{r, results='asis'}
movid_proc %>% select(ingreso, tingreso) %$%
print(dfSummary(., headings = FALSE, method = "render", varnumbers = F, lang = "es")) #Paso 3
```

Vemos que pasamos de tener 25,3% de datos perdidos en ingresos a un 8,72% (es decir, recuperamos un 16,58% de los casos). A ingresos se le pueden hacer tres transformaciones más

**1. Logaritmizar**: en caso de que queramos seguir trabajando ingresos como una variable continua es una buena opción.

**2. Calcular el ingreso per cápita**: si dividimos el ingreso por el tamaño del hogar (n° de habitantes en este), obtendremos el ingreso por persona.

**3. Cálculo de medidas de posición acumulada**: con los ingresos per cápita se puede calcular la media o mediana de medidas de posición acumulada como quitiles

```{r}
movid_proc <- movid_proc %>%
  mutate(log_ing = log(ingreso), #Log ingresos
         ing_per = ingreso/tamanohogar, #Ingreso percapita
    quintiles = dplyr::ntile(ing_per,
                              n = 5)) # n de categorias, para quintiles usamos 5
```

### 2.3 Dicotomizar variable dependiente

Es recurrente que en las encuestas sociales nos encontremos con preguntas con *Escala Likert*. Sin embargo, muchas veces estas no tienen una distribución normal, y más bien las respuestas están concentradas en algunas categorías de referencia.

Si bien no hay criterios canónicos para trabajar esas variables, tiene sentido indicar que más bien no representan un constructo con 5 o más niveles, sino que probablemente de 2. Re-especificar la variable como dicotómica no solo ayudará a trabajar de manera más *realista* el constructo, sino que **facilitará** las interpretaciones que queramos hacer de nuestro modelo.

Ocuparemos dos criterios para la **dicotomización**:

1. **Medias**: se ocupará como criterio discriminante la media de la variable (donde 1 puede ser los valores mayores a la media, y 0 los inferiores).

2. **Mediana**: la más frecuente en medidas ordinales como las *escalas Likert* es cuando el 50% de los casos se concentra en unas pocas categoría de respuesta (eg, "Muy de acuerdo" y "De acuerdo" serán 1 y el resto 0).

En el caso de la variable `fatiga` que indica *"A medida que ha avanzado la crisis sanitaria, me siento cada vez más desmotivado para seguir las medidas de protección recomendadas"*, recodificaremos a aquellos como *1* a quiénes asienten a esta frase (*"Muy de acuerdo" y "De acuerdo"*)

```{r}
movid_proc <- movid_proc %>%
  mutate(fatigadummy = case_when(fatiga %in% c(5,4) ~ 1,
                                 fatiga %in% c(3,2,1) ~ 0, TRUE ~ NA_real_))
```

### 2.4 Errores estándares robustos

En caso de que estemos ante problemas de heterocedasticidad debemos re-estimar nuestro modelo considerando errores estándares robustos

```{r, eval = F}
model_robust<- lmtest::coeftest(model1, vcov=sandwich::vcovHC(model1))
```

### 2.5 Creación de índices

En el [tutorial de dplyr](https://www.youtube.com/watch?v=APzU10EMMjg&t=321s) ya habíamos abordado este punto. También está desarrollado de manera extensa en el [práctico N°1](https://multivariada.netlify.app/assignment/01-code/#bonus-track-generaci%C3%B3n-de-%C3%ADndices). Por ello, solo lo calaremos para aquellos ítems que mostraron posibilidad de ser colineales. Los pasos son

1. **Correlacionar** para verificar que estamos ante la presencia de ítems que podrían estar midiendo un constructo común. Como vemos en la siguiente tabla, las correlaciones son altas

```{r}
movid_proc %>% select(starts_with("c2")) %>%
  mutate_all(~as.numeric(.)) %>%
sjPlot::tab_corr(., triangle = "lower")
```

2. **Construcción de índice**: este puede ser sumativo o promedio. Esto dependerá de la escala de los ítems y del sentido del constructo final que queremos utilizar. En nuestro caso crearemos una índice sumativa de `salud mental`

```{r}
movid_proc <- movid_proc %>%
  mutate_at(vars(starts_with("c2")),~as.numeric(.)) %>%
  rowwise() %>%
  mutate(salud_mental = sum(c2_1,c2_2,c2_3,c2_4, na.rm = T))
```


### 2.6 Eliminar casos influyentes

En caso de que estemos ante la prescencia de casos influyentes debemos seguir los siguientes pasos

```{r, eval = F }
n<- nobs(model1) #n de observaciones
k<- length(coef(model1)) # n de parametros
dcook<- 4/(n-k-1) #Punto de corte

# Datos donde se filtran los valores sobre el punto de corte

movid_proc_so <- broom::augment_columns(model1,data = movid_proc) %>% filter(.cooksd<dcook)
```

Una vez finalizada las transformaciones calcular
dos nuevos modelos

```{r}
model1_fit <- lm(as.numeric(fatiga) ~ salud_mental +
               trabaja + sexo + edad + ing_per,
             data = movid_proc)

model2 <- lm(as.numeric(fatiga) ~ salud_mental +
               trabaja + sexo + edad2 + ing_per,
             data = movid_proc)

model3 <- glm(fatigadummy ~ salud_mental +
               trabaja + sexo + edad2 + ing_per, family = "binomial",
             data = movid_proc)

```

Luego, podemos hacer un chequeo general de diagnósticos de robustez con `check_model`, pero ahora indicando que queremos evaluar todos los indicadores posibles


```{r}
check_model(model1_fit, check = c("vif","normality", "linearity", "ncv", "homogeneity"))

check_model(model2, check = c("vif",  "normality", "linearity", "ncv", "homogeneity"))

check_model(model3, check = c("vif",  "homogeneity"))
```


Existen otros diagnósticos posibles para abordar en nuestros modelos, todo con el propósito de mejorar la calidad de estos. Uno de ellos, y que no abordaremos por su extensión, es la ausencia de
posibles **interacciones** entre las variables que no han sido modeladas (Fox & Weisberg 2018). En caso de su interés pueden revisar esto y ver su [aplicación simple en R en el siguiente link.](https://strengejacke.github.io/ggeffects/articles/introduction_partial_residuals.html)


## 3. Comparación de modelos{#compare}

Ahora bien, luego de estas transformaciones y cambios ¿cómo ajustan nuestros modelos? ¿habrán podido lidiar con los problemas de supuestos? Para ello es necesario que **comparemos los modelos estimados**.

Luego de esta comparación una pregunta legítima es **qué modelo seleccionar**. En general se propone seleccionar aquel modelo que ajuste mejor, pero ¡ojo! hay que cuidar que este realmente esté expresando el fenómeno que queremos medir. Por esta búsqueda de buena calidad, no vayamos a olvidar como futuras/os investigadores la importancia de **no tendenciar** datos, modelos y predicciones solo por afirmar un punto. Por ello, la selección de un buen modelo siempre significa no solo que pase el chequeo de las propiedades del método que estimamos, sino que este realmente haga sentido para las hipótesis que nos hemos planteado.

**Tabla 3**. Modelos de regresión que predice la fatiga a la pandemia
```{r echo = FALSE}
texreg::htmlreg(list(model1,model2,model3), custom.model.names = c("Modelo 1", "Modelo 2", "Modelo 3"), caption = "")
```

Si bien en con la tabla N°3  podemos tener un panorama, es **imprescindible** recordar que para comprar modelos (en su robustez y ajuste) es necesario que estos tengan *(1) la misma variable de respuesta y (2) el mismo número de observaciones.*
```{r}
compare_performance(model1_fit, model2) %>%
  print_md()
plot(compare_performance(model1_fit, model2))
```

Ahora bien, esto no quita que, considerando que el ajuste entre el modelo 1 ajusto y el modelo 2 no cambia sustantivamente, consideremos en seleccionar el modelo 3 por criterios más sustantivos. Podemos asegurarnos de esta comparación entre el modelo1 y modelo2 con un test que permite facilitar la decisión sobre la significancia de los índices que estamos viendo

```{r}
test_performance(model1_fit, model2) %>%
  print_md()
```


## Referencias

Lüdecke, Makowski, Waggoner & Patil (2020). Assessment of Regression   Models Performance. CRAN. Available from   https://easystats.github.io/performance/

Lüdecke, Makowski, Waggoner & Patil (2021). performance: Assessment of Regression   Models Performance. Journal of Open Source Software. 60(6). pp.3139. doi: 10.21105/joss.03139

Fox J, Weisberg S. Visualizing Fit and Lack of Fit in Complex Regression Models with Predictor Effect Plots and Partial Residuals. Journal of Statistical Software 2018;87. https://www.jstatsoft.org/article/view/v087i09
