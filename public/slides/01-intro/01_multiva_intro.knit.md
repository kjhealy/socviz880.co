---
title: "Estadística Multivariada"
author: ".small[Juan Carlos Castillo <br><br> Departamento de Sociología - UCH / COES <br><br>]"
date: "1 Sem 2021"
output:
  xaringan::moon_reader:
    css: ["../custom_2020.css"]
    lib_dir: libs
    nature:
      ratio: '16:9'
      highlightStyle: github
      highlightLines: true
      countIncrementalSlides: false
      beforeInit: "https://multinivel.netlify.com/docpres/xaringan_custom/macros.js"
    seal: false # esto omite title slide automática
---
class: front







<!--html_preserve--><style>.shareagain-bar {
--shareagain-foreground: rgb(255, 255, 255);
--shareagain-background: rgba(0, 0, 0, 0.5);
--shareagain-twitter: none;
--shareagain-facebook: none;
--shareagain-linkedin: none;
--shareagain-pinterest: none;
--shareagain-pocket: none;
--shareagain-reddit: none;
}</style><!--/html_preserve-->

<!---
Para correr en ATOM
- open terminal, abrir R (simplemente, R y enter)
- rmarkdown::render('static/docpres/07_interacciones/7interacciones.Rmd', 'xaringan::moon_reader')

About macros.js: permite escalar las imágenes como [scale 50%](path to image), hay si que grabar ese archivo js en el directorio.
--->


.pull-left-narrow[
# Estadística Multivariada
## Juan Carlos Castillo
## Sociología FACSO - UChile
## 1er Sem 2021 
## [.white[multivariada.netlify.app]](https://multivariada.netlify.com)
]

.pull-right-wide[
.right[


![:scale 50%](https://multivariada.netlify.com/img/hex_multiva.png)
<br>
<br>


##.red[Sesión 1: Presentación & organización]

]
]

---
class: roja, bottom, center


# 1.Presentación

---
class: inverse, middle, center

# ¿Dónde estamos?


---
# Ciclo de formación en métodos cuantitativos

![:scale 75%](ciclo.png)
--

### Descripción --------- Asociación --------- Explicación/predicción 

---
class: inverse middle center

# Este curso

---

# Encuesta ...

<br>
<br>

# Ir a [https://www.menti.com/jmasfc4qfd](https://www.menti.com/jmasfc4qfd) (link directo)

...o  a [menti.com](https://www.menti.com/) e introducir código 7645 6449


---

<iframe src="https://www.mentimeter.com/s/38e390612910ed2287d9ba31316974d4/20834cd3c4a5" height="500" width=100% allowfullscreen="true">
</iframe>

---
class: inverse middle center

# ¿Cómo llegamos desde la teoría sociológica a la estadística?

---
class: center, middle

![](temaproblema.png)

???

???
- ¿Cuál es su principal tema de interés social o preocupación actual en términos de la sociedad?
- ¿Por qué esto podría ser un problema?
- ¿Por que podría ser un problema de investigación?


Dar un par de pasos hacia atrás para llegar hasta la la explicación de fenómenos sociales, y conectar con intereses de la audiencia

---

- Hacia la **explicación** de los fenómenos o problemas sociales: **teoría**
.center[
![:scale 55%](simple.png)]

---

- Hacia la **explicación** de los fenómenos o problemas sociales: **teoría**, multicausalidad y contexto

.center[
![:scale 55%](multiple.png)
]

???

"Todo tiene que ver con todo ... " ,  "La realidad social es compleja ..." ... o, somos capaces de decir algo más como cieníficos sociales.

---
class: inverse, middle, center

## ¿Podemos decir algo más que _"depende", "la realidad social es compleja"_ o que _"los fenómenos sociales son multicausales"_?

---
# Estadística multivariada

- provee de **herramientas** estadísticas para el contraste de teorías relacionadas con problemas de investigación en .blue[contextos sociales complejos].

--

- para ello se centra en la estimación y análisis de un **modelo** estadístico (probabilístico) que permite comparar la influencia de distintos factores en un fenómeno social de .red[manera simultánea].

--

- esta pretensión se acompaña siempre del supuesto del **error**


---
# ... y énfasis transversales en 

.pull-left[
<br>

- reporte y comunicación de resultados

- apertura y reproducibilidad
]


.pull-right[

![:scale 80%](https://s3-eu-west-1.amazonaws.com/cp-cloudpublish-public/p6/5bf437f4a4745.png)
]

---
class: roja bottom right


# 2. Organización 

---
# Estructura general del curso

![:scale 110%](plan.png)

---
# Clases y prácticas


![](https://multivariada.netlify.app/img/clasesypracticas.png)


---
# _Prácticas_

- Se basa en el desarrollo autónomo de una **guía de trabajo** relacionada a los contenidos de la clase

- En el espacio simultáneo de revisión de práctica se revisa la guía en grupos pequeños bajo la supervisión de apoyo docente y profesor

- Se completa el **reporte de progreso** respectivo (para monitoreo y retroalimentación)

---
class: inverse, middle, center

# Sitio web del curso:

----

# [.red[multivariada.netlify.app]](https://multivariada.netlify.com/)

Objetivo: eficiencia, toda la información en un solo lugar

---
# Desarrollo del Práctico 1: Preparación de datos

- disponible en sitio web - marcha blanca

- repaso de contenidos anteriores y propuesta de trabajo (reproducible) en el análisis de datos

- realizar durante la semana 

- dudas: **Disqus**, foros UCursos, ayudantes, apoyo docente, profesor


---
class: roja, middle, center

# ¡ Bienvenid_s !



---
class: front

.pull-left[
# Estadística Multivariada
## Juan Carlos Castillo
## Sociología FACSO - UChile
## 1er Sem 2021
## [multivariada.netlify.app](https://multivariada.netlify.com)
]


.pull-right[
.right[
<br>
![:scale 80%](https://multivariada.netlify.com/img/hex_multiva.png)
]

]
