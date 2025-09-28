library(dplyr)

setwd('/Users/megsheppard/Desktop/imagen/brenda')

df <- read.csv('final_CTQ_data.csv')

# Define the reverse coding function
#as the values are already numbers, we can use as.character rather than as.numeric here
reverse_code <- function(x) {
  recode_vals <- c(`1` = 5, `2` = 4, `3` = 3, `4` = 2, `5` = 1)
  return(recode_vals[as.character(x)])
}

# Vector of column names to reverse
#these are the ones that are specified in the CTQ scoring document
cols_to_reverse <- c('CTQ_5', 'CTQ_7', 'CTQ_13', 'CTQ_19', 'CTQ_28', 'CTQ_2', 'CTQ_26')

#this creates new columns with the reverse-coded variables and changes their name to add an r into it e.g., CTQ_5r
for (col in cols_to_reverse) {
  df[[paste0(col, "r")]] <- reverse_code(df[[col]])
}

# delete the original columns for those that needed to be reverse-coded
df <- df[ , !(names(df) %in% cols_to_reverse)]

#check how many rows have 'NA' 
sum(apply(df, 1, function(row) any(is.na(row))))

#remove any NAs - trying it now to see the difference
df <- na.omit(df)

#add a column titled physical abuse and sum the necessary rows (repeat for all variables)
#this information is taken from the CTQ document (which items correspond to which subscales)
#na.rm=TRUE ignores any NA values and still totals it if it has scores in other columns
df <- df %>%
  mutate(emotional_abuse = rowSums(across(c(CTQ_3, CTQ_8, CTQ_14, CTQ_18, CTQ_25)), na.rm = TRUE))

df <- df %>%
  mutate(physical_abuse = rowSums(across(c(CTQ_9, CTQ_11, CTQ_12, CTQ_15, CTQ_17)), na.rm = TRUE))

df <- df %>%
  mutate(sexual_abuse = rowSums(across(c(CTQ_20, CTQ_21, CTQ_23, CTQ_24, CTQ_27)), na.rm = TRUE))

df <- df %>%
  mutate(emotional_neglect = rowSums(across(c(CTQ_5r, CTQ_7r, CTQ_13r, CTQ_19r, CTQ_28r)), na.rm = TRUE))

df <- df %>%
  mutate(physical_neglect = rowSums(across(c(CTQ_1, CTQ_2r, CTQ_4, CTQ_6, CTQ_26r)), na.rm = TRUE))

df <- df %>%
  mutate(minimisation_denial = rowSums(across(c(CTQ_10, CTQ_16, CTQ_22)), na.rm = TRUE))

#add a column to total all CTQ scores across all subscales calculated
df <- df %>%
  mutate(CTQ_score = rowSums(across(c(physical_abuse, emotional_abuse, sexual_abuse, emotional_neglect, physical_neglect)), na.rm = TRUE))

#create a dataframe of those with severe physical abuse scores - 13 is cut off due to Bernstein and Fink (1998)'s criteria (widely accepted)
df_PA_above_13 <- df %>%
  filter(physical_abuse >= 13)

#create a df of those with severe emotional abuse scores - 16 is cut off due to Bernstein and Fink (1998)'s criteria (widely accepted)
df_EA_above_16 <- df %>%
  filter(emotional_abuse >= 16)

#create a df of those with severe sexual abuse scores - 13 is cut off due to Bernstein and Fink (1998)'s criteria (widely accepted)
df_SA_above_13 <- df %>%
  filter(sexual_abuse >= 13)

#create a df of those with severe emotional neglect scores - 18 is cut off due to Bernstein and Fink (1998)'s criteria (widely accepted)
df_EN_above_18 <- df %>%
  filter(emotional_neglect >= 18)

#create a df of those with severe physical neglect scores - 13 is cut off due to Bernstein and Fink (1998)'s criteria (widely accepted)
df_PN_above_13 <- df %>%
  filter(physical_neglect >= 13)

#MODERATE-SEVERE
#create a df of those with moderate-severe physical abuse scores -
df_PA_mod <- df %>%
  filter(physical_abuse >= 12)

#create a df of those with moderate - severe emotional abuse scores
df_EA_mod <- df %>%
  filter(emotional_abuse >= 15)

#create a df of those with moderate - severe sexual abuse scores 
df_SA_mod <- df %>%
  filter(sexual_abuse >= 12)

#create a df of those with moderate-severe emotional neglect scores 
df_EN_mod <- df %>%
  filter(emotional_neglect >= 17)

#create a df of those with moderate-severe physical neglect scores -
df_PN_mod <- df %>%
  filter(physical_neglect >= 12)

#creates a dataframe with the 25 highest cumulative CTQ scores 
df_cumul_39 <- df %>%
  filter(CTQ_score >= 39)

#finding the lowest score for the lowest 25, this produces a df with 173, so we need to randomly select 25
df_lowest <- df %>% filter(CTQ_score <= 14)

# Randomly select 20 rows from df_lowest
set.seed(123)  # this ensures when we rerun the analysis, the same 25 which were originally picked at random are picked again
sampled_rows <- df_lowest[sample(nrow(df_lowest), 20), ]

#randomly
set.seed(123)  # this ensures when we rerun the analysis, the same 25 which were originally picked at random are picked again
sampled_rows <- df_lowest[sample(nrow(df_lowest), 20), ]

#combine into one dataframe with highest and lowest
combined_df <- rbind(df_cumul_39, sampled_rows)

#produce a csv
write.csv(combined_df, "CTQ_subset_brenda.csv", row.names = FALSE)
