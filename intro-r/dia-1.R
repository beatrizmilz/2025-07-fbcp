# Material em: https://beatrizmilz.github.io/2025-07-fbcp/intro-r/dia-1.html
# Oficina: Introdução ao R para análise de dados
# Dia 1 - Ambientação e conceitos básicos

# Isso é um Script :)
# Como executar códigos? Ctrl + Enter
# Comentários são criados adicionando um # antes 


## Funções ---------------------------------------------------------------------
# Consultar a data atual do sistema (computador)
Sys.Date()


# Calcular a raiz quadrada de 25
sqrt(25)

# Argumentos de funções 
pi


# Sem argumentos: arredondar o número pi para um número inteiro
# (0 casas decimais)
round(pi)
# Com argumentos: arredondar o número pi para 2 casas decimais
round(pi, digits = 2)


## Pacotes -----------------------------------------------------------
# Instalar o pacote tidyverse
# importante: sempre com aspas no nome do pacote
install.packages("tidyverse")

# Carregar o pacote tidyverse
# não precisa de aspas
library(tidyverse) 


## Documentação ----------------------------------------------------------------
# # Abrir a documentação da função mean()
help(mean)
?mean
# # Buscar por funções que contenham o termo "mean"
??mean


## Operações matemáticas -------------------------------------------------------
1 + 1 # Soma
1 - 1 # Subtração
2 * 3 # Multiplicação
10 / 2 # Divisão
2 ^ 3 # Potenciação

2 + 3 * 4


## Objetos ---------------------------------------------------------------------
# Alguns objetos já estão disponíveis no R
letters
pi


# Atenção: case sensitive - o R diferencia letras maiúsculas e minúsculas
# é esperado que ao rodar a linha abaixo, você encontre um erro
Pi
# Error: object 'Pi' not found

# Criando objetos: com a atribuição <-
nome_da_universidade <- "Universidade de São Paulo"

# para ver o que tem guardado em um objeto, execute o nome do objeto:
nome_da_universidade

# Cuidado, o objeto só é alterado quando usamos a atribuição 
tolower(nome_da_universidade)

nome_da_universidade

nome_da_universidade <- tolower(nome_da_universidade)

nome_da_universidade


## Tipos de objetos ------------------------------------------------------------

### Vetores ----------

vetor_de_numeros <- c(1, 2, 3, 4, 5)

vetor_misto <- c(1, 2, "três", 4, 5)
class(vetor_misto)
vetor_misto


### Data frames -----
View(airquality)
head(airquality)

