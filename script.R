#######################################################################################  
#                              Student Employability                                  #
#                                   at ENSAK                                          #
#######################################################################################            


########################################## RESEARCH QUESTIONS ####################################################



#1.1: Research questions:
######Which criteria are most sought by employers in fields related to ENSAK's programs?
######What obstacles do graduates face when searching for jobs and integrating into the labor market?


#1.2: Population: students at ENSA of Kenitra


#1.3: Data definitions (data dictionary)

#Population characteristics:
# - Age (numeric -> quantitative variable)
# - Gender (character -> nominal categorical variable: H = man, F = woman)
# - Engineering field (character -> categorical variable)
# - Year of study (character -> categorical variable)


#1.4: Main hypotheses
#H1: "Essential and complementary skills can influence employability."
#H2: "University education aligned with labor-market needs improves engineering students' employability."
#H3: "A well-established professional network can influence employment and career opportunities."



#####################################   DATA COLLECTION  #########################################################



#Import the data
library(readxl)
data <- read_excel("C:/Users/info/Downloads/Dataset.xlsx")
View(data)
class(data)



#####################################   DATA PREPROCESSING  ######################################################

#---------------------------------------------------------------------
#3.1: Data conversion

#######Rename questionnaire item columns

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

#Verify the column-name conversion
View(data)



######Convert the Gender variable
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

# Create a chart showing the distribution of the two gender categories
library(ggplot2)
ggplot(data, aes(x = Gender, fill = Gender)) +
  geom_bar() +
  scale_fill_manual(values = c("H" = "cyan", "F" = "magenta")) +
  labs(x = "Gender", y = "Frequency", title = "Distribution of Gender") +
  theme_minimal()




####Convert the Age variable

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

#This variable will be examined in more detail later because of
#issues with unusual values.




####Convert `Engineering Field` to a factor if it is a character variable
if(is.character(data$`Engineering Field`)){
  data$`Engineering Field` <- as.factor(data$`Engineering Field`)
}


# Create a chart showing the distribution of engineering fields
ggplot(data, aes(x = "", fill = `Engineering Field`)) + 
  geom_bar(width = 1) +
  coord_polar(theta = "y") +
  labs(title = "Répartition des Filières") +
  theme_minimal() +
  theme(legend.position = "right" , 
  axis.text.x = element_blank(), 
  axis.text.y = element_blank()) +
  scale_fill_brewer(palette = "Set2")




####Convert the Year of Study variable
typeof(data$`Year of Study`)
if(is.character(data$`Year of Study`)){
  data$`Year of Study`<-as.factor(data$`Year of Study`)
}


# Create a chart showing the distribution of study years
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
#3.2: Handle outliers and missing values

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
#Calculate the proportion of missing/outlier values to decide how to handle them
propNA=c/length(data$Age)
print(c)
print(propNA)    #propNA = 8,88% > 5%

for (i in 1:length(data$Age)) {
  if (is.na(data$Age[i])) {
    if (propNA < 0.05) {
      print("NA à supprimer")
    } else {
      data$Age[i] <- as.integer(mean(data$Age, na.rm = TRUE)) 
      # Replace missing values in the "Age" column with the mean of
      # the observed ages when the missing-value proportion exceeds 5%.
    }
  }
}

if(is.numeric(data$Age)){
  data$Age=as.integer(data$Age)
}

#Recheck the boxplot
boxplot(data$Age)   #No missing values or outliers remain


#Create a histogram of the Age variable after cleaning
ggplot(data, aes(x = Age, fill = ..count..)) +
  geom_histogram(color = "black" ,bins = 10, alpha = 1, show.legend = FALSE, breaks = seq(18.5, 25.5, by = 1), center = TRUE) +
  scale_fill_viridis_c() +
  labs(x = "Age", y = "Frequency", title = "Distribution of Ages") +
  theme_minimal()


#---------------------------------------------------------------------
#3.3: Normality test

