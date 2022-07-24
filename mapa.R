library(coronabr)
library(dplyr)
library(brazilmaps) #usar remotes::install_github("rpradosiqueira/brazilmaps")
library(sf)
library(tmap)
library(htmlwidgets)


dados <- get_corona_br(by_uf = TRUE)

#at <- format_corona_br(dados)

# Pegando a data mais recente com os dados completos
# pode ser a data máxima, ou anterior à máxima
datas <- plyr::count(dados$date[dados$last_available_confirmed > 0 
                                & !is.na(dados$state)])
datas$lag <- datas$freq - dplyr::lag(datas$freq)
if (datas$lag[which.max(datas$x)] < 0) {
  data_max <- max(datas$x, na.rm = TRUE) - 1
} else {
  data_max <- max(datas$x, na.rm = TRUE)
}

# proporcao de casos por 100k
dados_format <- dados %>%
  # renomeia colunas e arredonda casos
  mutate(`Casos (por 100 mil hab.)` = round(last_available_confirmed_per_100k_inhabitants),
         State = city_ibge_code) %>%
  # filtra para ultima data
  filter(date == data_max) 
# carregando shapefile br
br <- brazilmaps::get_brmap(geo = "State",
                            class = "sf")
# fazendo o merge dos dados e shapefile
br_sf <- sf::st_as_sf(br) %>%
  merge(dados_format, by = "State") %>% 
  dplyr::relocate(nome)

# mapa
mapa <- tm_shape(br_sf) +
  #tm_fill() +
  tm_borders() +
  tm_symbols(size = "Casos (por 100 mil hab.)",
             col = "red",
             border.col = "red",
             scale = 2,
             alpha = 0.5)

mapa + tm_fill(alpha = .7)

tmap_mode("view")

mapa

