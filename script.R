#######################################################################################  
#                                 L'employabilité                                     #
#                                 chez les etudiants                                  #
#                                     de ENSAK                                        #
#######################################################################################            

#########################                    Effectué Par                     #######################     
################################################     #################################################     
#Noureddine EL FATIMI                                                        
#Mohamed El Ghali LAHLOUH
#Rayane EL OUARRAT                                                                    
#Houssam EL ASRI
################################################     #################################################     




########################################## PROBLEMATIQUE #########################################################



#1.1 :  Questions de  de recherche:
######Quels sont les critères les plus recherchés par les employeurs dans le domaine spécifique des études offertes par l'ENSAK ?
######Quels sont les obstacles rencontrés par les diplômés dans leur recherche d'emploi et leur intégration sur le marché du travail ?


#1.2 :  Population : les étudiants de l'ENSA de KEnitra 


#1.3 : Definition de données: (Dictionnaire de donnees)

#Les caracteristiques de la population :  
# - Age (Numerique -> variable quantitative)
# - Genre(character -> Variable qualitative nominale : H=Homme , F=Femme)
# - Filière(character -> Variable qualitative categorielle)
# - Annee d'étude(character -> Variable qualitative)


#1.4 : Défintion des principales hypothèses
#H1 : "Les compétences essentielles et supplémentaires peuvent influencer l'employabilité"
#H2 : "Une éducation universitaire bien adaptée aux besoins du marché du travail améliore l'employabilité des étudiants en ingénierie"
#H3 : "Un réseau professionnel bien établi peut influencer les opportunités d'emploi et de carrière"



#####################################   COLLECTE DES DONNEES  #####################################################



#importation des donées 
library(readxl)
data <- read_excel("C:/Users/info/Downloads/Fichier Excel pour le projet .xlsx")
View(data)
class(data)



#####################################   PRETRAITEMENT  ############################################################

#---------------------------------------------------------------------
#3.1: Conversion :

#######Conversion des composantes des items

names(data)[7]="item1"
names(data)[8]="item2"
names(data)[9]="item3"
names(data)[10]="item4"
names(data)[11]="item5"
names(data)[12]="item6"
names(data)[13]="item7"
names(data)[14]="item8"
names(data)[15]="item9"
names(data)[16]="item10"
names(data)[17]="item11"
names(data)[18]="item12"
names(data)[19]="item13"
names(data)[20]="item14"
names(data)[21]="item15"
names(data)[22]="item16"
names(data)[23]="item17"
names(data)[24]="item18"
names(data)[25]="item19"
names(data)[26]="item20"
names(data)[27]="item21"
names(data)[28]="item22"
names(data)[29]="item23"
names(data)[30]="item24"
names(data)[31]="item25"
names(data)[32]="item26"

#Verification de la conversation
View(data)



######Conversion de la variable Genre
typeof(data$Gender)

if(is.character(data$Gender))
{
  for(i in 1:length(data$Gender))
  {
    if(data$Gender[i]=="Male")
    {
      data$Gender[i]="H"
    }else{
      data$Gender[i]="F"
    }
  }
  data$Gender<-as.factor(data$Gender)
}

# Créaton d'un graphe circulaire pour la répartition des deux genres
library(ggplot2)
ggplot(data, aes(x = Gender, fill = Gender)) +
  geom_bar() +
  scale_fill_manual(values = c("H" = "cyan", "F" = "magenta")) +
  labs(x = "Gender", y = "Frequency", title = "Distribution of Gender") +
  theme_minimal()




####Conversion de la variable Age

for(i in 1:length(data$Age)){
  if(data$Age[i]=='Valeur nul'){
    data$Age[i]="0"
  }
}

typeof(data$Age)
if(is.character(data$Age))
{
  data$Age<-as.numeric(data$Age)
}

#A noter qu'on va consacrer à l'étude de cette variable 
#plus tard (problèmes des valeurs particulières)




####Conversion de la variable `Engineering Field` en facteur si elle est de type caractère
if(is.character(data$`Engineering Field`)){
  data$`Engineering Field` <- as.factor(data$`Engineering Field`)
}


