# Carregar pacote
library(tidyverse)

# Importar dados ------------------------------------------------------
# Dados baixados de https://dadosabertos.tse.jus.br/dataset/resultados-2024
votacao_candidato_munzona_2024_SP <- read_delim(
  "intro-r/dados/votacao_candidato_munzona_2024_SP.csv",
  delim = ";",
  escape_double = FALSE,
  locale = locale(encoding = "ISO-8859-1"),
  trim_ws = TRUE
)

# Filtrar dados para o município de São Paulo ----------------------
votacao_muni_sp <- votacao_candidato_munzona_2024_SP |> 
  filter(NM_MUNICIPIO == "SÃO PAULO") 

# Salvar dados ------------------------------------------------------
write_csv2(votacao_muni_sp, "intro-r/dados/votacao_muni_sp.csv")

votos_vereadores_muni_sp <- votacao_muni_sp |> 
  filter(DT_ELEICAO == "06/10/2024", DS_CARGO == "Vereador") |> 
  select(DS_ELEICAO, NM_MUNICIPIO,NR_ZONA, DS_CARGO, tidyselect::contains("CANDIDATO"),
                          tidyselect::contains("PARTIDO"), DS_SIT_TOT_TURNO, QT_VOTOS_NOMINAIS_VALIDOS) |> 
  group_by(DS_CARGO,SQ_CANDIDATO, NR_CANDIDATO, NM_CANDIDATO, NR_PARTIDO, SG_PARTIDO, NM_PARTIDO, DS_SIT_TOT_TURNO) |> 
  summarise(
    SOMA_QT_VOTOS_NOMINAIS_VALIDOS = sum(QT_VOTOS_NOMINAIS_VALIDOS, na.rm = TRUE),
    .groups = "drop"
  ) |> 
  arrange(desc(SOMA_QT_VOTOS_NOMINAIS_VALIDOS)) 

write_csv2(votos_vereadores_muni_sp, "intro-r/dados/votos_vereadores_muni_sp.csv")

# Dados sobre candidatos ---------------------------------------------
# Dados baixados de https://dadosabertos.tse.jus.br/dataset/candidatos-2024 

library(readr)
consulta_cand_2024_SP <- read_delim(
  "intro-r/dados/consulta_cand_2024_SP.csv",
  delim = ";",
  escape_double = FALSE,
  locale = locale(encoding = "ISO-8859-1"),
  trim_ws = TRUE
)

bem_candidato_2024_SP <- read_delim("intro-r/dados/bem_candidato_2024_SP.csv", 
    delim = ";", escape_double = FALSE, locale = locale(encoding = "ISO-8859-1"), 
    trim_ws = TRUE)

# Filtrar dados para o município de São Paulo ----------------------
candidatos_muni_sp <- consulta_cand_2024_SP |> 
  filter(DS_ELEICAO == "Eleições Municipais 2024", NM_UE == "SÃO PAULO") 


bens_candidatos_muni_sp <- bem_candidato_2024_SP |> 
  filter(DS_ELEICAO == "Eleições Municipais 2024", NM_UE == "SÃO PAULO") |> 
  mutate(VR_BEM_CANDIDATO = parse_number(VR_BEM_CANDIDATO, locale = locale(decimal_mark = ","))) 


# Salvar dados ------------------------------------------------------
write_csv2(candidatos_muni_sp, "intro-r/dados/candidatos_muni_sp.csv")
write_csv2(bens_candidatos_muni_sp, "intro-r/dados/bens_candidatos_muni_sp.csv")



