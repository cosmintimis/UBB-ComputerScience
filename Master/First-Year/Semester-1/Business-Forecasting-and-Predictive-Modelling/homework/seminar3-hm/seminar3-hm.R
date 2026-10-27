# Moving Averages Analysis - Romania Hydro Energy Generation
#install.packages("ggplot2")
#install.packages("zoo")
# Load required libraries
library(ggplot2)
library(zoo)  # for rollmean function

# Read the data
hydro_data <- read.csv("/Users/cosmintimis/facultate/master/sem1/forecasting-and-predictive-modeling/romania_hydro_energy_generation.csv", 
                       header = TRUE)


# Display basic information
cat("=== ROMANIA HYDRO ENERGY DATA ===\n")
cat("Time period:", min(hydro_data$Year), "-", max(hydro_data$Year), "\n")
cat("Number of observations:", nrow(hydro_data), "\n\n")

# ============================================================================
# 1. COMPUTE THREE DIFFERENT MOVING AVERAGES
# ============================================================================

# MA 3 - Short-term trend (3-year window)
# Good for: Smoothing out short-term fluctuations
hydro_data$MA_3 <- rollmean(hydro_data$Value, k = 3, fill = NA, align = "center")

# MA 5 - Medium-term trend (5-year window)  
# Good for: Capturing medium-term patterns
hydro_data$MA_5 <- rollmean(hydro_data$Value, k = 5, fill = NA, align = "center")

# MA 7 - Long-term trend (7-year window)
# Good for: Identifying long-term trends
hydro_data$MA_7 <- rollmean(hydro_data$Value, k = 7, fill = NA, align = "center")

# Display the first few rows with moving averages
cat("First 10 rows with moving averages:\n")
print(head(hydro_data[, c("Year", "Value", "MA_3", "MA_5", "MA_7")], 10))

# ============================================================================
# 2. SUMMARY STATISTICS
# ============================================================================

cat("\n=== SUMMARY STATISTICS ===\n")
cat("\nOriginal Value (TWh):\n")
cat("  Min: ", min(hydro_data$Value), "\n")
cat("  Max: ", max(hydro_data$Value), "\n")
cat("  Mean:", mean(hydro_data$Value), "\n")
cat("  SD:  ", sd(hydro_data$Value), "\n")

cat("\n3-Year Moving Average:\n")
cat("  Min: ", min(hydro_data$MA_3, na.rm = TRUE), "\n")
cat("  Max: ", max(hydro_data$MA_3, na.rm = TRUE), "\n")
cat("  Mean:", mean(hydro_data$MA_3, na.rm = TRUE), "\n")

cat("\n5-Year Moving Average:\n")
cat("  Min: ", min(hydro_data$MA_5, na.rm = TRUE), "\n")
cat("  Max: ", max(hydro_data$MA_5, na.rm = TRUE), "\n")
cat("  Mean:", mean(hydro_data$MA_5, na.rm = TRUE), "\n")

cat("\n7-Year Moving Average:\n")
cat("  Min: ", min(hydro_data$MA_7, na.rm = TRUE), "\n")
cat("  Max: ", max(hydro_data$MA_7, na.rm = TRUE), "\n")
cat("  Mean:", mean(hydro_data$MA_7, na.rm = TRUE), "\n")

# ============================================================================
# 3. PLOT: ORIGINAL TIME SERIES + THREE MOVING AVERAGES
# ============================================================================

# Create the plot using ggplot2
p <- ggplot(hydro_data, aes(x = Year)) +
  # Original time series (black line with points)
  geom_line(aes(y = Value, color = "Original"), linewidth = 1) +
  geom_point(aes(y = Value, color = "Original"), size = 2) +
  
  # Moving averages
  geom_line(aes(y = MA_3, color = "MA(3)"), linewidth = 1, linetype = "solid") +
  geom_line(aes(y = MA_5, color = "MA(5)"), linewidth = 1, linetype = "dashed") +
  geom_line(aes(y = MA_7, color = "MA(7)"), linewidth = 1, linetype = "dotted") +
  
  # Labels and theme
  labs(
    title = "Romania Hydro Energy Generation: Moving Averages Comparison",
    subtitle = "Original series with 3-year, 5-year, and 7-year moving averages",
    x = "Year",
    y = "Energy Generation (TWh)",
    color = "Series"
  ) +
  
  # Color scheme
  scale_color_manual(
    values = c(
      "Original" = "#2C3E50",
      "MA(3)" = "#E74C3C",
      "MA(5)" = "#3498DB", 
      "MA(7)" = "#27AE60"
    )
  ) +
  
  # Theme customization
  theme_minimal() +
  theme(
    plot.title = element_text(size = 14, face = "bold", hjust = 0.5),
    plot.subtitle = element_text(size = 10, hjust = 0.5, color = "gray40"),
    legend.position = "bottom",
    legend.title = element_text(face = "bold"),
    panel.grid.minor = element_blank()
  )

