# Consume Docker service with CURL request
library(httr)
library(jsonlite)
library(libcurl)
library(rjson)
library(dplyr)
library(data.table)
# Read JSON file
# json <- rjson::fromJSON(file="Prod.json")
# # Convert to data frame
# json_df <- as.data.frame(json)
# write.csv(json_df, file = "json_example.csv")

# Read a data frame and convert to JSON 

production_data <- fread()



# Back to JSON
json_new <- toJSON(json_df, pretty=TRUE, auto_unbox = TRUE)
json_new
url <- "http://127.0.0.1/predict"
results <- httr::POST(url, 
                      body = json_new, 
                      httr::content_type("application/json"))
stop_for_status(results)
request_body <- content(results, "parsed", "application/json")
request_json <- toJSON(request_body)
request_json


