# Material em: https://beatrizmilz.github.io/2025-07-fbcp/visualizacao/dia-1.html
# Oficina: Introdução à elaboração de gráficos com ggplot2 e R
# Dia 2 - Customizando gráficos com ggplot2
## Carregar pacotes ------------------------------
library(tidyverse)


## Importação de dados ----------------------------
dados <- read_rds("dados/sidra_4092_arrumado.rds") 
glimpse(dados) 

# Filtrando dados -----------------------
dados_tri_recente <- dados |>  
  filter(trimestre_inicio == max(trimestre_inicio)) 

# Customizando gráficos --------------------------------------------

## ------------------------------------------------------------------
grafico_base <- dados_tri_recente |> 
  ggplot() + 
  aes(y = uf, x = perc_desocupacao) + 
  geom_col()

grafico_base


## ------------------------------------------------------------------
escolaridade <- tibble(
  nome = c(
    "Maria",
    "João",
    "Pedro",
    "Ana",
    "José",
    "Carlos",
    "Mariana",
    "Lucas"
  ),
  escolaridade_concluida = c(
    "Pós-graduação",
    "Ensino Médio",
    "Ensino Fundamental II",
    "Ensino Fundamental I",
    "Ensino Fundamental I",
    "Sem instrução",
    "Ensino Técnico",
    "Graduação"
  )
)


## ------------------------------------------------------------------
escolaridade |> 
  arrange(escolaridade_concluida)


## ------------------------------------------------------------------
escolaridade |>
  mutate(
  escolaridade_concluida_fct = factor( 
    escolaridade_concluida, 
    levels = c( 
      "Sem instrução", 
      "Ensino Fundamental I", 
      "Ensino Fundamental II", 
      "Ensino Médio", 
      "Ensino Técnico", 
      "Graduação", 
      "Pós-graduação" 
      ) 
    ) 
  ) |> 
  arrange(escolaridade_concluida_fct) 


## ------------------------------------------------------------------

grafico_ordenado <- dados_tri_recente |> 
  mutate(uf_fct = fct_reorder(uf, perc_desocupacao)) |> 
  ggplot() + 
  aes(y = uf_fct, x = perc_desocupacao) + 
  geom_col()

grafico_ordenado


## ------------------------------------------------------------------
grafico_com_labels <- grafico_ordenado + 
  labs(
    title = "Taxa de desocupação por estado", 
    subtitle = "Dados para o 2º trimestre 2024",  
    caption = "Fonte: Dados referentes à PNAD Contínua Trimestral, obtidos no SIDRA/IBGE.",  
    x = "Taxa de desocupação (%)",  
    y = "Estado", 
  )

grafico_com_labels



## ------------------------------------------------------------------
dados_tri_recente |> 
  ggplot() +
  aes(y = uf, x = perc_desocupacao) +
  geom_col(aes(fill = regiao)) +
  scale_fill_viridis_d() 


## ------------------------------------------------------------------
dados_tri_recente |> 
  ggplot() +
  aes(y = uf, x = perc_desocupacao) +
  geom_col(aes(fill = perc_desocupacao)) +
  scale_fill_viridis_c()

## ------------------------------------------------------------------
dados |>
  filter(uf_sigla == "SP", ano >= 2019) |> 
  ggplot() +
  aes(x = trimestre_inicio, y = perc_desocupacao) +
  geom_line() +
  geom_point() +
  scale_x_date( 
    breaks = "6 months", 
    date_labels = "%m/%Y", 
    minor_breaks = "1 months" 
  )  


## ------------------------------------------------------------------
dados |>
  filter(uf_sigla == "SP", ano >= 2019) |>
  ggplot() +
  aes(x = trimestre_inicio, y = perc_desocupacao) +
  geom_line() +
  geom_point() +
  scale_y_continuous(limits = c(0, 20))


## ------------------------------------------------------------------
grafico_com_labels + 
  theme_minimal()

## ------------------------------------------------------------------
library(ggthemes)


## ------------------------------------------------------------------
grafico_com_labels + 
  ggthemes::theme_economist()


## ------------------------------------------------------------------
grafico_customizado <- dados |> 
  filter(regiao == "Sudeste") |> 
  ggplot() + 
  aes(x = trimestre_inicio, y = perc_desocupacao, color = uf) +  
  geom_line() + 
  theme_light() + 
  scale_color_viridis_d(end = 0.9) + 
  scale_x_date(breaks = "1 year", date_labels = "%Y") + 
  labs( 
    title = "Taxa de desocupação por estado na região Sudeste",
    subtitle = "Dados da PNAD Contínua Trimestral",
    caption = "Fonte dos dados: SIDRA/IBGE.",
    color = "Estado",
    x = "Ano",
    y = "Taxa de desocupação (%)"
  ) 

grafico_customizado


## ------------------------------------------------------------------
fs::dir_create("graficos/")
ggsave( 
  filename = "graficos/grafico_customizado.png", 
  plot = grafico_customizado, 
  width = 7, 
  height = 5, 
  dpi = 300 
)


## ------------------------------------------------------------------
file.exists("graficos/grafico_customizado.png")

