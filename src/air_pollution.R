# air_pollution.R

sample <- read.csv('data/specdata/002.csv')
AIR_POLLUTION_DATA_DIR_PATH <- 'data/specdata/'



# function to load the data
load_data <- function(dir_path, id) {
    # get the file paths to load
    selected_monitor_data <- list.files(dir_path, full.names = TRUE)[id]
    
    # load and stack
    stack <- data.frame()
    for (file_path in selected_monitor_data) {
        chunk <- read.csv(file_path)
        stack <- rbind.data.frame(stack, chunk)
    }
    return(stack)
}


pollutant_mean <- function(dir_path, pollutant, id=1:332) {
    # return the mean of the pollutant across all monitors
    # list in the 'id' vector (ignoring NA values)
    # result not rounded
    
    # get the file paths to load
    data <- load_data(dir_path, id)
    mean(data[[pollutant]], na.rm=TRUE)
}

pollutant_mean(AIR_POLLUTION_DATA_DIR_PATH, 'nitrate', id=70:72)


complete_observations <- function(dir_path, id=1:332) {
    # return a data frame of the form:
    # id   n_obs
    #  1     117
    #  2    1041
    # where 'id'  is the monitor id number and 'n_obs'
    # is the number of complete cases

    data <- load_data(dir_path, id)
    complete_data <- data[!is.na(data$sulfate) & !is.na(data$nitrate), ]
    
    freq_table <- table(complete_data$ID) |>
        data.frame()
    
    colnames(freq_table) <- c('id', 'n_obs')
    return(freq_table)
}

complete_observations(AIR_POLLUTION_DATA_DIR_PATH, 3)