# Création d'un graphe montrant la répartition des filières
ggplot(data, aes(x = "", fill = `Engineering Field`)) + 
  geom_bar(width = 1) +
  coord_polar(theta = "y") +
  labs(title = "Répartition des Filières") +
  theme_minimal() +
  theme(legend.position = "right" , 
  axis.text.x = element_blank(), 
  axis.text.y = element_blank()) +
  scale_fill_brewer(palette = "Set2")




####Conversion de la variable Years of study (Annee d'etudes)
typeof(data$`Year of Study`)
if(is.character(data$`Year of Study`)){
  data$`Year of Study`<-as.factor(data$`Year of Study`)
}


# Création d'un graphe montrant la répartition des annees d'études
ggplot(data, aes(x = "", fill = `Year of Study`)) + 
  geom_bar(width = 1) +
  coord_polar(theta = "y") +
  labs(title = "Year Study Distribution") +
  theme_minimal() +
  theme(legend.position = "right" , 
        axis.text.x = element_blank(), 
        axis.text.y = element_blank()) +
  scale_fill_manual(values = c("#E41A1C", "#FF7F00")) +
  guides(fill = guide_legend(title = "Year of Study")) # Custom legend title




#---------------------------------------------------------------------
#3.2 : Traitement des valeurs aberentes et les valeurs manquantes

boxplot(data$Age)
boxplot.stats(data$Age)$out
out <- boxplot.stats(data$Age)$out
c=0

for (i in 1:length(data$Age)) {
  if (data$Age[i] %in% out) {
    data$Age[i] <- NA
    c=c+1
  }
}
#Calcul de propNA pour la décision finales des valeurs manquantes/aberrante
propNA=c/length(data$Age)
print(c)
print(propNA)    #propNA = 8,88% > 5%

for (i in 1:length(data$Age)) {
  if (is.na(data$Age[i])) {
    if (propNA < 0.05) {
      print("NA à supprimer")
    } else {
      data$Age[i] <- as.integer(mean(data$Age, na.rm = TRUE)) 
      # remplace la valeur manquante dans la colonne "Age"
      #par la moyenne des valeurs présentes dans la colonne "Age" (propNA > 0.05)        
    }
  }
}

if(is.numeric(data$Age)){
  data$Age=as.integer(data$Age)
}

#Retester Boxplot
boxplot(data$Age)   #Pas de valeurs manquantes et aberrantes


#Création du graphe de la repartition de la variable age (c'est bien organisé et prêt)
ggplot(data, aes(x = Age, fill = ..count..)) +
  geom_histogram(color = "black" ,bins = 10, alpha = 1, show.legend = FALSE, breaks = seq(18.5, 25.5, by = 1), center = TRUE) +
  scale_fill_viridis_c() +
  labs(x = "Age", y = "Frequency", title = "Distribution of Ages") +
  theme_minimal()


#---------------------------------------------------------------------
#3.3 : Test De Normalité

#H0 : il ny a pas de difference significative entre la loi normale et la distribution
#H1 : il y a une difference significative entre la loi normale et la distribution


#on calcule la valeur significative(proba de trouver h0), puis on compare cette valeur(p-value) avec le seuil significatif (5%)
   #si p-value > 5% on accepte h0 et on rejette h1
   #sinon on accepte h1 et on rejette h0

   shapiro.test(data$Age)  #variable quantitative

#pvalue=  1.751e-07 <5% : H1 il y a une difference significative entre la distribution et la loi normale 
#-> H1 est acceptée
#donc on n a pas la normalite au sens de shapiro strict


   
#Vérifions la Quasi-Normalité:
library(moments)
skewness(data$Age) #  1.681705 appartient [-3;3]
kurtosis(data$Age) #  7.045562 n'appartient pas [-3;3]

#indicateurs d'applatissement 
#Nous n'avons pas donc la quasi-normalité puisque kurtosis
#n'est pas dans l'intervalle favorable