#H0: There is no significant difference between the data distribution and a normal distribution.
#H1: There is a significant difference between the data distribution and a normal distribution.


#Calculate the p-value, then compare it with the significance threshold (5%).
   #If p-value > 5%, do not reject H0.
   #Otherwise, reject H0 in favor of H1.

   shapiro.test(data$Age)  #Quantitative variable

#p-value = 1.751e-07 < 5%: reject H0; the distribution differs significantly from a normal distribution.
#Therefore, the Age variable does not meet the strict Shapiro-Wilk normality assumption.


   
#Check approximate normality:
library(moments)
skewness(data$Age) # 1.681705 is within [-3, 3]
kurtosis(data$Age) # 7.045562 is outside [-3, 3]

#Kurtosis and skewness indicators
#The distribution is not approximately normal because its kurtosis
#is outside the acceptable interval.


##Note:
#If the data are normally distributed, use parametric tests.
#If the data are approximately normal, both test types may be considered.
#If their conclusions agree, use the parametric-test results;
#if they disagree, use the non-parametric tests.



#---------------------------------------------------------------------
#3.4: Reliability test

#Recode the responses on the Likert scale:
#5 = Absolutely Disagree, ..., 1 = Absolutely Agree.


# Recode item1 responses using the Likert scale
data$item1[data$item1 == "Absolutely Disagree"] = 5
data$item1[data$item1 == "Disagree"] = 4
data$item1[data$item1 == "Neutral"] = 3
data$item1[data$item1 == "Agree"] = 2
data$item1[data$item1 == "Absolutely Agree"] = 1

data$item1 <- as.integer(data$item1)

# Recode item2 responses using the Likert scale
data$item2[data$item2 == "Absolutely Disagree"] <- 5
data$item2[data$item2 == "Disagree"] <- 4
data$item2[data$item2 == "Neutral"] <- 3
data$item2[data$item2 == "Agree"] <- 2
data$item2[data$item2 == "Absolutely Agree"] <- 1

data$item2 <- as.integer(data$item2)

# Recode item3 responses using the Likert scale
data$item3[data$item3 == "Absolutely Disagree"] <- 5
data$item3[data$item3 == "Disagree"] <- 4
data$item3[data$item3 == "Neutral"] <- 3
data$item3[data$item3 == "Agree"] <- 2
data$item3[data$item3 == "Absolutely Agree"] <- 1

data$item3 <- as.integer(data$item3)

# Repeat the same process for item4 through item22.

# Recode item4 responses using the Likert scale
data$item4[data$item4 == "Absolutely Disagree"] <- 5
data$item4[data$item4 == "Disagree"] <- 4
data$item4[data$item4 == "Neutral"] <- 3
data$item4[data$item4 == "Agree"] <- 2
data$item4[data$item4 == "Absolutely Agree"] <- 1

data$item4 <- as.integer(data$item4)

# Repeat the same process for item5 through item22.

# Recode item5 responses using the Likert scale
data$item5[data$item5 == "Absolutely Disagree"] <- 5
data$item5[data$item5 == "Disagree"] <- 4
data$item5[data$item5 == "Neutral"] <- 3
data$item5[data$item5 == "Agree"] <- 2
data$item5[data$item5 == "Absolutely Agree"] <- 1

data$item5 <- as.integer(data$item5)

# Recode item6 responses using the Likert scale
data$item6[data$item6 == "Absolutely Disagree"] <- 5
data$item6[data$item6 == "Disagree"] <- 4
data$item6[data$item6 == "Neutral"] <- 3
data$item6[data$item6 == "Agree"] <- 2
data$item6[data$item6 == "Absolutely Agree"] <- 1

data$item6 <- as.integer(data$item6)

