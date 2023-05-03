# Partie parquet : importation de la table individu RP 2019 complementaire

# Packages necessaires : a faire 1 fois
install.packages("remotes")

options(download.file.method = "libcurl")
remotes::install_gitlab("espace-charges-etudes/utilrp@charge_rp",
                        host = "gitlab.insee.fr")

# Installation du package parquet depuis la branche ####

library(utilrp)
library(dplyr) # pour les tests

#Emplacement de sortie des bases
sortie_rp <- "V:/DR20-SED/GIT Arno/parquet"
sortie_rp_met <- "V:/DR20-SED/GIT Arno/base_met"

utilRP::parquetize_rp(
  annee               = 2019,
  # AnnÃ©e du recensement
  cube                = "individu",
  # cube individu, famille ou menage
  emprise_geo         =  c("MET", "DOM"),
  # Liste des rÃ©gions selon dÃ©coupage GEN (MET, META, METB, METC, SPM, DOM, COM)
  # MET : MÃ©tropole
  # META : RÃ©gions 11, 32 et 44 (expl. principale uniquement)
  # METB : RÃ©gions 24, 28, 52, 53, 75 (expl. principale uniquement)
  # METC : RÃ©gions 27, 76, 84, 93, 94 (expl. principale uniquement)
  # SPM : Saint-Pierre-et-Miquelon
  # DOM : DÃ©partements d'outre-mer
  # COM : CollectivitÃ©s d'outre-mer
  expl_complementaire = TRUE,
  # Choix de l'exploitation complÃ©mentaire (TRUE)
  # ou principale (FALSE)
  variables_rp        = c("COMMUNE_RESID", "COMMUNE_TRAV", "COMMUNE_RESIDANTER",
                          "LTEC", "MODTRANS", "SEXE", "AGER8", "REG16_RESID",
                          "REG16_TRAV", "CATPC", "CS1", "TP", "EMPL_COMPL",
                          "MOCO", "DIPL", "NAT"),
  # SÃ©lection des variables d'intÃ©rÃªt du recensement
  # Par dÃ©faut "all" pour toutes les variables
  partitionnement     = c("REG16_RESID"),
  # Variable de partitionnement du fichier parquet
  # Part dÃ©faut NULL (non partitionnÃ©)
  # ici REG16_RESID on aura les tables de sortie par rÃ©gion
  sortie_parquet      = sortie_rp
  # RÃ©pertoire de sortie du ou des fichiers parquet
)

utilRP::parquetize_rp(
  annee               = 2019,
  # AnnÃ©e du recensement
  cube                = "individu",
  # cube individu, famille ou menage
  emprise_geo         =  c("MET", "DOM"),
  # Liste des rÃ©gions selon dÃ©coupage GEN (MET, META, METB, METC, SPM, DOM, COM)
  # MET : MÃ©tropole
  # META : RÃ©gions 11, 32 et 44 (expl. principale uniquement)
  # METB : RÃ©gions 24, 28, 52, 53, 75 (expl. principale uniquement)
  # METC : RÃ©gions 27, 76, 84, 93, 94 (expl. principale uniquement)
  # SPM : Saint-Pierre-et-Miquelon
  # DOM : DÃ©partements d'outre-mer
  # COM : CollectivitÃ©s d'outre-mer
  expl_complementaire = TRUE,
  # Choix de l'exploitation complÃ©mentaire (TRUE)
  # ou principale (FALSE)
  variables_rp        = c("COMMUNE_RESID", "COMMUNE_TRAV", "COMMUNE_RESIDANTER",
                          "LTEC", "MODTRANS", "SEXE", "AGER8", "REG16_RESID",
                          "REG16_TRAV", "CATPC", "CS1", "TP", "EMPL_COMPL",
                          "MOCO", "DIPL", "NAT"),
  # SÃ©lection des variables d'intÃ©rÃªt du recensement
  # Par dÃ©faut "all" pour toutes les variables
  
  sortie_parquet      = sortie_rp_met
  # RÃ©pertoire de sortie du ou des fichiers parquet
)

# Partie test OK

#install.packages("arrow")
#library(arrow)
#read_parquet("myfile.parquet")



individu <- arrow::open_dataset(sortie_rp)
head(individu)

individu %>%
  group_by(REG16_RESID) %>%
  summarise(compte = sum(IPONDI, na.rm = TRUE)) %>%
  collect()

# Test des tableaux
install.packages("tab")
install.packages("knitr")
install.packages("nycflights13")
library(knitr)
library(tab)
library(nycflights13)

data<-flights %>% filter(dest %in% unique(flights$dest)[1:3] & month < 7) %>% mutate(quarter = (month-1) %/% 3, poids=1)
res <- data %>%
  tab_build(cols = "month",
            rows = c("origin", "dest"),
            varstat = "dep_delay",
            stat = "max",
            varw = NULL) %>%
  tab_round(n = 0,
            guarantee_100 = FALSE)

