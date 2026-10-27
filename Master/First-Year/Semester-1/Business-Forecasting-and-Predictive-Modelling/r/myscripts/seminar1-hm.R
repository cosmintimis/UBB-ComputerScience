library(dplyr)

# Read data
df <- read.csv('europe_yearly_full_release_long_format.csv')

# Filter: Romania + Hydro + TWh only (removes %)
romania_hydro <- df %>%
  filter(ISO.3.code == 'ROU',
         Category == 'Electricity generation',
         Variable == 'Hydro',
         Unit == 'TWh')  # This removes percentage rows

romania_hydro <- romania_hydro %>%
  select(Year, Value, Unit)

# View the data
print(romania_hydro)

# Check for missing values
sum(is.na(romania_hydro$Value))

# Save clean data
write.csv(romania_hydro, 'romania_hydro_generation.csv', row.names = FALSE)


# Read CSV
nvidia <- read.csv('NVDA.csv')

# Remove Adj Close column
nvidia <- nvidia[, -which(names(nvidia) == "Adj.Close")]

# View result
head(nvidia)

# Save cleaned data
write.csv(nvidia, 'nvidia_clean.csv', row.names = FALSE)


weather_data <- read.csv("open-meteo-borsa-mm.csv", header = TRUE)

# Display structure
cat("=== WEATHER DATA ANALYSIS ===\n\n")
cat("Structure of the dataset:\n")
str(weather_data)

# Frequency
cat("\n--- FREQUENCY ---\n")
cat("Hourly\n")

# Number of observations
cat("\n--- NUMBER OF OBSERVATIONS ---\n")
n_obs <- nrow(weather_data)
cat(n_obs, "observations\n")

# Number of attributes and their names
cat("\n--- ATTRIBUTES ---\n")
n_attr <- ncol(weather_data)
cat("Number of attributes:", n_attr, "\n")
cat("Attribute names:\n")
print(names(weather_data))

# Check for missing data
cat("\n--- MISSING DATA ---\n")
missing_count <- colSums(is.na(weather_data))
if (sum(missing_count) == 0) {
  cat("No missing data\n")
} else {
  for (col in names(missing_count)) {
    if (missing_count[col] > 0) {
      cat(col, ":", missing_count[col], "missing values\n")
    }
  }
}

# Summary statistics for numeric attributes
cat("\n--- SUMMARY STATISTICS ---\n")
numeric_cols <- sapply(weather_data, is.numeric)
for (col in names(weather_data)[numeric_cols]) {
  cat("\n", col, ":\n", sep = "")
  cat("  Min:  ", min(weather_data[[col]], na.rm = TRUE), "\n")
  cat("  Max:  ", max(weather_data[[col]], na.rm = TRUE), "\n")
  cat("  Mean: ", mean(weather_data[[col]], na.rm = TRUE), "\n")
}

# Display first few rows
cat("\n--- FIRST FEW ROWS ---\n")
print(head(weather_data))

stock_data <- read.csv("nvidia-stock.csv", header = TRUE)

# Display structure
cat("=== NVIDIA STOCK DATA ANALYSIS ===\n\n")
cat("Structure of the dataset:\n")
str(stock_data)

# Frequency
cat("\n--- FREQUENCY ---\n")
cat("Daily\n")

# Number of observations
cat("\n--- NUMBER OF OBSERVATIONS ---\n")
n_obs <- nrow(stock_data)
cat(n_obs, "observations\n")

# Number of attributes and their names
cat("\n--- ATTRIBUTES ---\n")
n_attr <- ncol(stock_data)
cat("Number of attributes:", n_attr, "\n")
cat("Attribute names:\n")
print(names(stock_data))

# Check for missing data
cat("\n--- MISSING DATA ---\n")
missing_count <- colSums(is.na(stock_data))
if (sum(missing_count) == 0) {
  cat("No missing data\n")
} else {
  for (col in names(missing_count)) {
    if (missing_count[col] > 0) {
      cat(col, ":", missing_count[col], "missing values\n")
    }
  }
}

# Summary statistics for numeric attributes
cat("\n--- SUMMARY STATISTICS ---\n")
numeric_cols <- sapply(stock_data, is.numeric)
for (col in names(stock_data)[numeric_cols]) {
  cat("\n", col, ":\n", sep = "")
  cat("  Min:  ", min(stock_data[[col]], na.rm = TRUE), "\n")
  cat("  Max:  ", max(stock_data[[col]], na.rm = TRUE), "\n")
  cat("  Mean: ", mean(stock_data[[col]], na.rm = TRUE), "\n")
}

# Display first few rows
cat("\n--- FIRST FEW ROWS ---\n")
print(head(stock_data))



# Load the data
energy_data <- read.csv("romania_hydro_energy_generation.csv", header = TRUE)

# Display structure
cat("=== ROMANIA HYDRO ENERGY DATA ANALYSIS ===\n\n")
cat("Structure of the dataset:\n")
str(energy_data)

