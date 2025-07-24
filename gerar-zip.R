materiais_vis <- c(
  "visualizacao/dia-1.R",
  "visualizacao/dia-2.R",
  "visualizacao/dados/sidra_4092_arrumado.rds",
  "visualizacao/visualizacao.Rproj"
)
zip::zip("visualizacao/material_visualizacao.zip", materiais_vis)


materiais_intro <- c(
  "intro-r/dia-1.R",
  "intro-r/dia-2.R",
  "intro-r/dados/candidatos_vereador_com_votos.csv",
  "intro-r/intro-r.Rproj"
)
zip::zip("intro-r/material_intro-r.zip", materiais_vis)
