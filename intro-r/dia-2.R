## Carregar pacotes ------------------------------------------------------------
library(tidyverse)


## Importar dados --------------------------------------------------------------
# dados <- read_csv2("https://raw.githubusercontent.com/beatrizmilz/2025-07-fbcp/refs/heads/main/intro-r/dados/candidatos_vereador_com_votos.csv")

dados <- read_csv2("dados/candidatos_vereador_com_votos.csv")

View(dados)


## Conhecendo os dados ---------------------------------------------------------
nrow(dados)
ncol(dados)
colnames(dados)
head(dados)
glimpse(dados)


## Pipe -----------------------------------------------------------------------

dados |>
  glimpse()


## Select ----------------------------------------------------------------------
dados_selecionados <- dados |>
  select(NM_CANDIDATO, SG_PARTIDO, DS_SIT_TOT_TURNO, SOMA_QT_VOTOS_NOMINAIS_VALIDOS)

dados_selecionados

dados |>
  select(-DT_GERACAO, -HH_GERACAO)


## Arrange ---------------------------------------------------------------------
dados_selecionados |>
  arrange(SOMA_QT_VOTOS_NOMINAIS_VALIDOS)

dados_selecionados |>
  arrange(desc(SOMA_QT_VOTOS_NOMINAIS_VALIDOS))


## Filter ----------------------------------------------------------------------
dados |>
  filter(SG_PARTIDO == "REDE")

dados_vereadores_eleitos <- dados |>
  filter(DS_SIT_TOT_TURNO %in% c("ELEITO POR QP", "ELEITO POR MÉDIA"))

dados_vereadores_eleitos

dados_vereadores_eleitos |> 
  filter(SOMA_QT_VOTOS_NOMINAIS_VALIDOS >= 100000)


## Mutate ----------------------------------------------------------------------
# base_de_dados |>
#   mutate(nome_da_nova_coluna = o_que_queremos_que_seja_salvo_nela)

dados_vereadores_eleitos |>
  mutate(
    mil_votos_validos = round(SOMA_QT_VOTOS_NOMINAIS_VALIDOS/1000, 2)
  ) 


## Group by --------------------------------------------------------------------
dados |>
  group_by(SG_PARTIDO, NM_PARTIDO) 


## Summarise -------------------------------------------------------------------
dados_por_partido <- dados |>
  # agrupando por colunas com informações dos partidos
  group_by(SG_PARTIDO, NM_PARTIDO) |> 
  summarise(
    # contando o número de candidatos por grupo
    quantidade_candidatos = n(),  
    quantidade_eleitos = sum(DS_SIT_TOT_TURNO %in% c("ELEITO POR QP", "ELEITO POR MÉDIA"), na.rm = TRUE),  # contando o número de candidatos eleitos
    
    media_votos_por_cand = mean(SOMA_QT_VOTOS_NOMINAIS_VALIDOS, na.rm = TRUE),  # calculando a média de votos válidos
    mediana_votos_por_cand = median(SOMA_QT_VOTOS_NOMINAIS_VALIDOS, na.rm = TRUE),  # calculando a mediana de votos válidos
    soma_votos = sum(SOMA_QT_VOTOS_NOMINAIS_VALIDOS, na.rm = TRUE)  # somando os votos válidos
  ) |> 
  # removendo o agrupamento
  ungroup() |> 
  arrange(desc(quantidade_eleitos), desc(soma_votos))

dados_por_partido

# Checando o número de eleitos
sum(dados_por_partido$quantidade_eleitos)


## Count -----------------------------------------------------------------------
dados_vereadores_eleitos |>
  count(DS_GENERO) 

dados_vereadores_eleitos |>
  count(DS_GRAU_INSTRUCAO) 

dados_vereadores_eleitos |>
  count(DS_COR_RACA) 


## Salvar os dados -------------------------------------------------------------
write_csv(dados_por_partido,
          "dados/tab-dados_por_partido.csv")

writexl::write_xlsx(dados_por_partido,
                    "dados/tab-dados_por_partido.xlsx")

