library(NHSRdatasets)
library(dplyr)
library(tidyr)
library(varhandle)
library(magrittr)
library(rsample)
library(caret)
#remotes::install_github("https://github.com/StatsGary/ConfusionTableR")
library(ConfusionTableR)
library(taskscheduleR)
library(data.table)

#------------------------------------------------------------
#             Data Manipulation and loading 
#------------------------------------------------------------


stranded <- NHSRdatasets::stranded_data %>% 
  setNames(c("stranded_class", "age", "care_home_ref_flag", "medically_safe_flag", 
             "hcop_flag", "needs_mental_health_support_flag", "previous_care_in_last_12_month", "admit_date", "frail_descrip")) %>% 
  mutate(stranded_class = factor(stranded_class)) %>% 
  drop_na()

# Create dummy encoding of frailty index
cats <- varhandle::to.dummy(stranded$frail_descrip, "frail") %>% 
  as.data.frame() %>% 
  dplyr::select(-c(frail.No_index_item)) #Get rid of reference column

stranded <- stranded %>%
  cbind(cats) %>% 
  dplyr::select(-c(admit_date, frail_descrip))

#------------------------------------------------------------
#             Simple Test and Train Split
#------------------------------------------------------------

set.seed(123)
split <- rsample::initial_split(stranded, prop=3/4)
train_data <- rsample::training(split)
test_data <- rsample::testing(split)

#------------------------------------------------------------
#             Rebalance Classes
#------------------------------------------------------------
class_bal_table <- table(stranded$stranded_class)
prop_tab <- prop.table(class_bal_table)
upsample_ratio <- class_bal_table[2] / sum(class_bal_table)

#------------------------------------------------------------
#             Create ML Model
#------------------------------------------------------------

tb_model <- caret::train(stranded_class ~ .,
                         data = train_data,
                         method = 'treebag',
                         verbose = TRUE)

#------------------------------------------------------------
#             Predict ML Model with Test Data
#------------------------------------------------------------
predict <- predict(tb_model, test_data, type="raw")
predict_probs <- predict(tb_model, test_data, type="prob")
predictions <- cbind(predict, predict_probs)

#------------------------------------------------------------
#             Evaluate Confusion Matrix
#------------------------------------------------------------

cm <- caret::confusionMatrix(predictions$predict, 
                             test_data[, names(test_data) %in% c("stranded_class")])


#------------------------------------------------------------
#            Save Model
#------------------------------------------------------------
#Save R Model file
saveRDS(tb_model, file = "Rocker_Deployment_R/tb_model.rds")

# Serialise model
trained_model <- as.raw(serialize(tb_model, connection = NULL))

#------------------------------------------------------------
#            Save Training file names
#------------------------------------------------------------
str(train_data)


