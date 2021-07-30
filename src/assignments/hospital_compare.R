# hospital_compare.R


# Part 1: Plot the 30-day mortality rates for heart attack
HOSPITAL_COMPARE_DATA_PATH <- 'data/hospital-compare/hospital-data.csv'
HOSPITAL_COMPARE_CARE_MEASURES_PATH <- 'data/hospital-compare/outcome-of-care-measures.csv'

outcome <- read.csv(HOSPITAL_COMPARE_CARE_MEASURES_PATH, colClasses = "character")
head(outcome)

# number of cols
ncol(outcome)

# number of rows
nrow(outcome)
outcome[, 11] <- as.numeric(outcome[, 11])
hist(outcome[, 11])



# Part 2: Finding the best hospital in a state

load_data <- function(dir_path) {
    data <- read.csv(dir_path, colClasses = "character")
    data
}

best <- function(state, outcome) {
    ## read outcome daa
    data <- load_data(HOSPITAL_COMPARE_CARE_MEASURES_PATH)
    ## check that state and outcome are valid
    if (!state %in% unique(data$State)) {
        stop('invalid state')
    }
    if (!outcome %in% c('heart attack', 'heart failure', 'pneumonia')) {
        stop('invalid outcome')
    }
    
    # mapping of outcome param <-> outcome column name
    outcome_map <- list('heart attack' = 'Number.of.Patients...Hospital.30.Day.Death..Mortality..Rates.from.Heart.Attack',
                        'heart failure' = 'Number.of.Patients...Hospital.30.Day.Death..Mortality..Rates.from.Heart.Failure',
                        'pneumonia' = 'Number.of.Patients...Hospital.30.Day.Death..Mortality..Rates.from.Pneumonia')
    outcome_col_name <- outcome_map[[outcome]]
    ## Return hospital name in that state with lowest 30-day death rate
    # filter hospitals that belong to state and remove non available records
    hospital_data <- data[data$State == state, ]
    hospital_data <- data[hospital_data[outcome_col_name] != 'Not Available', ]
    # get columns we are interested in
    hospital_data <- hospital_data[, c('Hospital.Name', outcome_col_name)]
    # sort by outcome and hospital name
    hospital_data <- hospital_data[order(hospital_data[ , 2], hospital_data[ , 1] ), ]
    
    return(hospital_data$Hospital.Name[1])
}
best("TX", "heart attack")
# [1] "ALLEGIANCE SPECIALTY HOSPITAL OF KILGORE"


best("TX", "heart failure")
best("MD", "heart attack")

best("NY", "hert attack")
best("BB", "heart attack")
best("MD", "heart attack")
best("MD", "pneumonia")


# Part 3: Ranking hospitals by outcome in a state
rankhospital <- function(state, outcome, num) {
    ## read outcome daa
    data <- load_data(HOSPITAL_COMPARE_CARE_MEASURES_PATH)
    ## check that state and outcome are valid
    if (!state %in% unique(data$State)) {
        stop('invalid state')
    }
    if (!outcome %in% c('heart attack', 'heart failure', 'pneumonia')) {
        stop('invalid outcome')
    }
    
    # mapping of outcome param <-> outcome column name
    outcome_map <- list('heart attack' = 'Number.of.Patients...Hospital.30.Day.Death..Mortality..Rates.from.Heart.Attack',
                        'heart failure' = 'Number.of.Patients...Hospital.30.Day.Death..Mortality..Rates.from.Heart.Failure',
                        'pneumonia' = 'Number.of.Patients...Hospital.30.Day.Death..Mortality..Rates.from.Pneumonia')
    outcome_col_name <- outcome_map[[outcome]]
    ## Return hospital name in that state with lowest 30-day death rate
    # filter hospitals that belong to state and remove non available records
    hospital_data <- data[data$State == state, ]
    hospital_data <- data[hospital_data[outcome_col_name] != 'Not Available', ]
    # get columns we are interested in
    hospital_data <- hospital_data[, c('Hospital.Name', outcome_col_name)]
    # sort by outcome and hospital name
    hospital_data <- hospital_data[order(hospital_data[ , 2], hospital_data[ , 1] ), ]
    
    if (is.numeric(num) & num > nrow(hospital_data)) {
        return(NA)
    }
    
    if (num == 'best') {
        num <- 1
    }
    else if (num == 'worst') {
        num <- nrow(hospital_data)
    }
    return(hospital_data$Hospital.Name[num])
}
rankhospital("MD", "pneumonia", 50000)



# Part 4: Ranking hospitals in all states