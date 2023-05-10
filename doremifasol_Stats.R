#STATS

# Type de logement : Source RP
RP_Catl<-table(donnees_rp_lgt$REGION_Lbl,donnees_rp_lgt$CATL_Lab) # En volume
RP_Catl_prop<-100*prop.table(RP_Catl,1)
RP_Catl_prop_DF<-as.data.frame.matrix(RP_Catl_prop)

# Type de logement : Source Filosofi
FILO_Catl<-table(donnees_filo$REG

                 
head(donnees_filo)
                 
prop.table(test,1)


glimpse(donnees_rp_lgt)
class(donnees_rp_lgt$CATL)

        