##A noter que:
#(si on a la normalite, on utilise les tests parametriques)
#si on a la quasi normalite on utilise les deux types, en cas d'accord 
#entre les constats des tests on adopte les resultats des tests parametriques
#en cas de desaccord on utilise les tests non parametriques



#---------------------------------------------------------------------
#3.4 : Test De Fiabilité

#on modifie les donnees : 5: totally agree --> 1 totally disagree
#Conversion des reponses en valeur selon l'echele de Likert


# Transformation pour item1
data$item1[data$item1 == "Absolutely Disagree"] = 5
data$item1[data$item1 == "Disagree"] = 4
data$item1[data$item1 == "Neutral"] = 3
data$item1[data$item1 == "Agree"] = 2
data$item1[data$item1 == "Absolutely Agree"] = 1

data$item1 <- as.integer(data$item1)

# Transformation pour item2
data$item2[data$item2 == "Absolutely Disagree"] <- 5
data$item2[data$item2 == "Disagree"] <- 4
data$item2[data$item2 == "Neutral"] <- 3
data$item2[data$item2 == "Agree"] <- 2
data$item2[data$item2 == "Absolutely Agree"] <- 1

data$item2 <- as.integer(data$item2)

# Transformation pour item3
data$item3[data$item3 == "Absolutely Disagree"] <- 5
data$item3[data$item3 == "Disagree"] <- 4
data$item3[data$item3 == "Neutral"] <- 3
data$item3[data$item3 == "Agree"] <- 2
data$item3[data$item3 == "Absolutely Agree"] <- 1

data$item3 <- as.integer(data$item3)

# Répétez le même processus pour les colonnes de item4 à item22...

# Transformation pour item4
data$item4[data$item4 == "Absolutely Disagree"] <- 5
data$item4[data$item4 == "Disagree"] <- 4
data$item4[data$item4 == "Neutral"] <- 3
data$item4[data$item4 == "Agree"] <- 2
data$item4[data$item4 == "Absolutely Agree"] <- 1

data$item4 <- as.integer(data$item4)

# Répétez le même processus pour les colonnes de item5 à item22...

# Transformation pour item5
data$item5[data$item5 == "Absolutely Disagree"] <- 5
data$item5[data$item5 == "Disagree"] <- 4
data$item5[data$item5 == "Neutral"] <- 3
data$item5[data$item5 == "Agree"] <- 2
data$item5[data$item5 == "Absolutely Agree"] <- 1

data$item5 <- as.integer(data$item5)

# Transformation pour item6
data$item6[data$item6 == "Absolutely Disagree"] <- 5
data$item6[data$item6 == "Disagree"] <- 4
data$item6[data$item6 == "Neutral"] <- 3
data$item6[data$item6 == "Agree"] <- 2
data$item6[data$item6 == "Absolutely Agree"] <- 1

data$item6 <- as.integer(data$item6)

# Transformation pour item7
data$item7[data$item7 == "Absolutely Disagree"] <- 5
data$item7[data$item7 == "Disagree"] <- 4
data$item7[data$item7 == "Neutral"] <- 3
data$item7[data$item7 == "Agree"] <- 2
data$item7[data$item7 == "Absolutely Agree"] <- 1

data$item7 <- as.integer(data$item7)

# Transformation pour item8
data$item8[data$item8 == "Absolutely Disagree"] <- 5
data$item8[data$item8 == "Disagree"] <- 4
data$item8[data$item8 == "Neutral"] <- 3
data$item8[data$item8 == "Agree"] <- 2
data$item8[data$item8 == "Absolutely Agree"] <- 1

data$item8 <- as.integer(data$item8)

# Répétez le même processus pour les colonnes de item9 à item22...

# Transformation pour item9
data$item9[data$item9 == "Absolutely Disagree"] <- 5
data$item9[data$item9 == "Disagree"] <- 4
data$item9[data$item9 == "Neutral"] <- 3
data$item9[data$item9 == "Agree"] <- 2
data$item9[data$item9 == "Absolutely Agree"] <- 1

data$item9 <- as.integer(data$item9)

