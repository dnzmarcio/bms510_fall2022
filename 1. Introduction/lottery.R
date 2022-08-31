# Name Lottery

## install.packages("wordcloud")
library(wordcloud)

n <- 50
biostat_course <- c("Inga",  "Beyza", "Basia", "Maya",
                   "Na Jeong", "Roberta", "Nimisha", "Elena", "Nick")
student <- rep(NA, n)

for(i in 1:n){
  student[i] <- sample(biostat_course, size = 1,
                       replace = FALSE, prob = NULL)
  wordcloud(student, colors =  rainbow(9))
  Sys.sleep(0.1) 
}




