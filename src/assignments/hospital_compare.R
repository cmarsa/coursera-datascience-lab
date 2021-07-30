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
    ## read outcome data
    data <- load_data(HOSPITAL_COMPARE_CARE_MEASURES_PATH)
    ## check that state and outcome are valid
    if (!state %in% unique(data$State)) {
        stop('invalid state')
    }
    if (!outcome %in% c('heart attack', 'heart failure', 'pneumonia')) {
        stop('invalid outcome')
    }
    
    # mapping of outcome param <-> outcome column name
    outcome_map <- list('heart attack' = 'Hospital.30.Day.Death..Mortality..Rates.from.Heart.Attack',
                        'heart failure' = 'Hospital.30.Day.Death..Mortality..Rates.from.Heart.Failure',
                        'pneumonia' = 'Hospital.30.Day.Death..Mortality..Rates.from.Pneumonia')
    outcome_col_name <- outcome_map[[outcome]]
    data[, outcome_col_name] <- as.numeric(data[, outcome_col_name])
    ## Return hospital name in that state with lowest 30-day death rate
    # filter hospitals that belong to state and remove non available records
    hospital_data <- data[data$State == state, ]
    hospital_data <- hospital_data[hospital_data[outcome_col_name] != 'Not Available', ]
    # get columns we are interested in
    hospital_data <- hospital_data[, c('Hospital.Name', outcome_col_name)]
    # sort by outcome and hospital name
    hospital_data <- hospital_data[with(hospital_data, order(hospital_data[, 2], hospital_data[, 1])), ]
    
    return(hospital_data$Hospital.Name[1])
}
best("MD", "heart attack")
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
    outcome_map <- list('heart attack' = 'Hospital.30.Day.Death..Mortality..Rates.from.Heart.Attack',
                        'heart failure' = 'Hospital.30.Day.Death..Mortality..Rates.from.Heart.Failure',
                        'pneumonia' = 'Hospital.30.Day.Death..Mortality..Rates.from.Pneumonia')
    outcome_col_name <- outcome_map[[outcome]]
    data[, outcome_col_name] <- as.numeric(data[, outcome_col_name])
    data <- data[!is.na(data[, outcome_col_name]), ]
    ## Return hospital name in that state with lowest 30-day death rate
    # filter hospitals that belong to state and remove non available records
    hospital_data <- data[data$State == state, ]
    hospital_data <- hospital_data[hospital_data[outcome_col_name] != 'Not Available', ]
    # get columns we are interested in
    hospital_data <- hospital_data[, c('Hospital.Name', outcome_col_name)]
    # sort by outcome and hospital name
    hospital_data <- hospital_data[with(hospital_data, order(hospital_data[,2], hospital_data[,1])), ]
    
    if (is.numeric(num) & num > nrow(hospital_data)) {
        return(NA)
    }
    if (num == 'best') {
        num_for_state <- 1
    }
    else if (num == 'worst') {
        num_for_state <- nrow(state_data)
    }
    else {
        num_for_state <- num
    }
    
    return(hospital_data$Hospital.Name[num_for_state])
}
rankhospital("TX", "heart failure", 4)
rankhospital("MD", "heart attack", "worst")
rankhospital("MN", "heart attack", 5000)



# Part 4: Ranking hospitals in all states
rankall <- function(outcome, num='best') {
    ## read outcome data
    data <- load_data(HOSPITAL_COMPARE_CARE_MEASURES_PATH)
    
    ## check the state and outcome are valid
    if (!outcome %in% c('heart attack', 'heart failure', 'pneumonia')) {
        stop('invalid outcome')
    }
    
    # mapping of outcome param <-> outcome column name
    outcome_map <- list('heart attack' = 'Hospital.30.Day.Death..Mortality..Rates.from.Heart.Attack',
                        'heart failure' = 'Hospital.30.Day.Death..Mortality..Rates.from.Heart.Failure',
                        'pneumonia' = 'Hospital.30.Day.Death..Mortality..Rates.from.Pneumonia')
    outcome_col_name <- outcome_map[[outcome]]
    data[, outcome_col_name] <- as.numeric(data[, outcome_col_name])
    data <- data[!is.na(data[, outcome_col_name]), ]
    ## for each state, find the hospital of given rank
    all_states_hosp <- data.frame()
    for (state in unique(data$State)) {
        state_data <- data[data$State == state, ]
        state_data <- state_data[state_data[outcome_col_name] != 'Not Available', ]  # remove non-valid records
        state_data <- state_data[, c('State', 'Hospital.Name', outcome_col_name)] 
        state_data <- state_data[with(state_data, order(state_data[,3], state_data[,2])), ]
        
        # if the number/Rank is not valid for that state, return NA
        if (is.numeric(num) & num > nrow(state_data)) {
            state_data$Hospital.Name <- NA
            state_data$State <- state
            all_states_hosp <- rbind.data.frame(all_states_hosp, state_data[1, ])
            next
        }
        # specify number-rank to retrieve from the state
        if (num == 'best') {
            num_for_state <- 1
        }
        else if (num == 'worst') {
            num_for_state <- nrow(state_data)
        }
        else {
            num_for_state <- num
        }
        
        state_data <- state_data[num_for_state, ]
        all_states_hosp <- rbind.data.frame(all_states_hosp, state_data)
    }
    ## return a dataframe with the hospital names and the
    ## abbreviated state name
    all_states_hosp <- all_states_hosp[with(all_states_hosp, order(State)), ]
    return(all_states_hosp[, c(1, 2)])
}
head(rankall("heart attack", 20), 10)
tail(rankall("pneumonia", "worst"), 3)
tail(rankall("heart failure"), 10)



# quiz
best("SC", "heart attack")
best("NY", "pneumonia")
best("AK", "pneumonia")
rankhospital("NC", "heart attack", "worst")
rankhospital("WA", "heart attack", 7)
rankhospital("TX", "pneumonia", 10)
rankhospital("NY", "heart attack", 7)

r <- rankall("heart attack", 4)
as.character(subset(r, State == "HI")$Hospital.Name)

r <- rankall("pneumonia", "worst")
as.character(subset(r, State == "NJ")$Hospital.Name)


r <- rankall("heart failure", 10)
as.character(subset(r, State == "NV")$Hospital.Name)

