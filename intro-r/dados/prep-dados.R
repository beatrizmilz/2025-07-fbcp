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