# Recode item7 responses using the Likert scale
data$item7[data$item7 == "Absolutely Disagree"] <- 5
data$item7[data$item7 == "Disagree"] <- 4
data$item7[data$item7 == "Neutral"] <- 3
data$item7[data$item7 == "Agree"] <- 2
data$item7[data$item7 == "Absolutely Agree"] <- 1

data$item7 <- as.integer(data$item7)

# Recode item8 responses using the Likert scale
data$item8[data$item8 == "Absolutely Disagree"] <- 5
data$item8[data$item8 == "Disagree"] <- 4
data$item8[data$item8 == "Neutral"] <- 3
data$item8[data$item8 == "Agree"] <- 2
data$item8[data$item8 == "Absolutely Agree"] <- 1

data$item8 <- as.integer(data$item8)

# Repeat the same process for item9 through item22.

# Recode item9 responses using the Likert scale
data$item9[data$item9 == "Absolutely Disagree"] <- 5
data$item9[data$item9 == "Disagree"] <- 4
data$item9[data$item9 == "Neutral"] <- 3
data$item9[data$item9 == "Agree"] <- 2
data$item9[data$item9 == "Absolutely Agree"] <- 1

data$item9 <- as.integer(data$item9)

# Recode item10 responses using the Likert scale
data$item10[data$item10 == "Absolutely Disagree"] <- 5
data$item10[data$item10 == "Disagree"] <- 4
data$item10[data$item10 == "Neutral"] <- 3
data$item10[data$item10 == "Agree"] <- 2
data$item10[data$item10 == "Absolutely Agree"] <- 1

data$item10 <- as.integer(data$item10)

# Recode item11 responses using the Likert scale
data$item11[data$item11 == "Absolutely Disagree"] <- 5
data$item11[data$item11 == "Disagree"] <- 4
data$item11[data$item11 == "Neutral"] <- 3
data$item11[data$item11 == "Agree"] <- 2
data$item11[data$item11 == "Absolutely Agree"] <- 1

data$item11 <- as.integer(data$item11)

# Recode item12 responses using the Likert scale
data$item12[data$item12 == "Absolutely Disagree"] <- 5
data$item12[data$item12 == "Disagree"] <- 4
data$item12[data$item12 == "Neutral"] <- 3
data$item12[data$item12 == "Agree"] <- 2
data$item12[data$item12 == "Absolutely Agree"] <- 1

data$item12 <- as.integer(data$item12)

# Recode item13 responses using the Likert scale
data$item13[data$item13 == "Absolutely Disagree"] <- 5
data$item13[data$item13 == "Disagree"] <- 4
data$item13[data$item13 == "Neutral"] <- 3
data$item13[data$item13 == "Agree"] <- 2
data$item13[data$item13 == "Absolutely Agree"] <- 1

data$item13 <- as.integer(data$item13)

# Recode item14 responses using the Likert scale
data$item14[data$item14 == "Absolutely Disagree"] <- 5
data$item14[data$item14 == "Disagree"] <- 4
data$item14[data$item14 == "Neutral"] <- 3
data$item14[data$item14 == "Agree"] <- 2
data$item14[data$item14 == "Absolutely Agree"] <- 1

data$item14 <- as.integer(data$item14)

# Recode item15 responses using the Likert scale
data$item15[data$item15 == "Absolutely Disagree"] <- 5
data$item15[data$item15 == "Disagree"] <- 4
data$item15[data$item15 == "Neutral"] <- 3
data$item15[data$item15 == "Agree"] <- 2
data$item15[data$item15 == "Absolutely Agree"] <- 1

data$item15 <- as.integer(data$item15)

# Recode item16 responses using the Likert scale
data$item16[data$item16 == "Absolutely Disagree"] <- 5
data$item16[data$item16 == "Disagree"] <- 4
data$item16[data$item16 == "Neutral"] <- 3
data$item16[data$item16 == "Agree"] <- 2
data$item16[data$item16 == "Absolutely Agree"] <- 1

data$item16 <- as.integer(data$item16)