# Transformation pour item10
data$item10[data$item10 == "Absolutely Disagree"] <- 5
data$item10[data$item10 == "Disagree"] <- 4
data$item10[data$item10 == "Neutral"] <- 3
data$item10[data$item10 == "Agree"] <- 2
data$item10[data$item10 == "Absolutely Agree"] <- 1

data$item10 <- as.integer(data$item10)

# Transformation pour item11
data$item11[data$item11 == "Absolutely Disagree"] <- 5
data$item11[data$item11 == "Disagree"] <- 4
data$item11[data$item11 == "Neutral"] <- 3
data$item11[data$item11 == "Agree"] <- 2
data$item11[data$item11 == "Absolutely Agree"] <- 1

data$item11 <- as.integer(data$item11)

# Transformation pour item12
data$item12[data$item12 == "Absolutely Disagree"] <- 5
data$item12[data$item12 == "Disagree"] <- 4
data$item12[data$item12 == "Neutral"] <- 3
data$item12[data$item12 == "Agree"] <- 2
data$item12[data$item12 == "Absolutely Agree"] <- 1

data$item12 <- as.integer(data$item12)

# Transformation pour item13
data$item13[data$item13 == "Absolutely Disagree"] <- 5
data$item13[data$item13 == "Disagree"] <- 4
data$item13[data$item13 == "Neutral"] <- 3
data$item13[data$item13 == "Agree"] <- 2
data$item13[data$item13 == "Absolutely Agree"] <- 1

data$item13 <- as.integer(data$item13)

# Transformation pour item14
data$item14[data$item14 == "Absolutely Disagree"] <- 5
data$item14[data$item14 == "Disagree"] <- 4
data$item14[data$item14 == "Neutral"] <- 3
data$item14[data$item14 == "Agree"] <- 2
data$item14[data$item14 == "Absolutely Agree"] <- 1

data$item14 <- as.integer(data$item14)

# Transformation pour item15
data$item15[data$item15 == "Absolutely Disagree"] <- 5
data$item15[data$item15 == "Disagree"] <- 4
data$item15[data$item15 == "Neutral"] <- 3
data$item15[data$item15 == "Agree"] <- 2
data$item15[data$item15 == "Absolutely Agree"] <- 1

data$item15 <- as.integer(data$item15)

# Transformation pour item16
data$item16[data$item16 == "Absolutely Disagree"] <- 5
data$item16[data$item16 == "Disagree"] <- 4
data$item16[data$item16 == "Neutral"] <- 3
data$item16[data$item16 == "Agree"] <- 2
data$item16[data$item16 == "Absolutely Agree"] <- 1

data$item16 <- as.integer(data$item16)

# Transformation pour item17
data$item17[data$item17 == "Absolutely Disagree"] <- 5
data$item17[data$item17 == "Disagree"] <- 4
data$item17[data$item17 == "Neutral"] <- 3
data$item17[data$item17 == "Agree"] <- 2
data$item17[data$item17 == "Absolutely Agree"] <- 1

data$item17 <- as.integer(data$item17)

# Transformation pour item18
data$item18[data$item18 == "Absolutely Disagree"] <- 5
data$item18[data$item18 == "Disagree"] <- 4
data$item18[data$item18 == "Neutral"] <- 3
data$item18[data$item18 == "Agree"] <- 2
data$item18[data$item18 == "Absolutely Agree"] <- 1

data$item18 <- as.integer(data$item18)

# Transformation pour item19
data$item19[data$item19 == "Absolutely Disagree"] <- 5
data$item19[data$item19 == "Disagree"] <- 4
data$item19[data$item19 == "Neutral"] <- 3
data$item19[data$item19 == "Agree"] <- 2
data$item19[data$item19 == "Absolutely Agree"] <- 1

data$item19 <- as.integer(data$item19)

# Transformation pour item20
data$item20[data$item20 == "Absolutely Disagree"] <- 5
data$item20[data$item20 == "Disagree"] <- 4
data$item20[data$item20 == "Neutral"] <- 3
data$item20[data$item20 == "Agree"] <- 2
data$item20[data$item20 == "Absolutely Agree"] <- 1

