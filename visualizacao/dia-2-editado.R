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

escolaridade |>
  arrange(nome)


escolaridade_fct <- escolaridade |>
  mutate(
    escolaridade_concluida_fct = factor(
      escolaridade_concluida,
      levels = c("Sem instrução",
                 "Ensino Fundamental I",
                 "Ensino Fundamental II",
                 "Ensino Médio",
                 "Ensino Técnico",
                 "Graduação",
                 "Pós-graduação")
    )
  )

escolaridade_fct |> arrange(escolaridade_concluida_fct)

escolaridade_fct |>
  count(escolaridade_concluida_fct) |>
  ggplot() +
  geom_col(aes(y = n, x = escolaridade_concluida_fct))

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
dados_tri_recente |>
  mutate(uf_fct = fct_reorder(uf, perc_desocupacao)) |>
  ggplot()+
  aes(y = uf_fct, x = perc_desocupacao) +
  geom_col()





grafico_ordenado <- dados_tri_recente |> 
  mutate(uf_fct = fct_reorder(uf, perc_desocupacao)) |> 
  ggplot() + 
  aes(y = uf_fct, x = perc_desocupacao, fill = regiao) + 
  geom_col()

grafico_ordenado


## ------------------------------------------------------------------
grafico_com_labels <- grafico_ordenado + 
  labs(
    # fixas ---
    title = "Taxa de desocupação por estado", 
    subtitle = "Dados para o 2º trimestre 2024",  
    caption = "Fonte: Dados referentes à PNAD Contínua Trimestral, obtidos no SIDRA/IBGE.",  
    #tag = "A)",
    # relacionadas com os atributos esteticos - aes
    x = "Taxa de desocupação (%)",  
    y = "Estado", 
    fill = "Região"
  )

grafico_com_labels

#  patchwork --------
install.packages("patchwork")
library(patchwork)

(grafico_base + grafico_com_labels )+ 
  plot_annotation(title = 'The surprising story about mtcars', tag_levels = "A", tag_prefix = "Figura ")


## ------------------------------------------------------------------
dados_tri_recente |> 
  mutate(uf_fct = fct_reorder(uf, perc_desocupacao)) |>
  ggplot() +
  aes(y = uf_fct, x = perc_desocupacao) +
  geom_col(aes(fill = perc_desocupacao)) +
  scale_fill_viridis_c(direction = -1, option = "viridis", begin = 0, end = 0.9) 

# scale_color_....
# scale_fill_....


## ------------------------------------------------------------------
dados_tri_recente |> 
  ggplot() +
  aes(y = uf, x = perc_desocupacao) +
  geom_col(aes(fill = perc_desocupacao)) +
  scale_fill_viridis_c()

dados_tri_recente |> 
  ggplot() +
  aes(y = uf, x = perc_desocupacao) +
  geom_col(aes(fill = regiao)) +
  scale_fill_brewer(palette = "Set2")

## ------------------------------------------------------------------
dados |>
  filter(uf_sigla == "SP", ano >= 2019) |> 
  ggplot() +
  aes(x = trimestre_inicio, y = perc_desocupacao) +
  geom_line() +
  geom_point() +
  scale_x_date( 
    breaks = "6 months", 
    date_labels = "%b/%y", 
    minor_breaks = "6 months" 
  )  

?parse_date

dados |>
  filter(uf_sigla == "SP") |>
  mutate(ano_data = as.Date(paste0(ano, "-01-01"))) |> 
  ggplot( ) +
  aes(x = ano_data, y = perc_desocupacao) +
  geom_point()


## ------------------------------------------------------------------
dados |>
  filter(uf_sigla == "SP") |>
  ggplot() +
  aes(x = trimestre_inicio, y = perc_desocupacao) +
  geom_line() +
  geom_point() +
  scale_y_continuous(limits = c(0, 20), breaks = seq(0, 20, 1))


## ------------------------------------------------------------------
library(ggthemes)
grafico_com_labels + 
  theme_minimal()

grafico_com_labels + 
  theme_light()


grafico_com_labels +
  theme_tufte()

## ------------------------------------------------------------------
library(ggthemes)


## ------------------------------------------------------------------
grafico_com_labels + 
  ggthemes::theme_economist()


grafico_com_labels +
  theme_light(base_family = "times new roman") +
  theme(legend.position = "bottom",
        plot.title = element_text(colour = "red", size = 20, hjust = -1.8),
        plot.subtitle = element_text(
          hjust = -0.5
        ),
        axis.text.y = element_text(size = 10, angle = 0)
        
  )


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
  ) +
  theme(legend.position = "top")

grafico_customizado


## ------------------------------------------------------------------
fs::dir_create("graficos/")
ggsave( 
  filename = "graficos/grafico_customizado.png", 
  plot = grafico_customizado, 
  width = 15, 
  height = 15, 
  units = "cm",
  dpi = 900 
)

install.packages("svglite")
install.packages("systemfonts")
ggsave( 
  filename = "graficos/grafico_customizado.svg", 
  plot = grafico_customizado, 
  width = 15, 
  height = 15, 
  units = "cm",
  dpi = 900 
)


## ------------------------------------------------------------------
file.exists("graficos/grafico_customizado.png")