# Recode item17 responses using the Likert scale
data$item17[data$item17 == "Absolutely Disagree"] <- 5
data$item17[data$item17 == "Disagree"] <- 4
data$item17[data$item17 == "Neutral"] <- 3
data$item17[data$item17 == "Agree"] <- 2
data$item17[data$item17 == "Absolutely Agree"] <- 1

data$item17 <- as.integer(data$item17)

# Recode item18 responses using the Likert scale
data$item18[data$item18 == "Absolutely Disagree"] <- 5
data$item18[data$item18 == "Disagree"] <- 4
data$item18[data$item18 == "Neutral"] <- 3
data$item18[data$item18 == "Agree"] <- 2
data$item18[data$item18 == "Absolutely Agree"] <- 1

data$item18 <- as.integer(data$item18)

# Recode item19 responses using the Likert scale
data$item19[data$item19 == "Absolutely Disagree"] <- 5
data$item19[data$item19 == "Disagree"] <- 4
data$item19[data$item19 == "Neutral"] <- 3
data$item19[data$item19 == "Agree"] <- 2
data$item19[data$item19 == "Absolutely Agree"] <- 1

data$item19 <- as.integer(data$item19)

# Recode item20 responses using the Likert scale
data$item20[data$item20 == "Absolutely Disagree"] <- 5
data$item20[data$item20 == "Disagree"] <- 4
data$item20[data$item20 == "Neutral"] <- 3
data$item20[data$item20 == "Agree"] <- 2
data$item20[data$item20 == "Absolutely Agree"] <- 1

data$item20 <- as.integer(data$item20)

# Recode item21 responses using the Likert scale
data$item21[data$item21 == "Absolutely Disagree"] <- 5
data$item21[data$item21 == "Disagree"] <- 4
data$item21[data$item21 == "Neutral"] <- 3
data$item21[data$item21 == "Agree"] <- 2
data$item21[data$item21 == "Absolutely Agree"] <- 1

data$item21 <- as.integer(data$item21)

# Recode item22 responses using the Likert scale
data$item22[data$item22 == "Absolutely Disagree"] <- 5
data$item22[data$item22 == "Disagree"] <- 4
data$item22[data$item22 == "Neutral"] <- 3
data$item22[data$item22 == "Agree"] <- 2
data$item22[data$item22 == "Absolutely Agree"] <- 1

data$item22 <- as.integer(data$item22)

# Recode item23 responses using the Likert scale
data$item23[data$item23 == "Absolutely Disagree"] <- 5
data$item23[data$item23 == "Disagree"] <- 4
data$item23[data$item23 == "Neutral"] <- 3
data$item23[data$item23 == "Agree"] <- 2
data$item23[data$item23 == "Absolutely Agree"] <- 1

data$item23 <- as.integer(data$item23)

# Recode item24 responses using the Likert scale
data$item24[data$item24 == "Absolutely Disagree"] <- 5
data$item24[data$item24 == "Disagree"] <- 4
data$item24[data$item24 == "Neutral"] <- 3
data$item24[data$item24 == "Agree"] <- 2
data$item24[data$item24 == "Absolutely Agree"] <- 1

data$item24 <- as.integer(data$item24)


# Recode item25 responses using the Likert scale
data$item25[data$item25 == "Absolutely Disagree"] <- 5
data$item25[data$item25 == "Disagree"] <- 4
data$item25[data$item25 == "Neutral"] <- 3
data$item25[data$item25 == "Agree"] <- 2
data$item25[data$item25 == "Absolutely Agree"] <- 1

data$item25 <- as.integer(data$item25)

# Recode item26 responses using the Likert scale
data$item26[data$item26 == "Absolutely Disagree"] <- 5
data$item26[data$item26 == "Disagree"] <- 4
data$item26[data$item26 == "Neutral"] <- 3
data$item26[data$item26 == "Agree"] <- 2
data$item26[data$item26 == "Absolutely Agree"] <- 1