stats_by_groups <- function(data, columns, varstat, FUN, ...) {
  
  if(!is.null(columns)){
    res <- data %>%
      group_by(pick({{columns}})) %>%
      summarise(across(varstat, function(x) FUN(x, ...)), .groups = "drop") %>%
      rename(calc = varstat)
  } else {
    res <- NULL
  }
  
  return(res)
  
}

# x <- flights %>%
#   filter(dest %in% unique(flights$dest)[1:3] & month < 4)
# columns <- c("origin", "dest", "month")
# varstat <- "dep_delay"
# FUN <- mean
# stats_by_groups(x, columns, varstat, FUN)



tab_core <- function(x,
                     cols,
                     rows,
                     stat = c("sum", "mean", "median", "min", "max", "weighted_mean", "col_pct", "row_pct"),
                     varstat,
                     varw){
  
  # TODO : gestion d'erreurs, je ne sais pas bien faire
  # Erreur si x ne contient pas cols, rows, varstat et varw (si renseign?)
  # Erreur si varstat n'est pas dans la liste finie
  # Erreur si useNA n'est pas dans la liste finie
  # Erreur si incoh?rence : par exemple col_pct et pas de rows, count et varstat renseign? (inop?rant), etc
  # transformation cols et rows en factors si pas le cas ?
  
  # TODO weighted_mean non cod?
  
  # col_pct et row_pct : sera g?r? dans tab_build
  # pour tab_core et tab_margins on calcule les sommes
  stat_ <- ifelse(stat %in% c("col_pct", "row_pct"), "sum", stat)
  
  # ---------------------------
  # core : "coeur" du tableau
  
  core <- stats_by_groups(x,
                          columns = c(cols, rows),
                          varstat = varstat,
                          # FUN = eval(stat),
                          FUN = match.fun(stat_),
                          # autre solution : switch en amont
                          na.rm = TRUE)
  
  # retourne un objet de type tab qui contient toutes les informations
  tab <- structure(list(core = core, # la nouveaut? de cette fonction
                        margins = NULL,
                        total = NULL,
                        secret_positions = NULL,
                        custom_options = NULL,
                        cols = cols,
                        rows = rows,
                        stat = stat,
                        varstat = varstat,
                        x = x),
                   class = "tab")
  
  return(tab)
  
}



tab_margins <- function(tab){
  
  # Parti pris : on calcule les marges des premi?res variables des listes rows et cols
  
  # Initialisation de l'objet qui sera renvoy? ? la fin
  tab_ <- tab
  
  # col_pct et row_pct : sera g?r? dans tab_build
  # pour tab_core et tab_margins on calcule les sommes
  stat_ <- ifelse(tab$stat %in% c("col_pct", "row_pct"), "sum", tab$stat)
  
  # On d?coupe ce qu'il faut calculer en 8 s?ries
  
  # S?rie 1 : total
  # print("1")
  m1 <- tab$x %>%
    summarise_at(tab$varstat, match.fun(stat_), na.rm = TRUE) %>%
    ungroup() %>%
    rename(calc = tab$varstat)
  
  # print("2")
  # S?rie 2 : cols
  m2 <- stats_by_groups(tab$x, tab$cols, tab$varstat, match.fun(stat_), na.rm = TRUE)
  
  # S?rie 3 : rows
  m3 <- stats_by_groups(tab$x, tab$rows, tab$varstat, match.fun(stat_), na.rm = TRUE)
  
  # S?rie 4 : cols[1]
  m4 <- stats_by_groups(tab$x, c(tab$cols, tab$rows), tab$varstat, match.fun(stat_), na.rm = TRUE)
  
  # S?rie 5 : rows[1]
  m5 <- stats_by_groups(tab$x, tab$rows[1], tab$varstat, match.fun(stat_), na.rm = TRUE)
  
  # print("6")
  # S?rie 6 : cols[1] * rows[1]
  m6 <- stats_by_groups(tab$x, c(tab$rows[1], tab$cols[1]), tab$varstat, match.fun(stat_), na.rm = TRUE)
  
  # S?rie 7 : cols * rows[1]
  m7 <- stats_by_groups(tab$x, c(tab$cols, tab$rows[1]), tab$varstat, match.fun(stat_), na.rm = TRUE)
  
  # S?rie 8 : rows * cols[1]
  m8 <- stats_by_groups(tab$x, c(tab$rows, tab$cols[1]), tab$varstat, match.fun(stat_), na.rm = TRUE)
  
  # On actualise uniquement l'?l?ment "margins" de l'objet tab
  tab_$margins <- m1 %>%
    bind_rows(m2) %>%
    bind_rows(m3) %>%
    bind_rows(m4) %>%
    bind_rows(m5) %>%
    bind_rows(m6) %>%
    bind_rows(m7) %>%
    bind_rows(m8) %>%
    distinct()
  
  return(tab_)
  
}