# Frequency
cat("\n--- FREQUENCY ---\n")
cat("Yearly\n")

# Number of observations
cat("\n--- NUMBER OF OBSERVATIONS ---\n")
n_obs <- nrow(energy_data)
cat(n_obs, "observations\n")

# Number of attributes and their names
cat("\n--- ATTRIBUTES ---\n")
n_attr <- ncol(energy_data)
cat("Number of attributes:", n_attr, "\n")
cat("Attribute names:\n")
print(names(energy_data))

# Check for missing data
cat("\n--- MISSING DATA ---\n")
missing_count <- colSums(is.na(energy_data))
if (sum(missing_count) == 0) {
  cat("No missing data\n")
} else {
  for (col in names(missing_count)) {
    if (missing_count[col] > 0) {
      cat(col, ":", missing_count[col], "missing values\n")
    }
  }
}

# Summary statistics for numeric attributes
cat("\n--- SUMMARY STATISTICS ---\n")
numeric_cols <- sapply(energy_data, is.numeric)
for (col in names(energy_data)[numeric_cols]) {
  cat("\n", col, ":\n", sep = "")
  cat("  Min:  ", min(energy_data[[col]], na.rm = TRUE), "\n")
  cat("  Max:  ", max(energy_data[[col]], na.rm = TRUE), "\n")
  cat("  Mean: ", mean(energy_data[[col]], na.rm = TRUE), "\n")
}

# Display first few rows
cat("\n--- FIRST FEW ROWS ---\n")
print(head(energy_data))

# Display year range
cat("\n--- YEAR RANGE ---\n")
cat("From:", min(energy_data$Year), "\n")
cat("To:  ", max(energy_data$Year), "\n")


# Calculate exact number of missing dates in stock data

stock_data <- read.csv("nvidia-stock.csv", header = TRUE)
stock_data$Date <- as.Date(stock_data$Date)

min_date <- min(stock_data$Date)
max_date <- max(stock_data$Date)

total_calendar_days <- as.numeric(max_date - min_date) + 1
missing_dates <- total_calendar_days - nrow(stock_data)

cat("Missing calendar dates:", missing_dates, "\n")


# Check for missing years in Romania hydro energy data

energy_data <- read.csv("/romania_hydro_energy_generation.csv", header = TRUE)

cat("=== MISSING YEARS ANALYSIS ===\n\n")

# Get year range
min_year <- min(energy_data$Year)
max_year <- max(energy_data$Year)

cat("Year range:\n")
cat("  From:", min_year, "\n")
cat("  To:  ", max_year, "\n\n")

# Expected number of years
expected_years <- max_year - min_year + 1
actual_years <- nrow(energy_data)

cat("Expected years:", expected_years, "\n")
cat("Actual observations:", actual_years, "\n")

# Create sequence of all years that should exist
all_years <- seq(min_year, max_year, by = 1)
missing_years <- all_years[!all_years %in% energy_data$Year]

if (length(missing_years) == 0) {
  cat("\nNo missing years - all years from", min_year, "to", max_year, "are present!\n")
} else {
  cat("\nMissing years:", length(missing_years), "\n")
  cat("Missing year(s):", paste(missing_years, collapse = ", "), "\n")
}


# Load fresh data
weather_data <- read.csv("/Users/cosmintimis/facultate/master/sem1/forecasting-and-predictive-modeling/open-meteo-borsa-mm.csv", header = TRUE)

print("=== MISSING HOURS ANALYSIS ===")
print("")

# Parse the time column
weather_data$parsed_time <- as.POSIXct(weather_data$time, format="%Y-%m-%dT%H:%M")

# Get time range
min_time <- min(weather_data$parsed_time, na.rm = TRUE)
max_time <- max(weather_data$parsed_time, na.rm = TRUE)

print("Time range:")
print(paste("From:", as.character(min_time)))
print(paste("To:", as.character(max_time)))
print("")

# Calculate expected number of hours
time_diff_hours <- as.numeric(difftime(max_time, min_time, units = "hours")) + 1
actual_observations <- nrow(weather_data)

print(paste("Expected hourly observations:", time_diff_hours))
print(paste("Actual observations:", actual_observations))
print("")

missing_hours <- time_diff_hours - actual_observations
print(paste("Missing hours:", missing_hours))
print("")

if (missing_hours == 0) {
  print("✓ SUCCESS: No missing hours - complete hourly sequence!")
} else {
  print(paste("✗ WARNING:", missing_hours, "hours are missing from the sequence"))
  
  # Find which hours are missing
  all_hours <- seq(min_time, max_time, by = "hour")
  missing_timestamps <- all_hours[!all_hours %in% weather_data$parsed_time]
  
  if (length(missing_timestamps) <= 50) {
    print("")
    print("Missing timestamps:")
    print(missing_timestamps)
  } else {
    print("")
    print("First 20 missing timestamps:")
    print(head(missing_timestamps, 20))
    print(paste("... and", length(missing_timestamps) - 20, "more"))
  }
}