data$item26 <- as.integer(data$item26)

View(data)


#Calculate Cronbach's alpha

library(psych)
construit=data.frame(data$item1, data$item2, data$item3, data$item4, data$item5, data$item6, data$item7, data$item8, data$item9, data$item10, data$item11, data$item12, data$item13, data$item14, data$item15, data$item16, data$item17, data$item18, data$item19, data$item20, data$item21, data$item22,data$item23,data$item24,data$item25,data$item26)
alpha(construit)

#Cronbach's alpha > 0.7 indicates consistency among the questionnaire items.
        #The questionnaire is considered reliable.


#If alpha is below 0.7 (or 0.6), consider removing non-informative items.
#Use the "reliability if an item is dropped" table to identify problematic items.

##################################################### ANALYSIS ################################################################

#---------------------------------------------------------------------
#4.1: Univariate descriptive statistics
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
#4.2: Hypothesis testing

######Analyze the Gender variable
#Representativeness test
table(data$Gender)
# F : 15
# M : 30   

chisq.test(table(data$Gender))
#p-value < 5%: The observed gender frequencies differ significantly from the expected frequencies.
#The sample is not representative by gender because there are more men than women.



#Sub-hypotheses to test


#--------------------
#A. Is there an association between age and employability?

#Age is quantitative and is not normally distributed.
#Item1 (perceived readiness to enter the job market) is categorical; use a non-parametric Wilcoxon test.
wilcox.test(data$Age,data$item1)
#p-value < 5%: Reject H0. Perceived employability is significantly associated with age.
table(data$Age,data$item1)
#Respondents aged 21 reported feeling well prepared for employment.
#--------------------

#--------------------
#B. Is there an association between gender and employability?
#Gender and item1 are categorical variables; use a chi-square test.
table(data$Gender,data$item1)
chisq.test(table(data$Gender,data$item1))
#p-value > 5%: Do not reject H0; no association between gender and employability was detected.
#--------------------

#--------------------
#C. Is there an association between year of study and employability?
#Year of study and item1 are categorical variables; use a chi-square test.
table(data$`Year of Study`,data$item1)
chisq.test(table(data$`Year of Study`,data$item1))
#p-value > 5%: Do not reject H0; no association between year of study and employability was detected.
#--------------------



####Test the research hypotheses###

#--------------------
#H1: Essential and complementary skills can influence employability.

#item1(As an engineering student at ENSAK, I feel well prepared to integrate into the job market.) 
#item12 (I invest time in developing complementary skills (e.g., languages, software, interpersonal skills) outside of the academic program.)
#Both are categorical variables; use a chi-square test.
chisq.test(data$item1,data$item12)
#p-value < 5%: Evidence of an association between complementary skills and employability.

#item3(Academic programs at ENSAK have provided the necessary skills to succeed in the field of engineering)
chisq.test(data$item1,data$item3)
#p-value > 5%: No association between essential program skills and employability was detected.
#H1 is not supported overall.
#--------------------


#--------------------
#H2: University education aligned with labor-market needs improves engineering students' employability.
#item1(As an engineering student at ENSAK, I feel well prepared to integrate into the job market.)
#item8(I perceive that the subjects taught in my program are directly related to the requirements of the job market.)
#These are categorical variables; use a chi-square test.
chisq.test(data$item1,data$item8)
#p-value < 5%: Evidence of an association between university education and employability.
#H2 is supported.
#--------------------


#--------------------
#H3: A well-established professional network can influence employment and career opportunities.
#item1(As an engineering student at ENSAK, I feel well prepared to integrate into the job market.)
#item24(By attending industry events, participating in student organizations, and connecting with professionals through platforms like LinkedIn)
#These are categorical variables; use a chi-square test.
chisq.test(data$item1,data$item24)
#p-value < 5%: Evidence of an association between professional networking and employability.
#H3 is supported.
#--------------------