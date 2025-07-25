# Material em: https://beatrizmilz.github.io/2025-07-fbcp/visualizacao/dia-1.html
# Oficina: Introdução à elaboração de gráficos com ggplot2 e R
# Dia 1 - Conhecendo o ggplot2
# Pacotes necessários ----
install.packages("tidyverse")
install.packages("esquisse", dependencies =  TRUE)
install.packages("ggthemes") # opcional

## Carregar pacotes ------------------------------
library(tidyverse)

# Importação de dados ----------------------------
# Caso o arquivo não esteja na pasta "dados", descomente a linha abaixo e execute
# para fazer o download do arquivo.
# download.file(
#   url = "https://github.com/beatrizmilz/2025-07-fbcp/raw/refs/heads/main/visualizacao/dados/sidra_4092_arrumado.rds", 
#   destfile = "dados/sidra_4092_arrumado.rds", 
#   mode = "wb" 
#   )

# importando os dados
dados <- read_rds("dados/sidra_4092_arrumado.rds") 
glimpse(dados) 


## Filtrando ------------------------------------------------------
# Filtrando os dados para o trimestre mais recente
dados_tri_recente <- dados |>  
  filter(trimestre_inicio == max(trimestre_inicio)) 

# Conhecendo o ggplot2 -----------------------------------
dados_tri_recente |>  # %>%
  ggplot()

## ---------------------------------------------
dados_tri_recente |>
  ggplot() + 
  aes(x = perc_desocupacao, y = uf)


## ---------------------------------------------
dados_tri_recente |> 
  ggplot() + 
  aes(x = perc_desocupacao, y = uf) + 
  geom_col() 

## ---------------------------------------------
dados |>
  filter(uf_sigla == "SP") |>
  ggplot() +
  aes(x = trimestre_inicio, y = perc_desocupacao) +
  geom_point()

## ---------------------------------------------
dados |> 
  filter(uf_sigla == "SP") |> 
  ggplot() + 
  aes(x = trimestre_inicio, y = perc_desocupacao) + 
  geom_line()


dados |> 
  ggplot() + 
  aes(x = trimestre_inicio, y = perc_desocupacao) + 
  geom_line() # isso dá errado

## ---------------------------------------------
dados |> 
  ggplot() + 
  aes(x = trimestre_inicio, y = perc_desocupacao) + 
  geom_line(aes(group = uf))

## ---------------------------------------------
dados |> 
  filter(uf_sigla == "SP") |> 
  ggplot() + 
  aes(x = trimestre_inicio, y = perc_desocupacao) + 
  geom_line(color = "red") +
  geom_point(color = "blue")


## ---------------------------------------------
dados |> 
  filter(uf_sigla == "SP") |> 
  ggplot() + 
  aes(x = trimestre_inicio, y = perc_desocupacao) + 
  geom_point(color = "blue") +
  geom_line(color = "red")

## ---------------------------------------------
dados_tri_recente |> 
  ggplot() + 
  aes(y = uf, x = perc_desocupacao) + 
  geom_col()

## ---------------------------------------------
dados |> 
  filter(perc_desocupacao >= 20) |>
  ggplot() + 
  aes(x = uf) + 
  geom_bar()

dados |>
  filter(perc_desocupacao >= 20) |>
  count(uf) |>
  ggplot() +
  aes(x = uf, y = n) +
  geom_col()


## ---------------------------------------------
dados |> 
  ggplot() + 
  aes(x = perc_desocupacao) + 
  geom_histogram(bins = 30)

dados |> 
  ggplot() + 
  aes(x = perc_desocupacao) + 
  geom_histogram(binwidth = 1)

## ---------------------------------------------
dados |> 
  ggplot() + 
  aes(x = perc_desocupacao) + 
  geom_density()

## ---------------------------------------------
dados |> 
  ggplot() + 
  aes(x = perc_desocupacao) + 
  geom_boxplot()


dados |> 
  ggplot() + 
  aes(y = regiao, x = perc_desocupacao) + 
  geom_boxplot()

## ---------------------------------------------
dados_tri_recente |>
  ggplot() + 
  aes(x = perc_desocupacao, y = uf) + 
  geom_col(aes(fill = regiao)) 

dados_tri_recente |>
  ggplot() + 
  aes(x = perc_desocupacao, y = uf) + 
  geom_col(aes(color = regiao)) 

dados_tri_recente |>
  ggplot(aes(x = perc_desocupacao, y = uf)) +
  geom_col() +
  facet_wrap(~regiao, scales = "free_y")

dados_tri_recente |>
  ggplot() +
  aes(x = perc_desocupacao, y = uf) +
  geom_col(aes(fill = regiao)) +
  geom_label(aes(label = round(perc_desocupacao,1)))

## ---------------------------------------------
dados |> 
  filter(uf_sigla == "SP") |> 
  mutate(periodo_pandemia = as.character(periodo_pandemia)) |>
  ggplot() + 
  aes(x = trimestre_inicio, y = perc_desocupacao) + 
  geom_line() +
  geom_point(aes(color = periodo_pandemia)) 

## ---------------------------------------------
dados |> 
  filter(uf_sigla %in% c("SP", "PR", "PA")) |>
  ggplot() + 
  aes(x = trimestre_inicio, y = perc_desocupacao) + 
  geom_line(aes(group = uf)) + 
  facet_wrap(vars(uf), nrow = 1)

## ---------------------------------------------
dados |> 
  ggplot() + 
  aes(y = perc_desocupacao) + 
  geom_boxplot() + 
  facet_grid(regiao ~ periodo_pandemia) 


## Esquisse ------------------------------------------------------
library(esquisse)
esquisser(dados)




library(ggplot2)

grafico <- ggplot(dados) +
 aes(x = trimestre_inicio, y = perc_desocupacao, colour = regiao, group = uf) +
 geom_line(linewidth = 0.6) +
 scale_color_manual(values = c(`Centro Oeste` = "#7466C2", Nordeste = "#A89BB0", Norte = "#C6B18B", 
 Sudeste = "#00FF49", Sul = "red")) +
 labs(x = "Ano", y = "Percentual desocupacao", title = "Desocupacão ...", 
 caption = "Fonte: dados da pnud continua obtidos no SIDRA IBGE") +
 ggthemes::theme_fivethirtyeight() +
 theme(legend.position = "top") +
 facet_wrap(vars(regiao))


ggsave("grafico-desocupacao.png",
       grafico)
