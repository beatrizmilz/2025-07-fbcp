# Passo a passo feito em:
# https://ipeadata-lab.github.io/curso_r_intro_202409/03_importacao.html
# https://ipeadata-lab.github.io/curso_r_intro_202409/05_transformacao.html
# install.packages("sidrar")
info_4092 <- sidrar::info_sidra("4092")

periodos_disponiveis <- stringr::str_split(info_4092$period, ", ")[[1]]

dados_brutos_4092 <- sidrar::get_sidra(x = 4092, period = periodos_disponiveis, geo = "State")

dados_renomeados <- janitor::clean_names(dados_brutos_4092)

dados_filtrados <- dados_renomeados |>
  filter(variavel == "Pessoas de 14 anos ou mais de idade")

dados_selecionados <-
  dados_filtrados |>
  select(
    # colunas que queremos manter
    unidade_da_federacao,
    unidade_da_federacao_codigo,
    trimestre,
    trimestre_codigo,
    condicao_em_relacao_a_forca_de_trabalho_e_condicao_de_ocupacao,
    valor
  )

dados_renomeados_2 <- dados_selecionados |>
  rename(
    # colunas que queremos renomear: novo_nome = nome_atual
    condicao = condicao_em_relacao_a_forca_de_trabalho_e_condicao_de_ocupacao,
    valor_mil_pessoas = valor,
    uf = unidade_da_federacao,
    uf_codigo = unidade_da_federacao_codigo
  )

dados_largos <- dados_renomeados_2 |>
  tidyr::pivot_wider(names_from = condicao,
                     values_from = valor_mil_pessoas,
                     names_prefix = "mil_pessoas_")
dados_largos_renomeados <- janitor::clean_names(dados_largos)


dados_tipo <- dados_largos_renomeados |>
  mutate(
    # nova variável:
    # nome_da_coluna = o que queremos calcular
    uf_codigo = as.factor(uf_codigo)
  )

dados_com_proporcao <- dados_tipo |>
  mutate(
    prop_desocupacao = mil_pessoas_forca_de_trabalho_desocupada / mil_pessoas_forca_de_trabalho,
    perc_desocupacao = prop_desocupacao * 100
  )


dados_com_trimestre <- dados_com_proporcao |>
  mutate(
    ano = stringr::str_sub(trimestre_codigo, 1, 4),
    ano = as.numeric(ano),
    trimestre_numero = stringr::str_sub(trimestre_codigo, 5, 6),
    trimestre_numero = as.numeric(trimestre_numero),
    trimestre_mes_inicio = case_when(
      trimestre_numero == 1 ~ 1,
      trimestre_numero == 2 ~ 4,
      trimestre_numero == 3 ~ 7,
      trimestre_numero == 4 ~ 10
    ),
    trimestre_inicio = paste0(ano, "-", trimestre_mes_inicio, "-01"),
    trimestre_inicio = as.Date(trimestre_inicio),
    .after = trimestre_codigo
  ) |>
  
  select(-trimestre_mes_inicio, -trimestre_numero)


dados_com_dummy <- dados_com_trimestre |>
  mutate(periodo_pandemia = case_when(
    trimestre_codigo %in% c(
      "202001",
      "202002",
      "202003",
      "202004",
      "202101",
      "202102",
      "202103",
      "202104",
      "202201"
    ) ~ 1,
    
    .default = 0
  ))

dados_ordenados <- dados_com_dummy |>
  arrange(
    # colunas que queremos usar ordenar
    trimestre_codigo,
    desc(prop_desocupacao)
  )

uf_regiao <- readr::read_csv(
  "https://raw.githubusercontent.com/ipeadata-lab/curso_r_intro_202409/refs/heads/main/dados/uf_regiao.csv"
)

uf_regiao_fct <- uf_regiao |>
  mutate(uf_codigo = as.factor(uf_codigo))

dados_com_regiao <- dados_ordenados |>
  left_join(uf_regiao_fct, by = "uf_codigo") |>
  relocate(uf_sigla, regiao, .after = uf_codigo)

readr::write_rds(dados_com_regiao,
                 "visualizacao/dados/sidra_4092_arrumado.rds")
