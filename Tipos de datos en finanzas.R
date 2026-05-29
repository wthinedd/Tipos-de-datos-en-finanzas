library(dygraphs)
library(xts)
library(quantmod)
library(dplyr)

options(warn = -1)

#-------------------------------------------------------------------

start <-format(as.Date("2014-01-01"), "%Y-%m-%d")
end <-format(as.Date("2024-01-01"), "%Y-%m-%d")

precios_volumenes <-function(simbolo)
{
  #Obtener precios stocks de Yahoo Finance
  datos <-getSymbols(simbolo, from=start, to=end, auto.assign = FALSE)
  #Eliminar faltantes
  datos <-na.omit(datos)
  #Mantener columnas con precios cierre de y volumenes; columnas 4 y 5
  datos <-datos[,4:5]
  #Para hacer los datos accesibles en el global enviroment
  assign(simbolo, datos, envir = .GlobalEnv)
}

#Llamamos la funcion para cada stock
  precios_volumenes("AMZN")
  precios_volumenes("NFLX")
  precios_volumenes("IBM")
  precios_volumenes("SPY")

#Juntamos los datos y renombramos las columnas
  PyV <-merge.xts(AMZN, NFLX, IBM, SPY)
  colnames(PyV) <-c("Amazon P.Cierre", "Amazon Vol.", "Netflix P.Cierre", "Netflix Vol.",
                    "IBM P.Cierre", "IBM Vol.", "SP500 P.Cierre", "SP500 Vol.")

#-------------------------------------------------------------------
#Serie de tiempo
#Podemos generar una grafica interactiva las variables, en este caso los precios
Precios <-dygraph(PyV[,c(1, 3, 5, 7)], main = "Precios de Amazon, Netflix, IBM Y SP&500") %>%
  dyAxis("y", label = "Precios") %>%
  dyRangeSelector(dateWindow = c("2014-01-01", "2024-01-01")) %>%
  dyOptions(colors = RColorBrewer::brewer.pal(4, "Set1"))
Precios

#Podemos ver los 5 ultimos datos redondeados hasta 3 decimales
round(tail(PyV, n=5), 3)

#-------------------------------------------------------------------

#Ahora un ejemplo de Panel Data, generamos una lista de objetos dygraphs, y para imprimirlos usamos htmtools
#El dyAxis para la grafica de "Volumen" fue escrito para que los numeros en la grafica fueran en millones
library(dygraphs)
library(htmltools)
dy_graficos <-list(
  dygraphs::dygraph(PyV[,c(1, 3, 5, 7)], main = "Precios de Amazon, Netflix, IBM Y SP&500"),
  dygraphs::dygraph(PyV[,c(2, 4, 6, 8)], main = "Volumenes de Amazon, Netflix, IBM y SP&500") %>%
    dyAxis("y", label = "Volumen",
           valueFormatter = "function(x) { return((x / 1000000).toFixed(2) + ' M'); }",
           axisLabelFormatter = "function(x) { return((x / 1000000).toFixed(0) + ' M'); }"
    )

)

#Representamos los objetos de dygraphs usando htmltools
htmltools::browsable(htmltools::tagList(dy_graficos))

#-------------------------------------------------------------------

#Ahora un ejemplo de Cross Sectional
#Seleccionaremos los datos de AMZN del 2014 y del 2023
#Empezamos seleccionando los años 2014 de AMZN que es la 1ra columna

AMZN_2014 <-subset(PyV[,1], index(PyV)>="2014-01-01"& index(PyV)<="2014-12-31")
AMZN_2014[c(1:5, nrow(AMZN_2014))]
#Para el año 2023
AMZN_2023 <-subset(PyV[,1], index(PyV)>="2023-01-01"& index(PyV)<="2023-12-31")
AMZN_2023[c(1:5, nrow(AMZN_2023))]

#Ahora para poder visualizarla elegimos un histograma
par(mfrow = c(2,1))

AMZN_2014_num <- as.numeric(AMZN_2014)
AMZN_2023_num <- as.numeric(AMZN_2023)

hist(AMZN_2014_num, freq = FALSE, col = "yellow", border = "blue", main = "Densidades de los precios AMZN en 2014", xlab = "Precios Cierre")
lines(density(AMZN_2014_num), lwd = 2, col = "red")
hist(AMZN_2023_num, freq = FALSE, col = "yellow", border = "blue", main = "Densidades de los precios AMZN en 2023", xlab = "Precios Cierre")
lines(density(AMZN_2023_num), lwd = 2, col = "red")

#-------------------------------------------------------------------
#Para confirmar que los datos sean correctos —claramente es necesario cambiar ciertos parametros— se puede hacer uso de lo siguiente
identical(
  AMZN_2014,
  subset(PyV[, "Amazon P.Cierre"], index(PyV) >= "2014-01-01" & index(PyV) <= "2014-12-31")
)