# Display the plot
print(p)

# Save the plot
ggsave("romania_hydro_moving_averages.png", plot = p, 
       width = 10, height = 6, dpi = 300)
cat("\nPlot saved as: romania_hydro_moving_averages.png\n")
#getwd()
# ============================================================================
# 4. OBSERVATIONS AND ANALYSIS
# ============================================================================

cat("\n=== OBSERVATIONS ===\n\n")

cat("1. SMOOTHING EFFECT:\n")
cat("   - MA(3) follows the original series closely but smooths short-term fluctuations\n")
cat("   - MA(5) shows clearer medium-term patterns\n")
cat("   - MA(7) reveals the long-term trend with minimal fluctuations\n\n")

cat("2. VARIABILITY REDUCTION:\n")
cat("   - Original SD:", round(sd(hydro_data$Value), 2), "TWh\n")
cat("   - MA(3) SD:   ", round(sd(hydro_data$MA_3, na.rm = TRUE), 2), "TWh\n")
cat("   - MA(5) SD:   ", round(sd(hydro_data$MA_5, na.rm = TRUE), 2), "TWh\n")
cat("   - MA(7) SD:   ", round(sd(hydro_data$MA_7, na.rm = TRUE), 2), "TWh\n")
cat("   → Longer windows reduce variability more\n\n")

cat("3. LAG EFFECT:\n")
cat("   - All moving averages lag behind sudden changes in the original series\n")
cat("   - Longer windows create more lag\n\n")

cat("4. EDGE EFFECTS:\n")
cat("   - MA values are NA at the beginning and end of the series\n")
cat("   - More NA values for longer windows (using center alignment)\n\n")

# ============================================================================
# 5. ADDITIONAL PLOT: Residuals
# ============================================================================

# Calculate residuals (difference from MA(5))
hydro_data$Residuals_MA5 <- hydro_data$Value - hydro_data$MA_5

# Plot residuals
p_residuals <- ggplot(hydro_data, aes(x = Year, y = Residuals_MA5)) +
  geom_line(color = "#E74C3C", linewidth = 1) +
  geom_point(color = "#E74C3C", size = 2) +
  geom_hline(yintercept = 0, linetype = "dashed", color = "gray50") +
  labs(
    title = "Residuals: Original - MA(5)",
    subtitle = "Deviations from the 5-year moving average trend",
    x = "Year",
    y = "Residual (TWh)"
  ) +
  theme_minimal() +
  theme(
    plot.title = element_text(size = 14, face = "bold", hjust = 0.5),
    plot.subtitle = element_text(size = 10, hjust = 0.5, color = "gray40")
  )

print(p_residuals)

ggsave("romania_hydro_residuals_ma5.png", plot = p_residuals,
       width = 10, height = 6, dpi = 300)

cat("\nResiduals plot saved as: romania_hydro_residuals_ma5.png\n")

# ============================================================================
# TIME SERIES DECOMPOSITION ANALYSIS
# Dataset: Borsa, Maramures Weather (open-meteo-borsa-mm.csv)
# ============================================================================

install.packages(c("dplyr", "lubridate", "ggplot2", "forecast", "ggfortify"))

library(dplyr)
library(lubridate)
library(ggplot2)
library(forecast)    # For decomposition and ACF plots
library(ggfortify)   # For plotting ts objects

cat("=== LIBRARIES LOADED ===\n\n")

# ============================================================================
# 1. LOAD AND AGGREGATE DATA
# ============================================================================
file_path <- "/Users/cosmintimis/facultate/master/sem1/forecasting-and-predictive-modeling/open-meteo-borsa-mm.csv"

# Load data
tryCatch({
  weather_data <- read.csv(file_path, header = TRUE, check.names = FALSE)
}, error = function(e) {
  cat(paste("Error loading file:", e$message, "\n"))
  cat("Please update the 'file_path' variable in this script.\n")
  stop()
})

# Convert time column to datetime
weather_data$time <- as.POSIXct(weather_data$time, format="%Y-%m-%dT%H:%M", tz="UTC")
cat("--- User code applied: Converted 'time' column to POSIXct. ---\n\n")

