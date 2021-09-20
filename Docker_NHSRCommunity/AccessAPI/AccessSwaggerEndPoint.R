# =============================================================================
# R Code Name:          Swagger End Point API Access in R 
# Author:               Gary Hutson - Senior Data Scientist
# Date:                 20/09/2021
# =============================================================================

library(httr)
library(jsonlite)
library(libcurl)
library(rjson)
library(dplyr)
library(data.table)

#-------------------------------------------------------------------------------
# Read in production dataset / live data
#-------------------------------------------------------------------------------

# Scenario - we now our endpoint API set up in docker and running
# Say we want to predict our live patients in hospital
# On the model we trained via ML. This model resides on the image
# of the docker file, so when retraining we would need to rebuild 
#the docker image# this could be put on a task scheduler process, 
#so the ML model kicks in every week / month

jsonify_data <- function(df){
  prod_data <- data.table::fread(df)
  json_new <- toJSON(prod_data)
  results <- list(json=json_new, df=as.data.frame(prod_data))
  return (results)
}


# Return list elements from jsonify function
# df stores the data frame and there is a json object we need to 
# expose to  pass to the next function

json_for_swagger <- jsonify_data("data/production.csv")
prod_data <- json_for_swagger$df
json_for_swagger <- json_for_swagger$json


#-------------------------------------------------------------------------------
# Predict data against Docker Stranded Patient API
#-------------------------------------------------------------------------------
POST_to_API <- function(url, body_JSON){
  
  # Run a post request against API
  results <- httr::POST(url, 
                        body = body_JSON, 
                        httr::content_type("application/json"))
  # Pause to get the request body from the API
  stop_for_status(results)
  
  # Flag an error if request code not equal to 200
  request_body <- content(results, "parsed", "application/json")
  # Send the results back to JSON
  request_json <- toJSON(request_body)
  # Send the results to a data frame
  request_df <- as.data.frame(do.call(rbind, lapply(request_body, as.data.frame)))
  # Return a list of results
  results <- list(httr_results=results, 
                  request_body=request_body, 
                  request_json=request_json,
                  request_df = request_df)
  return (results)
  
}



# Use production data and get predictions 
url <- "http://127.0.0.1/predict"
api_call_results <- POST_to_API(url, json_for_swagger)

# Obtain the probability predictions from the model
df <- api_call_results$request_df
# Bind the predictions on to the production data
prod_data <- prod_data %>% 
  cbind(df) %>% 
  dplyr::mutate(class=ifelse(Stranded > 0.5, 1,0))
# Write out predictions to csv

