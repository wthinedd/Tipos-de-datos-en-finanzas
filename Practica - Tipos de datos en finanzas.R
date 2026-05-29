library(dygraphs)
library(xts)
library(quantmod)
library(dplyr)

options(warn = -1)

#-------------------------------------------------------------------

start <-format(as.Date("2015-01-01"), "%Y-%m-%d")
end <-format(as.Date("2024-01-01"), "%Y-%m-%d")

precios_volumenes <-function(simbolo)
{
  datos <-getSymbols(simbolo, from=start, to=end, auto.assign = FALSE)
  datos <-na.omit(datos)
  datos <-datos[,5:6]
  assign(simbolo, datos, envir = .GlobalEnv)
}

precios_volumenes("IBM")
precios_volumenes("ORCL")
precios_volumenes("INTC")
precios_volumenes("MSFT")

PyV <-merge.xts(IBM, ORCL, INTC, MSFT)
colnames(PyV) <-c("IBM Vol.", "IBM P.Ajustado", "Oracle Vol.", "Oracle P.Ajustado",
                    "Intel Vol.", "Intel P.Ajustado", "Microsoft Vol.", "Microsoft P.Ajustado")

#-------------------------------------------------------------------

Precios <-dygraph(PyV[,c(2, 4, 6, 8)], main = "Precios de IBM, Oracle, Intel y Microsoft") %>%
  dyAxis("y", label = "Precios") %>%
  dyRangeSelector(dateWindow = c("2015-01-01", "2020-12-31")) %>%
  dyOptions(colors = RColorBrewer::brewer.pal(4, "Set1"))
Precios

round(tail(PyV, n=5), 3)

#-------------------------------------------------------------------

library(dygraphs)
library(htmltools)
dy_graficos <-list(
  dygraphs::dygraph(PyV[,c(2, 4, 6, 8)], main = "Precios de IBM, Oracle, Intel Y Microsoft"),
  dygraphs::dygraph(PyV[,c(1, 3, 5, 7)], main = "Volumenes de IBM, Oracle, Intel Y Microsoft") %>%
    dyAxis("y", label = "Volumen",
           valueFormatter = "function(x) { return((x / 1000000).toFixed(2) + ' M'); }",
           axisLabelFormatter = "function(x) { return((x / 1000000).toFixed(0) + ' M'); }"
    )
)

htmltools::browsable(htmltools::tagList(dy_graficos))

#-------------------------------------------------------------------

MSFT_2015 <-subset(PyV[,8], index(PyV)>="2015-01-01"& index(PyV)<="2015-12-31")
MSFT_2015[c(1:5, nrow(MSFT_2015))]
MSFT_2020 <-subset(PyV[,8], index(PyV)>="2020-01-01"& index(PyV)<="2020-12-31")
MSFT_2020[c(1:5, nrow(MSFT_2020))]

par(mfrow = c(2,1))

MSFT_2015_num <- as.numeric(MSFT_2015)
MSFT_2020_num <- as.numeric(MSFT_2020)

hist(MSFT_2015_num, freq = FALSE, col = "yellow", border = "blue", main = "Densidades de los precios MSFT en 2015", xlab = "Precios Ajustados")
lines(density(MSFT_2015_num), lwd = 2, col = "red")
hist(MSFT_2020_num, freq = FALSE, col = "yellow", border = "blue", main = "Densidades de los precios MSFT en 2020", xlab = "Precios Ajustados")
lines(density(MSFT_2020_num), lwd = 2, col = "red")

#-------------------------------------------------------------------

identical(
  MSFT_2015,
  subset(PyV[, "Microsoft P.Ajustado"], index(PyV) >= "2015-01-01" & index(PyV) <= "2015-12-31")
)