print("Original column names:")
print(colnames(weather_data))

colnames(weather_data) <- c("time", "temperature_2m", "snowfall", "rain")

print("New column names (after renaming):")
print(colnames(weather_data))
cat("\n")


# Aggregate HOURLY data to MONTHLY averages
cat("Aggregating hourly data to monthly averages...\n")
monthly_temp <- weather_data %>%
  mutate(Month = floor_date(time, unit = "month")) %>%

  filter(!is.na(Month)) %>%
  
  # Group by this new 'Month'
  group_by(Month) %>%

  summarise(AvgTemp = mean(temperature_2m, na.rm = TRUE)) %>%
  
  # Remove any potential duplicate month entries (e.g., from clock changes)
  distinct()

# FIX 3: Add step to filter out NA/NaN values before creating the ts object
cat("Checking for NA/NaN values in aggregated data...\n")
rows_before <- nrow(monthly_temp)
monthly_temp <- monthly_temp %>%
  filter(!is.na(AvgTemp) & !is.nan(AvgTemp))
rows_after <- nrow(monthly_temp)

if (rows_before > rows_after) {
  cat(paste("Removed", rows_before - rows_after, "months with NA/NaN average temps.\n"))
}

cat("Aggregation complete. First 6 months of data:\n")
print(head(monthly_temp))
cat("\n")

# ============================================================================
# 2. CREATE TIME SERIES (ts) OBJECT
# ============================================================================

# Find the start year and month from the aggregated data
start_date <- min(monthly_temp$Month)
start_year <- year(start_date)
start_month <- month(start_date)

# Create the ts object with a frequency of 12 (for monthly data)
temp_ts <- ts(monthly_temp$AvgTemp, 
              start = c(start_year, start_month), 
              frequency = 12)

cat(paste("Time series object created.\nStart Date:", start_date, "\nFrequency: 12\n\n"))

# Plot the raw monthly time series to visualize
p_raw <- autoplot(temp_ts) +
  labs(title = "Monthly Average Temperature in Borsa, Maramures",
       y = "Temperature (°C)",
       x = "Year") +
  theme_minimal()

print(p_raw)
cat("--- Raw time series plot generated. ---\n\n")


# ============================================================================
# 3. CLASSICAL DECOMPOSITION
# ============================================================================
cat("--- Performing Classical (Additive) Decomposition... ---\n")

# We use an "additive" model because temperature doesn't grow multiplicatively
classical_decomp <- decompose(temp_ts, type = "additive")

# Plot the classical decomposition
p_classical <- autoplot(classical_decomp) +
  labs(title = "Classical Additive Decomposition") +
  theme_minimal()
print(p_classical)
cat("Classical decomposition plot generated.\n")

# Check autocorrelation in the error term
cat("Checking residuals for Classical Decomposition:\n")
p_acf_classical <- ggAcf(classical_decomp$random, na.action = na.pass) +
  labs(title = "ACF of Residuals (Classical Decomposition)")
print(p_acf_classical)

# Ljung-Box test:
# H0: The data is independently distributed (i.e., residuals are white noise)
# p-value < 0.05 suggests significant autocorrelation remains.
classical_test <- Box.test(classical_decomp$random, lag = 24, type = "Ljung-Box", fitdf = 0)
cat("Ljung-Box Test (Classical):\n")
print(classical_test)
cat("\n")


# ============================================================================
# 4. STL DECOMPOSITION
# ============================================================================

# --- STL Model 1: Periodic (Default) ---
cat("--- Performing STL Decomposition (Model 1: s.window = 'periodic')... ---\n")
stl_model_1 <- stl(temp_ts, s.window = "periodic")

# Plot
p_stl_1 <- autoplot(stl_model_1) + 
  labs(title = "STL Decomposition (s.window = 'periodic')")
print(p_stl_1)

# Check residuals
p_acf_stl_1 <- ggAcf(stl_model_1$time.series[, "remainder"]) +
  labs(title = "ACF of Residuals (STL Model 1)")
print(p_acf_stl_1)

stl_test_1 <- Box.test(stl_model_1$time.series[, "remainder"], lag = 24, type = "Ljung-Box", fitdf = 0)
cat("Ljung-Box Test (STL Model 1):\n")
print(stl_test_1)
cat("\n")


