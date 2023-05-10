# telechargement de la table RP logement de 207
donnees_rp_lgt <- doremifasol::telechargerDonnees("RP_LOGEMENT", date = 2017, vars = c("COMMUNE", "IPONDL", "CATL","REGION"))

donnees_filosofi <- doremifasol::telechargerDonnees("FILOSOFI_DISP_COM_ENS", date = 2017)


# Labelisation
donnees_rp_lgt$CATL_Lab<-factor(donnees_rp_lgt$CATL,
            labels=c("Resid. principales","Lgt occ", "Resid. sec","Lgts vacants"))


donnees_rp_lgt$REGION_Lbl<-factor(donnees_rp_lgt$REGION,
              labels=c("Guadeloupe",	"Martinique",	"Guyane",	"La Réunion",	"Île-de-France",	"Centre-Val de Loire",	
                       "Bourgogne-Franche-Comté",	"Normandie",	"Hauts-de-France",	"Grand Est",	"Pays de la Loire",	
                       "Bretagne",	"Nouvelle-Aquitaine",	"Occitanie",	"Auvergne-Rhône-Alpes",	
                       "Provence-Alpes-Côte d'Azur",	"Corse"))