data$item20 <- as.integer(data$item20)

# Transformation pour item21
data$item21[data$item21 == "Absolutely Disagree"] <- 5
data$item21[data$item21 == "Disagree"] <- 4
data$item21[data$item21 == "Neutral"] <- 3
data$item21[data$item21 == "Agree"] <- 2
data$item21[data$item21 == "Absolutely Agree"] <- 1

data$item21 <- as.integer(data$item21)

# Transformation pour item22
data$item22[data$item22 == "Absolutely Disagree"] <- 5
data$item22[data$item22 == "Disagree"] <- 4
data$item22[data$item22 == "Neutral"] <- 3
data$item22[data$item22 == "Agree"] <- 2
data$item22[data$item22 == "Absolutely Agree"] <- 1

data$item22 <- as.integer(data$item22)

# Transformation pour item23
data$item23[data$item23 == "Absolutely Disagree"] <- 5
data$item23[data$item23 == "Disagree"] <- 4
data$item23[data$item23 == "Neutral"] <- 3
data$item23[data$item23 == "Agree"] <- 2
data$item23[data$item23 == "Absolutely Agree"] <- 1

data$item23 <- as.integer(data$item23)

# Transformation pour item24
data$item24[data$item24 == "Absolutely Disagree"] <- 5
data$item24[data$item24 == "Disagree"] <- 4
data$item24[data$item24 == "Neutral"] <- 3
data$item24[data$item24 == "Agree"] <- 2
data$item24[data$item24 == "Absolutely Agree"] <- 1

data$item24 <- as.integer(data$item24)


# Transformation pour item25
data$item25[data$item25 == "Absolutely Disagree"] <- 5
data$item25[data$item25 == "Disagree"] <- 4
data$item25[data$item25 == "Neutral"] <- 3
data$item25[data$item25 == "Agree"] <- 2
data$item25[data$item25 == "Absolutely Agree"] <- 1

data$item25 <- as.integer(data$item25)

# Transformation pour item26
data$item26[data$item26 == "Absolutely Disagree"] <- 5
data$item26[data$item26 == "Disagree"] <- 4
data$item26[data$item26 == "Neutral"] <- 3
data$item26[data$item26 == "Agree"] <- 2
data$item26[data$item26 == "Absolutely Agree"] <- 1

data$item26 <- as.integer(data$item26)

View(data)


#Calcul de l'alpha de cronbach

library(psych)
construit=data.frame(data$item1, data$item2, data$item3, data$item4, data$item5, data$item6, data$item7, data$item8, data$item9, data$item10, data$item11, data$item12, data$item13, data$item14, data$item15, data$item16, data$item17, data$item18, data$item19, data$item20, data$item21, data$item22,data$item23,data$item24,data$item25,data$item26)
alpha(construit)

#alpha de cronbach >0,7 : coherence entre les iterations
        #-->le questionnaire est fiable


#si l'alpha est <0.7 ou bien 0.6 on devrait effectuer l'epuration des valeurs non significatives
#c'est a dire le table (reliability if an item is dropped) pour determiner l'item problematique

##################################################### TRAITEMENT ###############################################################

#---------------------------------------------------------------------
#4.1Statistique descriptive numerique univariée 
summary(data$Gender)
summary(data$Age)
summary(data$`Year of Study`)
summary(data$`Engin

eering Field`)
summary.factor(data$item1)
summary.factor(data$item2)
summary.factor(data$item3)
summary.factor(data$item4)
summary.factor(data$item5)
summary.factor(data$item6)
summary.factor(data$item7)
summary.factor(data$item8)
summary.factor(data$item9)
summary.factor(data$item10)
summary.factor(data$item11)
summary.factor(data$item12)
summary.factor(data$item13)
summary.factor(data$item14)
summary.factor(data$item15)
summary.factor(data$item15)
summary.factor(data$item16)
summary.factor(data$item17)
summary.factor(data$item18)
summary.factor(data$item19)               
summary.factor(data$item20)
summary.factor(data$item21)
summary.factor(data$item22)
summary.factor(data$item23)
summary.factor(data$item24)
summary.factor(data$item25)
summary.factor(data$item26)


