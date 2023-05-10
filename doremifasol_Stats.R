test<-table(donnees_rp_lgt$REGION,donnees_rp_lgt$CATL)
test_lbl<-table(donnees_rp_lgt$REGION_Lbl,donnees_rp_lgt$CATL_Lab)



prop.table(test,1)


glimpse(donnees_rp_lgt)
class(donnees_rp_lgt$CATL)

        