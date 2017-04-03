library(dplyr)
library(readr)

NYvsACotton <- read_csv("NYvsACotton.csv", col_names = FALSE)

Athleta_Knits_AS <- read_csv("Spr 18 Athleta Assumptions.csv", col_names = FALSE)

ok <- complete.cases(Athleta_Knits_AS[,"X7"])
Athleta_Knits_AS <- Athleta_Knits_AS[ok, ]

complete_columns <- is.na(Athleta_Knits_AS[1,])
Athleta_Knits_AS <- Athleta_Knits_AS[, c(!complete_columns)]
