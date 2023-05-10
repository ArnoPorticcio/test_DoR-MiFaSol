#https://github.com/InseeFrLab/DoReMIFaSol/blob/master/README.md


# telechargement de la table RP logement 2017 : https://www.insee.fr/fr/statistiques/4802056#consulter
donnees_rp_lgt <- doremifasol::telechargerDonnees("RP_LOGEMENT", date = 2017, vars = c("COMMUNE", "IPONDL", "CATL","REGION"))

# telechargement de la table Filosofi de 2017 : https://www.insee.fr/fr/statistiques/4291712
donnees_filo<- doremifasol::telechargerDonnees("FILOSOFI_DISP_COM_ENS", date = 2017)


# Labelisation
# db$sexe <- factor(db$sexe, levels = 1:2, labels = c("Homme", "Femme"))
# db$sexe <- ifelse(db$sexe == 1, "Homme", "Femme")

donnees_rp_lgt$CATL_lbl<-factor(donnees_rp_lgt$CATL, levels = 1:4, 
                            labels=c("Resid. princ","Lgt occ", "Resid. sec","Lgt vacants"))

donnees_rp_lgt$REGION_lbl<-factor(donnees_rp_lgt$REGION,
              labels=c("Guadeloupe",	"Martinique",	"Guyane",	"La Réunion",	"Île-de-France",	"Centre-Val de Loire",	
                       "Bourgogne-Franche-Comté",	"Normandie",	"Hauts-de-France",	"Grand Est",	"Pays de la Loire",	
                       "Bretagne",	"Nouvelle-Aquitaine",	"Occitanie",	"Auvergne-Rhône-Alpes",	
                       "Provence-Alpes-Côte d'Azur",	"Corse"))