tab_round <- function(tab,
                      n,
                      guarantee_100 = FALSE){
  
  tab_ <- tab %>%
    tab_round_interm(n)
  
  if (guarantee_100){
    tab_ <- tab_ %>%
      tab_guarantee(n)
  }
  
  return(tab_)
}


#' tab_round_interm
#'
#' @param tab objet issu de tab_build
#' @param n -2 si arrondi ? la centaine, -1 si arrondi ? la dizaine, 0, 1, etc ...
#'
#' @return tab
#'
tab_round_interm <- function(tab,
                             n){
  
  tab_ <- tab
  
  # Arrondi
  if (n >= 0) {# on arrondit avec un certain nombre de d?cimales
    tab_$core <- tab_$core %>%
      mutate_at("calc", ~ round(., n))
    if(!is.null(tab_$margins)){
      tab_$margins <- tab_$margins %>%
        mutate_at("calc", ~ round(., n))
    }
    
  } else { # on arrondit ? la dizaine, ? la centaine, etc
    zeros <- 10^(-n)
    tab_$core <- tab_$core %>%
      mutate_at("calc", ~ zeros * round(. / zeros))
    if(!is.null(tab_$margins)){
      tab_$margins <- tab_$margins %>%
        mutate_at("calc", ~ zeros * round(. / zeros))
    }
  }
  
  return(tab_)
}


#' tab_guarantee
#'
#' @param tab objet issu de tab_build
#' @param n n -2 si arrondi ? la centaine, -1 si arrondi ? la dizaine, 0, 1, etc ...
#'
#' @return tab
#'
#' @examples
tab_guarantee <- function(tab,
                          n){
  
  tab_ <- tab
  # tab_$margins <- NULL # on fait comme s'il n'y avait pas de marges
  #
  # # Parti-pris : on choisit le(s) chiffre(s) ? modifier au niveau le plus d?sagr?g? possible (core), puis on adapte les marges
  # tab_raw <- as.numeric(print(tab_)[, (length(tab$rows) + 1) : ncol(tab_raw)])
  #
  # if (tab$stat == "col_pct"){
  #   for (i in (length(tab$rows) + 1) : ncol(tab_raw)){
  #     colonne <- as.numeric(tab_raw[[i]])
  #     tab_raw[[i]] <- guarantee_sum100(colonne, n, TRUE)
  #   }
  # } else if (tab$stat == "row_pct"){
  #   for (j in 1 : nrow(tab_raw)){
  #     # print(j)
  #     ligne <- as.numeric(tab_raw[j, (length(tab$rows) + 1) : ncol(tab_raw)])
  #     tab_raw[j, (length(tab$rows) + 1) : ncol(tab_raw)] <- guarantee_sum100(ligne, n, TRUE)
  #   }
  # }
  #
  # # TODO : pivot inverse pour remettre core ? la bonne forme + adapter les marges, pour l'instant on ne fait rien
  #
  # tab_$margins <- tab$margins # on remet les marges comme au d?part
  
  return(tab_)
}




tab_build <- function(x,
                      rows,
                      cols,
                      stat = c("sum", "mean", "median", "weighted_mean", "min", "max", "col_pct", "row_pct"),
                      varstat,
                      varw){
  
  if(!stat %in% c("col_pct", "row_pct")){
    tab <- x %>%
      tab_core(cols = cols,
               rows = rows,
               stat = stat,
               varstat = varstat,
               varw = varw) %>%
      tab_margins()
  } else {
    # On doit calculer un %age ligne ou colonne : on g?re le calcul du num?rateur puis du d?nominateur par la fonction sum et on fait la division
    
    if (stat == "col_pct"){
      var_ <- cols
    } else if (stat == "row_pct"){
      var_ <- rows
    }
    
    tab <- x %>%
      tab_core(cols = cols,
               rows = rows,
               stat = "sum",
               varstat = varstat,
               varw = varw) %>%
      tab_margins()
    
    denom <- x %>%
      tab_core(cols = var_,
               rows = NULL,
               stat = "sum",
               varstat = varstat,
               varw = varw) %>%
      tab_margins()
    
    tab$core <- tab$core %>%
      left_join(denom$core, by = var_) %>%
      mutate(calc = 100 * calc.x / calc.y) %>%
      select(-calc.x, -calc.y)
    
    tab$margins <- tab$margins %>%
      left_join(denom$margins, by = var_) %>%
      mutate(calc = 100 * calc.x / calc.y) %>%
      select(-calc.x, -calc.y)
    
    tab$stat <- stat
    
  }
  
  return(tab)
  
}



