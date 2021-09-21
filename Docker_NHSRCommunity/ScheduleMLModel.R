#-------------------------------------------------------------------------------
#             Schedule our ML model to run weekly
#-------------------------------------------------------------------------------

library(taskscheduleR)
# https://cran.r-project.org/web/packages/taskscheduleR/vignettes/taskscheduleR.html
script_to_schedule <- system.file("extdata", "MLModelTrainingScript.R", 
                                  package="taskscheduleR")
## Run every week on Saturday and Sunday at 09:10
taskscheduler_create(taskname = "stranded_script_nightly", rscript = script_to_schedule, 
                     schedule = "WEEKLY", starttime = "12:01", days = c("TUE"))

# Get a list of all the scheduled tasks
tasks <- taskscheduleR::taskscheduler_ls()
# Once triggered Windows will have a task created in Windows Scheduler
print(tasks)
# # Kill the task
# taskscheduler_delete(taskname = "stranded_script_nightly")