# --- STL Model 2: Smoother Trend ---
cat("--- Performing STL Decomposition (Model 2: s.window = 13, t.window = 25)... ---\n")
# s.window=13 (13 months) -> smooth seasonal component
# t.window=25 (25 months) -> smooth trend component
stl_model_2 <- stl(temp_ts, s.window = 13, t.window = 25)

# Plot
p_stl_2 <- autoplot(stl_model_2) + 
  labs(title = "STL Decomposition (s.window = 13, t.window = 25)")
print(p_stl_2)

# Check residuals
p_acf_stl_2 <- ggAcf(stl_model_2$time.series[, "remainder"]) +
  labs(title = "ACF of Residuals (STL Model 2)")
print(p_acf_stl_2)

stl_test_2 <- Box.test(stl_model_2$time.series[, "remainder"], lag = 24, type = "Ljung-Box", fitdf = 0)
cat("Ljung-Box Test (STL Model 2):\n")
print(stl_test_2)
cat("\n")


# --- STL Model 3: More Flexible Seasonality ---
cat("--- Performing STL Decomposition (Model 3: s.window = 7, t.window = 15)... ---\n")
# s.window=7 -> more flexible seasonal component
# t.window=15 -> more flexible trend component
stl_model_3 <- stl(temp_ts, s.window = 7, t.window = 15)

# Plot
p_stl_3 <- autoplot(stl_model_3) + 
  labs(title = "STL Decomposition (s.window = 7, t.window = 15)")
print(p_stl_3)

# Check residuals
p_acf_stl_3 <- ggAcf(stl_model_3$time.series[, "remainder"]) +
  labs(title = "ACF of Residuals (STL Model 3)")
print(p_acf_stl_3)

stl_test_3 <- Box.test(stl_model_3$time.series[, "remainder"], lag = 24, type = "Ljung-Box", fitdf = 0)
cat("Ljung-Box Test (STL Model 3):\n")
print(stl_test_3)
cat("\n")


# ============================================================================
# 5. FINAL COMPARISON
# ============================================================================
cat("=== FINAL Ljung-Box Test p-values (higher is better) ===\n")
cat(paste("Classical Model: p-value =", classical_test$p.value, "\n"))
cat(paste("STL Model 1 (periodic): p-value =", stl_test_1$p.value, "\n"))
cat(paste("STL Model 2 (s=13, t=25): p-value =", stl_test_2$p.value, "\n"))
cat(paste("STL Model 3 (s=7, t=15): p-value =", stl_test_3$p.value, "\n"))
cat("\n=== ANALYSIS COMPLETE ===\n")


# ============================================================================
# TIME SERIES FEATURE ANALYSIS
# Dataset: NVIDIA Stock Data (nvidia-stock.csv)
# ============================================================================

# --- 0. LOAD REQUIRED LIBRARIES ---
 install.packages(c("dplyr", "lubridate", "forecast"))

library(dplyr)
library(lubridate)
library(forecast)    # For acf, stl, etc.

cat("=== LIBRARIES LOADED ===\n\n")

# ============================================================================
# 1. LOAD AND PREPARE DATA
# ============================================================================

# --- User's Data Loading Code ---
file_path <- "/Users/cosmintimis/facultate/master/sem1/forecasting-and-predictive-modeling/nvidia-stock.csv"

nvidia_data <- read.csv(file_path, 
                        header = TRUE,
                        check.names = FALSE) 

# Check structure
cat("\n=== NVIDIA Data Structure ===\n")
print(head(nvidia_data))
print(colnames(nvidia_data))

# Convert Date column
nvidia_data$Date <- as.Date(nvidia_data$Date, format="%Y-%m-%d")

# Check conversion
cat("\nDate range:\n")
print(range(nvidia_data$Date, na.rm = TRUE))

# Check for missing values
cat("\nMissing values:\n")
print(colSums(is.na(nvidia_data)))
cat("\n")
# --- End of User Code ---


# ============================================================================
# 2. CREATE TIME SERIES (ts) OBJECTS
# ============================================================================
# We need to define a frequency. For daily stock data, a yearly "seasonal"
# pattern is the most likely, so we use the approx. number of trading days.
TRADING_DAYS_PER_YEAR <- 252

# Find the start date components
start_date_obj <- min(nvidia_data$Date, na.rm = TRUE)
start_year <- year(start_date_obj)
# We use 'yday' (day of the year) for the start 'day'
start_yday <- yday(start_date_obj)

# Create 5 ts objects
open_ts <- ts(nvidia_data$Open, 
              start = c(start_year, start_yday), 
              frequency = TRADING_DAYS_PER_YEAR)

