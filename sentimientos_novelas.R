#DESCARGA Y CARGA DE LIBRERIAS NECESARIAS
if(!require(tidyverse)) install.packages("tidyverse", repos = "http://cran.us.r-project.org")
if(!require(gridExtra)) install.packages("gridExtra", repos = "http://cran.us.r-project.org")
if(!require(ggthemr)) install.packages("ggthemr", repos = "http://cran.us.r-project.org")
if(!require(readxl)) install.packages("readxl", repos = "http://cran.us.r-project.org")
if(!require(tidytext)) install.packages("tidytext", repos = "http://cran.us.r-project.org")
if(!require(openxlsx)) install.packages("openxlsx", repos = "http://cran.us.r-project.org")
if(!require(syuzhet)) install.packages("syuzhet", repos = "http://cran.us.r-project.org")
if(!require(wordcloud2)) install.packages("syuzhet", repos = "http://cran.us.r-project.org")
if(!require(gutenbergr)) install.packages("gutenbergr", repos = "http://cran.us.r-project.org")

library(tidyverse)
library(gridExtra)
library(ggthemr)
library(readxl)
library(tidytext)
library(openxlsx)
library(syuzhet)
library(wordcloud2)
library(gutenbergr)

ggthemr("dust")

#CARGA DE DON QUIJOTE
id_quijote <- gutenberg_metadata %>% #obtenemos el id de la novela
  filter(title == "Don Quijote") %>%
  pull(gutenberg_id)
don_quijote <- gutenberg_download(id_quijote, strip = TRUE) #strip quita cabeceras y pies de página. 

#OBTENEMOS UN IDENTIFICADOR PARA CADA FRASE Y ELIMINAMOS LA COLUMNA SOBRANTE
total_lineas <- nrow(don_quijote)
don_quijote <- don_quijote %>%
  mutate(id = seq(1,total_lineas,1)) %>%
  select(-gutenberg_id)

texto_tokenizado <-  don_quijote %>% unnest_tokens(Palabra,text)

#DESCARGAMOS Y CARGAMOS LEXICO AFINN Y MATCHEAMOS CON EL TEXTO TOKENIZADO
download.file("https://raw.githubusercontent.com/jboscomendoza/rpubs/master/sentimientos_afinn/lexico_afinn.en.es.csv",
              "lexico_afinn.en.es.csv")
afinn <- read.csv("lexico_afinn.en.es.csv", stringsAsFactors = F, fileEncoding = "latin1") %>% 
  as_tibble()
afinn <- afinn %>% 
  mutate(largo = nchar(Palabra)) %>%
  filter(largo > 3) 
afinn <- afinn[,c(1,2)]

data <- texto_tokenizado %>% inner_join(afinn, by = "Palabra")
remove(afinn)

#GRAFICAMOS LA PUNTUACION MEDIA POR FRASE CON SUAVIZACION.

evolucion <- data %>%
  group_by(id) %>%
  ggplot(aes(id, Puntuacion)) +
  geom_smooth(method = "loess",se = FALSE) +
  xlab("Frases") + 
  ylab("Puntuación suavizada (LOESS)") + 
  ggtitle("EVOLUCIÓN DEL SENTIMIENTO A LO LARGO DE LA TRAMA",
          subtitle = "Suavizado de la puntuación por frases de la trama")

ggsave("evolucion_sentimiento.jpeg", evolucion, device = "jpeg")

#GRAFICAMOS NUBE DE PALABRAS

nube_palabras <- texto_tokenizado[,2] %>%
  filter(nchar(texto_tokenizado$Palabra) > 3) %>%
  group_by(Palabra) %>%
  mutate(frecuencia = n()) %>%
  unique()

nube <- wordcloud2(nube_palabras, size=1.2)
saveWidget(nube,"nube_palabras.html",selfcontained = FALSE)