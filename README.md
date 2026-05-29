# Tipos-de-datos-en-finanzas
Realización de parte del Módulo 1 del curso Análisis Financiero de la Universidad de los Andes

«Tutorial OG.R» es el archivo original que se tuvo en cuenta.
«Tipos de datos en finanzas.R» es el archivo editado por mi persona con cambios muy minimos.
Y en «Practica - Tipos de datos en finanzas.R» se hizo seguimiento de las siguientes instrucciones:

1. Obtén los volúmenes y precios ajustados de los activos: IBM (IBM), ORACLE (ORCL), Intel (INTC) y Microsoft (MSFT) a partir del 2015. La función para la obtención de los precios los podrás obtener mediante las líneas de código que se encuentran en el archivo del código. (Líneas código 16-32) 
2. Para ello, ten presente la ubicación de la información de los volúmenes tranzados y precios ajustados están en las columnas 5 y 6, respectivamente (línea 23 del código). 
3. Junta los datos de los activos y renombra las columnas (líneas 35-37 del código). 
4. Genera una serie de tiempo interactiva mediante la función dygraph, seleccionando una ventana de fechas desde el primero enero 2015 (“2015-01-01”) al 31 diciembre 2020 (“2020-12-31”). Para ello, recuerda la ubicación de las columnas de precios de los activos, resultado de la operación en el punto anterior. Es decir, debes seleccionar estas columnas de manera correcta (línea 41 del código). 
5. Ahora, generarás un panel de datos, empleando los precios de serie de los activos y los volúmenes tranzados. Para ello, ubica nuevamente, las columnas de los precios de los activos que resultaron de la operación de juntar los datos de los diferentes activos (paso 3 o revisa las líneas 35 a la 37 de tu código). Selecciona las columnas de precios y aquellas de los volúmenes; repórtalo en las líneas 55 y 56 del código. Genera el gráfico interactivo mediante la función htmltools (línea 60 del código). 
6. Ahora, generarás un histograma de los precios para el 2015 de Microsoft. Para ello, primero debes ubicar la columna donde se encuentran los precios de MSF, resultado del punto 3 de esta actividad. Una vez identificada la columna, puedes especificarla en la función subset (línea 68 del código). 
7. Repite la misma operación ahora para el año 2020.  
8. Genera los histogramas de cada año. 