high_ts <- ts(nvidia_data$High, 
              start = c(start_year, start_yday), 
              frequency = TRADING_DAYS_PER_YEAR)

low_ts <- ts(nvidia_data$Low, 
             start = c(start_year, start_yday), 
             frequency = TRADING_DAYS_PER_YEAR)

close_ts <- ts(nvidia_data$Close, 
               start = c(start_year, start_yday), 
               frequency = TRADING_DAYS_PER_YEAR)

volume_ts <- ts(nvidia_data$Volume, 
                start = c(start_year, start_yday), 
                frequency = TRADING_DAYS_PER_YEAR)

cat(paste("--- 5 'ts' objects created with frequency =", TRADING_DAYS_PER_YEAR, "---\n\n"))


# ============================================================================
# 3. HELPER FUNCTION TO CALCULATE FEATURES
# ============================================================================

calculate_features <- function(series) {
  # 1. Autocorrelation at lag 1
  acf1 <- acf(series, lag.max = 1, plot = FALSE, na.action = na.pass)$acf[2]
  
  # 2. Sum of squares of autocorrelations (first 10 lags)
  sum_sq_acf10 <- sum(acf(series, lag.max = 10, plot = FALSE, na.action = na.pass)$acf[2:11]^2)
  
  # 3. Autocorrelation at lag 1 of the differenced time series
  #    We difference the series (lag 1) and then get its ACF at lag 1
  diff_series <- diff(series, lag = 1)
  diff_acf1 <- acf(diff_series, lag.max = 1, plot = FALSE, na.action = na.pass)$acf[2]
  
  # 4. & 5. Trend and Seasonal Strength
  # We use STL decomposition to find these.
  # s.window="periodic" forces it to use the defined frequency (252)
  
  # Use tryCatch in case STL fails (e.g., on data with many zeros)
  stl_decomp <- tryCatch({
    stl(series, s.window = "periodic", robust = TRUE)
  }, error = function(e) {
    cat(paste("STL decomposition failed:", e$message, "\n"))
    return(NULL)
  })
  
  if (!is.null(stl_decomp)) {
    # Extract components
    remainder <- stl_decomp$time.series[, "remainder"]
    trend <- stl_decomp$time.series[, "trend"]
    seasonal <- stl_decomp$time.series[, "seasonal"]
    
    # Calculate strengths (variance-based formula)
    var_rem <- var(remainder, na.rm = TRUE)
    
    trend_strength <- max(0, 1 - (var_rem / var(trend + remainder, na.rm = TRUE)))
    seasonal_strength <- max(0, 1 - (var_rem / var(seasonal + remainder, na.rm = TRUE)))
    
  } else {
    # Return NA if STL failed
    trend_strength <- NA
    seasonal_strength <- NA
  }
  
  # Return all 5 features as a named vector
  return(c(
    ACF1 = acf1,
    Sum_Sq_ACF10 = sum_sq_acf10,
    Diff_ACF1 = diff_acf1,
    Trend_Strength = trend_strength,
    Seasonal_Strength = seasonal_strength
  ))
}

cat("--- Feature calculation function defined. ---\n\n")

# ============================================================================
# 4. CALCULATE FEATURES FOR ALL 5 SERIES
# ============================================================================
cat("--- Calculating features for each time series... ---\n")

features_open <- calculate_features(open_ts)
features_high <- calculate_features(high_ts)
features_low <- calculate_features(low_ts)
features_close <- calculate_features(close_ts)
features_volume <- calculate_features(volume_ts)

cat("--- Calculations complete. ---\n\n")

# ============================================================================
# 5. COMBINE AND DISPLAY RESULTS
# ============================================================================

# Combine into a single data frame
feature_table <- rbind(
  Open = features_open,
  High = features_high,
  Low = features_low,
  Close = features_close,
  Volume = features_volume
)

cat("=== FINAL FEATURE COMPARISON TABLE ===\n")
print(round(feature_table, 4))
cat("\n")

cat(paste("Strongest Autocorrelation (Sum_Sq_ACF10):", 
          rownames(feature_table)[which.max(feature_table[, "Sum_Sq_ACF10"])], "\n"))

cat(paste("Strongest Trend (Trend_Strength):", 
          rownames(feature_table)[which.max(feature_table[, "Trend_Strength"])], "\n"))

cat(paste("Strongest Seasonality (Seasonal_Strength):", 
          rownames(feature_table)[which.max(feature_table[, "Seasonal_Strength"])], "\n"))

cat("\n=== ANALYSIS COMPLETE ===\n")