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
