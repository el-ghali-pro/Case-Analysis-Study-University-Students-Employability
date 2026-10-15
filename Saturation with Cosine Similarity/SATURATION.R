# Qualitative Study*****
# Step 2: Data Collection
# Importing the first analysis grid which contains the responses of individuals for each question


library(readxl)
grille1 <- read_excel("C:/Users/info/Desktop/grid.xlsx")
View(grille1)

#Saturation or level of similarity in a qualitative research context refers to similarity of responses or
#the repetition of information.

# Install and load the necessary libraries
install.packages("tm")
install.packages("wordcloud")
install.packages("lsa")

library(tm)
library(wordcloud)
library(lsa)

# Gather responses for each question into a single string
#The question 1 contains all the responses of individuals for this question, etc.
question1 <- paste(grille1$Q1, collapse = " ")
question2 <- paste(grille1$Q2, collapse = " ")#the same for q2
question3 <- paste(grille1$Q3, collapse = " ")
question4 <- paste(grille1$Q4, collapse = " ")
question5 <- paste(grille1$Q5, collapse = " ")
question6 <- paste(grille1$Q6, collapse = " ")
question7 <- paste(grille1$Q7, collapse = " ")
question8 <- paste(grille1$Q8, collapse = " ")

# Creates a corpus containing the responses to all the questions
corpus <- Corpus(VectorSource(c(question1, question2,question3,question4,question5,question6,question7,question8)))  
# Create a Document-Term Matrix (DTM) from the texts
#DTM contains information on the frequency of terms (words) in each response to the corpus questions
corpus1 <- Corpus(VectorSource(corpus))
dtm <- DocumentTermMatrix(corpus1)
# Convert DTM to a matrix of term frequencies
term_freq_matrix <- as.matrix(dtm)
#where the rows represent the terms (words) and the columns represent the documents (responses to the questions
#cosine_similarity is a matrix containing cosine similarity values that are used to compare similarity
cosine_similarity <- cosine(t(term_freq_matrix))

# Calculate the  similarity as saturation percentage 
saturation_percentage <- mean(cosine_similarity)

# Print the saturation percentage
print(saturation_percentage)
#0.33 is less than 50% > so We don't have similarity between the responses.