#---------------------------------------------------------------------
#4.2:Test des hypotheses

######Etude de la variable Genre
#Test de representativité
table(data$Gender)
# F : 15
# M : 30   

chisq.test(table(data$Gender))
#p-value<5%: H1 accépté: Il y a une difference signif entre freq les hom et femme et les frequ theoriques 
#on a pas de representativité:Le nombre des hommes est plus grand que le nombre des femmes.



#Les sous hypthèses à verifier


#--------------------
#A.    Existence d'une association entre l'age et l'employabilié.

#Age: variable quantitative+ne suit pas la loi normale, 
#item1(As an engineering student at ENSAK, I feel well prepared to integrate into the job market.):variable qualitative => test non-paramétrique : wilcox-test
wilcox.test(data$Age,data$item1)
#p-value<5%:H1 accépté: Il y a une assocaition significative entre l'age des individus et l'emplyabilité: l'emplyabilté varie selon l'age de l'individu
table(data$Age,data$item1)
#les personnes agees de 21 se sont bien prepares a l'employabilité
#--------------------

#--------------------
#B   .  Existence d'une association entre le genre et l'emplyabilté
#genre et item1 sont tous les deux qualitative => test de chisq
table(data$Gender,data$item1)
chisq.test(table(data$Gender,data$item1))
#p-value >5 %: H0 accepté: il n'y a pas d'assocaition entre le genre et l'emplyabilité.
#--------------------

#--------------------
#C  .   Existence d'une association entre l'année d'étude et l'emplyabilté
#l'année d'etude et item1 sont tous les deux qualitative => test de chisq
table(data$`Year of Study`,data$item1)
chisq.test(table(data$`Year of Study`,data$item1))
#p-value >5 %: H0 accepté: il n'y a pas d'association entre l'anne d'étude et l'emplyabilité.
#--------------------



####Vérification des hypothèses de recherches###

#--------------------
#H1:Les compétences essentielles et supplémentaires peuvent influencer l'employabilité

#item1(As an engineering student at ENSAK, I feel well prepared to integrate into the job market.) 
#item12 (I invest time in developing complementary skills (e.g., languages, software, interpersonal skills) outside of the academic program.)
#sont tous les deux variables qualitatives=> test de chisq
chisq.test(data$item1,data$item12)
#p-value<5%: H1 acccepté: Il y a assocaiton entre les compétences supplémentaires et l'emplyabilité

#item3(Academic programs at ENSAK have provided the necessary skills to succeed in the field of engineering)
chisq.test(data$item1,data$item3)
#p-value>5%: H0 acccepté: Il n y a pas d'assocaiton entre les compétences essentielles et l'emplyabilité
# H1=========================================> Hypothèse refusé
#--------------------


#--------------------
#H2:Une éducation universitaire bien adaptée aux besoins du marché du travail améliore l'employabilité des étudiants en ingénierie
#item1(As an engineering student at ENSAK, I feel well prepared to integrate into the job market.)
#item8(I perceive that the subjects taught in my program are directly related to the requirements of the job market.)
#sont des variables qualitatitives=> test de chisq
chisq.test(data$item1,data$item8)
#p-value<5%: H1 acccepté: Il a une assocaiton entre l'education universitaire et l'employabilité
#H2===========================================> Hypotèse accépté
#--------------------


#--------------------
#H3:Un réseau professionnel bien établi peut influencer les opportunités d'emploi et de carrière
#item1(As an engineering student at ENSAK, I feel well prepared to integrate into the job market.)
#item24(By attending industry events, participating in student organizations, and connecting with professionals through platforms like LinkedIn)
#sont des variables qualitatitives=> test de chisq
chisq.test(data$item1,data$item24)
#p-value<5% : H1 accepté : Il y a une association entre le réseau professionnel et l'employabilité
#H3============================================> Hypothèse accépté
#--------------------