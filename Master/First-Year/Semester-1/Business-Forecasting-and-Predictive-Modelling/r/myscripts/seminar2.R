# ============================================
# TIME SERIES ANALYSIS: BORSA TEMPERATURE
# ============================================

# Load required libraries
library(ggplot2)      # For plotting
library(forecast)     # For time series analysis
library(tseries)      # For KPSS test
library(lubridate)    # For date handling
library(gridExtra)    # For arranging plots
library(dplyr)        # For data manipulation
library(zoo)

# If you don't have these packages, install them:
# install.packages(c("ggplot2", "forecast", "tseries", "lubridate", "gridExtra", "dplyr"))

# ============================================
# 1. READ AND PREPARE DATA
# ============================================

weather_data <- read.csv("/Users/cosmintimis/facultate/master/sem1/forecasting-and-predictive-modeling/open-meteo-borsa-mm.csv", 
                         header = TRUE,
                         check.names = FALSE)  # Keep original column names

# Check what the actual column names are
print("Original column names:")
print(colnames(weather_data))

# Rename columns to simpler names (remove units and special characters)
colnames(weather_data) <- c("time", "temperature_2m", "snowfall", "rain")

# Verify new column names
print("New column names:")
print(colnames(weather_data))

# View first few rows
head(weather_data)
str(weather_data)

# Convert time column to datetime
weather_data$time <- as.POSIXct(weather_data$time, format="%Y-%m-%dT%H:%M", tz="UTC")


# Extract additional time features
weather_data$year <- year(weather_data$time)
weather_data$month <- month(weather_data$time)
weather_data$day <- day(weather_data$time)
weather_data$hour <- hour(weather_data$time)
weather_data$day_of_year <- yday(weather_data$time)

# Check for missing values
summary(weather_data)
sum(is.na(weather_data$temperature_2m))

# ============================================
# 2. SIMPLE LINE PLOT - Temperature
# ============================================

# Full time series plot
ggplot(weather_data, aes(x = time, y = temperature_2m)) +
  geom_line(color = "steelblue", size = 0.3) +
  labs(title = "Borsa Temperature - Full Time Series",
       subtitle = "Hourly data from 2003",
       x = "Time",
       y = "Temperature (°C)") +
  theme_minimal() +
  theme(plot.title = element_text(face = "bold", size = 14))

# Save plot
ggsave("01_temperature_full_series.png", width = 12, height = 6)

# Zoom into one year (e.g., 2020) to see patterns better
weather_2020 <- weather_data %>% filter(year == 2020)

ggplot(weather_2020, aes(x = time, y = temperature_2m)) +
  geom_line(color = "darkred", size = 0.5) +
  labs(title = "Borsa Temperature - Year 2020",
       subtitle = "Clear yearly seasonal pattern visible",
       x = "Time",
       y = "Temperature (°C)") +
  theme_minimal()

ggsave("02_temperature_2020.png", width = 12, height = 6)

# Zoom into one month to see daily patterns
weather_jan2020 <- weather_data %>% filter(year == 2020, month == 1)

ggplot(weather_jan2020, aes(x = time, y = temperature_2m)) +
  geom_line(color = "navy", size = 0.7) +
  labs(title = "Borsa Temperature - January 2020",
       subtitle = "Daily patterns (24-hour cycles) visible",
       x = "Time",
       y = "Temperature (°C)") +
  theme_minimal()

ggsave("03_temperature_jan2020.png", width = 12, height = 6)

# ============================================
# OBSERVATIONS FROM LINE PLOTS
# ============================================
# Write your observations:
# - TREND: Look for overall increase/decrease over years
# - SEASONALITY: Clear yearly pattern (summer hot, winter cold)
# - CYCLES: Any irregular multi-year patterns?

# ============================================
# 3. SEASONAL PLOTS
# ============================================

# A) Seasonal plot by MONTH (Yearly seasonality)
ggplot(weather_data, aes(x = month, y = temperature_2m, group = year, color = as.factor(year))) +
  geom_line(alpha = 0.5) +
  scale_x_continuous(breaks = 1:12, labels = month.abb) +
  labs(title = "Seasonal Plot: Temperature by Month",
       subtitle = "Each line represents one year",
       x = "Month",
       y = "Temperature (°C)",
       color = "Year") +
  theme_minimal() +
  theme(legend.position = "none")  # Remove legend if too many years

ggsave("04_seasonal_plot_month.png", width = 12, height = 6)

# B) Seasonal plot by HOUR (Daily seasonality)
# Use one year of data to avoid overplotting
weather_sample <- weather_data %>% filter(year >= 2020, year <= 2022)

ggplot(weather_sample, aes(x = hour, y = temperature_2m, group = as.Date(time), color = month)) +
  geom_line(alpha = 0.3) +
  scale_x_continuous(breaks = seq(0, 23, 3)) +
  labs(title = "Seasonal Plot: Temperature by Hour of Day",
       subtitle = "Each line represents one day (2020-2022)",
       x = "Hour of Day",
       y = "Temperature (°C)",
       color = "Month") +
  theme_minimal()

ggsave("05_seasonal_plot_hour.png", width = 12, height = 6)

# ============================================
# 4. SEASONAL SUBSERIES PLOTS
# ============================================

# A) Subseries by MONTH
monthly_avg <- weather_data %>%
  group_by(year, month) %>%
  summarise(avg_temp = mean(temperature_2m, na.rm = TRUE), .groups = "drop")

ggplot(monthly_avg, aes(x = year, y = avg_temp)) +
  geom_line(color = "steelblue") +
  geom_hline(aes(yintercept = mean(avg_temp)), color = "red", linetype = "dashed") +
  facet_wrap(~month, ncol = 4, labeller = labeller(month = month.abb)) +
  labs(title = "Seasonal Subseries Plot: Temperature by Month",
       subtitle = "Red line shows the mean for each month",
       x = "Year",
       y = "Avg Temperature (°C)") +
  theme_minimal()

ggsave("06_subseries_month.png", width = 12, height = 8)

# B) Subseries by HOUR (using recent data)
hourly_avg <- weather_data %>%
  filter(year >= 2020) %>%
  group_by(month, hour) %>%
  summarise(avg_temp = mean(temperature_2m, na.rm = TRUE), .groups = "drop")

ggplot(hourly_avg, aes(x = hour, y = avg_temp)) +
  geom_line(color = "darkred") +
  geom_hline(aes(yintercept = mean(avg_temp)), color = "blue", linetype = "dashed") +
  facet_wrap(~month, ncol = 4, labeller = labeller(month = month.abb)) +
  scale_x_continuous(breaks = seq(0, 21, 6)) +
  labs(title = "Seasonal Subseries Plot: Temperature by Hour",
       subtitle = "Blue line shows mean for each hour (2020-2024)",
       x = "Hour of Day",
       y = "Avg Temperature (°C)") +
  theme_minimal()

ggsave("07_subseries_hour.png", width = 12, height = 8)

# ============================================
# 5. MULTIVARIATE ANALYSIS (Scatter Plots)
# ============================================

# Select variables: temperature, snowfall, rain
# Create scatter plots between pairs

# First, let's check the data
cat("\n=== Checking rain data ===\n")
cat(paste("Total observations:", nrow(weather_data), "\n"))
cat(paste("Rain values = 0:", sum(weather_data$rain == 0, na.rm = TRUE), "\n"))
cat(paste("Rain values > 0:", sum(weather_data$rain > 0, na.rm = TRUE), "\n"))
cat(paste("Max rain:", max(weather_data$rain, na.rm = TRUE), "mm\n"))
cat(paste("Rain NAs:", sum(is.na(weather_data$rain)), "\n"))

# A) Temperature vs Rain
# Remove NAs and use a sample if too many points
weather_clean <- weather_data %>%
  select(temperature_2m, rain, snowfall) %>%
  na.omit()

cat(paste("\nClean observations:", nrow(weather_clean), "\n"))

# Use a sample if too many points (makes plotting faster)
if (nrow(weather_clean) > 50000) {
  set.seed(123)  # For reproducibility
  weather_plot <- weather_clean %>% sample_n(50000)
  cat("Using 50,000 random samples for plotting\n")
} else {
  weather_plot <- weather_clean
}

# Plot Temperature vs Rain
ggplot(weather_plot, aes(x = rain, y = temperature_2m)) +
  geom_point(alpha = 0.2, color = "steelblue", size = 0.5) +  # Smaller, more transparent
  geom_smooth(method = "lm", color = "red", se = TRUE, linewidth = 1) +
  labs(title = "Temperature vs Rainfall",
       subtitle = paste("Based on", nrow(weather_plot), "observations"),
       x = "Rain (mm)",
       y = "Temperature (°C)") +
  theme_minimal() +
  theme(plot.title = element_text(face = "bold"))

ggsave("08_scatter_temp_rain.png", width = 8, height = 6, dpi = 300)

# B) Temperature vs Snowfall
ggplot(weather_plot, aes(x = snowfall, y = temperature_2m)) +
  geom_point(alpha = 0.2, color = "darkblue", size = 0.5) +
  geom_smooth(method = "lm", color = "red", se = TRUE, linewidth = 1) +
  labs(title = "Temperature vs Snowfall",
       subtitle = paste("Based on", nrow(weather_plot), "observations"),
       x = "Snowfall (cm)",
       y = "Temperature (°C)") +
  theme_minimal() +
  theme(plot.title = element_text(face = "bold"))

ggsave("09_scatter_temp_snow.png", width = 8, height = 6, dpi = 300)

# C) Rain vs Snowfall
ggplot(weather_plot, aes(x = snowfall, y = rain)) +
  geom_point(alpha = 0.2, color = "purple", size = 0.5) +
  labs(title = "Rainfall vs Snowfall",
       subtitle = paste("Based on", nrow(weather_plot), "observations"),
       x = "Snowfall (cm)",
       y = "Rain (mm)") +
  theme_minimal() +
  theme(plot.title = element_text(face = "bold"))

ggsave("10_scatter_rain_snow.png", width = 8, height = 6, dpi = 300)

# D) Temperature by Hour and Month
# Use recent years only
weather_recent <- weather_data %>% 
  filter(year >= 2020, year <= 2022) %>%
  select(hour, temperature_2m, month) %>%
  na.omit()

ggplot(weather_recent, aes(x = hour, y = temperature_2m, color = as.factor(month))) +
  geom_point(alpha = 0.1, size = 0.3) +
  scale_color_viridis_d(labels = month.abb) +  # Better color scheme
  labs(title = "Temperature by Hour and Month",
       subtitle = "Data from 2020-2022",
       x = "Hour of Day",
       y = "Temperature (°C)",
       color = "Month") +
  theme_minimal() +
  theme(plot.title = element_text(face = "bold"))

ggsave("11_scatter_hour_temp_month.png", width = 10, height = 6, dpi = 300)

# E) Correlation matrix
cor_data <- weather_data %>%
  select(temperature_2m, snowfall, rain) %>%
  na.omit()

cor_matrix <- cor(cor_data)
cat("\n=== Correlation Matrix ===\n")
print(round(cor_matrix, 3))

# Visual correlation matrix
library(reshape2)  # For melting data
cor_melted <- melt(cor_matrix)

ggplot(cor_melted, aes(x = Var1, y = Var2, fill = value)) +
  geom_tile(color = "white") +
  geom_text(aes(label = round(value, 2)), color = "black", size = 5) +
  scale_fill_gradient2(low = "blue", high = "red", mid = "white", 
                       midpoint = 0, limit = c(-1,1), name = "Correlation") +
  labs(title = "Correlation Matrix Heatmap",
       x = "", y = "") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1),
        plot.title = element_text(face = "bold"))

ggsave("11b_correlation_heatmap.png", width = 8, height = 6, dpi = 300)
# ============================================
# 6. LAG PLOTS
# ============================================

# Prepare data for lag plots (use a subset for clarity)
temp_ts <- weather_data$temperature_2m

# Lag plot with multiple lags
par(mfrow = c(2, 2))
lag.plot(temp_ts, lags = 4, do.lines = FALSE, main = "Lag Plots - Temperature")
dev.copy(png, "12_lag_plots.png", width = 800, height = 800)
dev.off()

# Lag plot for specific lags
lag_data <- data.frame(
  temp = temp_ts[-c(1:24)],
  lag1 = lag(temp_ts, 1)[-c(1:24)],
  lag24 = lag(temp_ts, 24)[-c(1:24)],   # 1 day
  lag168 = lag(temp_ts, 168)[-c(1:24)]  # 1 week
)

# Lag 1 (previous hour)
ggplot(lag_data, aes(x = lag1, y = temp)) +
  geom_point(alpha = 0.3, color = "steelblue") +
  geom_abline(slope = 1, intercept = 0, color = "red", linetype = "dashed") +
  labs(title = "Lag Plot: Lag 1 (Previous Hour)",
       x = "Temperature at t-1",
       y = "Temperature at t") +
  theme_minimal()

ggsave("13_lag1_plot.png", width = 8, height = 6)

# Lag 24 (same hour yesterday)
ggplot(lag_data, aes(x = lag24, y = temp)) +
  geom_point(alpha = 0.3, color = "darkgreen") +
  geom_abline(slope = 1, intercept = 0, color = "red", linetype = "dashed") +
  labs(title = "Lag Plot: Lag 24 (Same Hour Yesterday)",
       x = "Temperature at t-24",
       y = "Temperature at t") +
  theme_minimal()

ggsave("14_lag24_plot.png", width = 8, height = 6)

# ============================================
# 7. AUTOCORRELATION PLOTS (ACF & PACF)
# ============================================

# Remove NAs
temp_clean <- na.omit(temp_ts)

# ACF plot
png("15_acf_plot.png", width = 1000, height = 600)
acf(temp_clean, lag.max = 200, main = "Autocorrelation Function (ACF) - Temperature")
dev.off()

# PACF plot
png("16_pacf_plot.png", width = 1000, height = 600)
pacf(temp_clean, lag.max = 200, main = "Partial Autocorrelation Function (PACF) - Temperature")
dev.off()

# ACF with more detail for first 48 hours
png("17_acf_48h.png", width = 1000, height = 600)
acf(temp_clean, lag.max = 48, main = "ACF - First 48 Hours")
dev.off()

# ============================================
# 8. STATIONARITY CHECK - VISUAL
# ============================================

# Plot rolling mean and standard deviation
# Calculate rolling statistics (window = 24 hours)
window_size <- 24 * 30  # 30 days

weather_data$rolling_mean <- zoo::rollmean(weather_data$temperature_2m, 
                                           k = window_size, 
                                           fill = NA, 
                                           align = "right")
weather_data$rolling_sd <- zoo::rollapply(weather_data$temperature_2m, 
                                          width = window_size, 
                                          FUN = sd, 
                                          fill = NA, 
                                          align = "right")

ggplot(weather_data, aes(x = time)) +
  geom_line(aes(y = temperature_2m), color = "gray", alpha = 0.5) +
  geom_line(aes(y = rolling_mean), color = "blue", size = 1) +
  labs(title = "Temperature with Rolling Mean (30-day window)",
       subtitle = "Blue line = rolling mean. Is it constant? (Check for stationarity)",
       x = "Time",
       y = "Temperature (°C)") +
  theme_minimal()

ggsave("18_rolling_mean.png", width = 12, height = 6)

ggplot(weather_data, aes(x = time, y = rolling_sd)) +
  geom_line(color = "red", size = 1) +
  labs(title = "Rolling Standard Deviation (30-day window)",
       subtitle = "Is variance constant over time? (Check for stationarity)",
       x = "Time",
       y = "Rolling SD") +
  theme_minimal()

ggsave("19_rolling_sd.png", width = 12, height = 6)

# ============================================
# 9. KPSS TEST FOR STATIONARITY
# ============================================

# Remove NAs for test
temp_for_test <- na.omit(weather_data$temperature_2m)

# KPSS test (Null hypothesis: series is stationary)
# If p-value < 0.05: REJECT null = NOT stationary
# If p-value > 0.05: ACCEPT null = stationary

kpss_result <- kpss.test(temp_for_test)
print("=" * 50)
print("KPSS Test Results - Original Temperature Data")
print("=" * 50)
print(kpss_result)
print(paste("p-value:", kpss_result$p.value))
if (kpss_result$p.value < 0.05) {
  print("CONCLUSION: Data is NOT STATIONARY (p < 0.05)")
} else {
  print("CONCLUSION: Data is STATIONARY (p >= 0.05)")
}

# ============================================
# 10. DIFFERENCING (if not stationary)
# ============================================

# First difference (removes trend)
temp_diff1 <- diff(temp_for_test, differences = 1)

# Plot first difference
plot(temp_diff1, type = "l", main = "First Difference - Temperature",
     xlab = "Index", ylab = "Diff Temperature", col = "steelblue")
dev.copy(png, "20_first_difference.png", width = 1200, height = 600)
dev.off()

# KPSS test on first difference
kpss_diff1 <- kpss.test(temp_diff1)
print("=" * 50)
print("KPSS Test Results - First Difference")
print("=" * 50)
print(kpss_diff1)

# Seasonal difference (lag = 24 for daily seasonality)
temp_diff_seasonal <- diff(temp_for_test, lag = 24, differences = 1)

# Plot seasonal difference
plot(temp_diff_seasonal, type = "l", main = "Seasonal Difference (lag=24) - Temperature",
     xlab = "Index", ylab = "Seasonal Diff", col = "darkred")
dev.copy(png, "21_seasonal_difference.png", width = 1200, height = 600)
dev.off()

# KPSS test on seasonal difference
kpss_seasonal <- kpss.test(temp_diff_seasonal)
print("=" * 50)
print("KPSS Test Results - Seasonal Difference (lag=24)")
print("=" * 50)
print(kpss_seasonal)

# Combined: First + Seasonal difference
temp_diff_combined <- diff(temp_diff_seasonal, differences = 1)

plot(temp_diff_combined, type = "l", main = "First + Seasonal Difference - Temperature",
     xlab = "Index", ylab = "Combined Diff", col = "darkgreen")
dev.copy(png, "22_combined_difference.png", width = 1200, height = 600)
dev.off()

# KPSS test on combined
kpss_combined <- kpss.test(temp_diff_combined)
print("=" * 50)
print("KPSS Test Results - Combined Difference")
print("=" * 50)
print(kpss_combined)

# ACF of differenced data
png("23_acf_differenced.png", width = 1000, height = 600)
acf(temp_diff_combined, lag.max = 100, main = "ACF - After Differencing")
dev.off()

# ============================================
# 11. SUMMARY STATISTICS
# ============================================

summary_stats <- data.frame(
  Statistic = c("Mean", "Median", "SD", "Min", "Max", "Range"),
  Original = c(mean(temp_for_test), median(temp_for_test), sd(temp_for_test),
               min(temp_for_test), max(temp_for_test), 
               max(temp_for_test) - min(temp_for_test)),
  First_Diff = c(mean(temp_diff1), median(temp_diff1), sd(temp_diff1),
                 min(temp_diff1), max(temp_diff1), 
                 max(temp_diff1) - min(temp_diff1)),
  Seasonal_Diff = c(mean(temp_diff_seasonal), median(temp_diff_seasonal), 
                    sd(temp_diff_seasonal), min(temp_diff_seasonal), 
                    max(temp_diff_seasonal), 
                    max(temp_diff_seasonal) - min(temp_diff_seasonal))
)

print(summary_stats)
write.csv(summary_stats, "summary_statistics.csv", row.names = FALSE)


# Nvidia stocks

nvidia_data <- read.csv("/Users/cosmintimis/facultate/master/sem1/forecasting-and-predictive-modeling/nvidia-stock.csv", 
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

# ============================================
# 2. LINE PLOTS (2 plots)
# ============================================

# Plot 1: Full time series - Close price
ggplot(nvidia_data, aes(x = Date, y = Close)) +
  geom_line(color = "darkgreen", linewidth = 0.5) +
  labs(title = "NVIDIA Stock Price - Close",
       subtitle = "Daily closing prices",
       x = "Date",
       y = "Close Price ($)") +
  theme_minimal() +
  theme(plot.title = element_text(face = "bold"))

ggsave("nvidia_01_close_price.png", width = 12, height = 6)

# Plot 2: Close price with Volume (dual axis)
nvidia_data$Volume_millions <- nvidia_data$Volume / 1e6

ggplot(nvidia_data, aes(x = Date)) +
  geom_line(aes(y = Close), color = "darkgreen", linewidth = 0.7) +
  labs(title = "NVIDIA Stock Price - Close (with trend)",
       x = "Date",
       y = "Close Price ($)") +
  theme_minimal() +
  theme(plot.title = element_text(face = "bold"))

ggsave("nvidia_02_close_trend.png", width = 12, height = 6)

# ============================================
# OBSERVATIONS
# ============================================
# - TREND: Clear upward trend (stock price increasing)
# - SEASONALITY: Unlikely (stocks don't have seasonal patterns)
# - CYCLES: Possible market cycles (bull/bear markets)

# ============================================
# 3. MULTIVARIATE ANALYSIS (3 scatter plots)
# ============================================

# Sample if too many points
if (nrow(nvidia_data) > 5000) {
  set.seed(123)
  nvidia_plot <- nvidia_data %>% sample_n(5000)
} else {
  nvidia_plot <- nvidia_data
}

# A) Close vs Volume
ggplot(nvidia_plot, aes(x = Volume_millions, y = Close)) +
  geom_point(alpha = 0.4, color = "steelblue", size = 1) +
  geom_smooth(method = "lm", color = "red", se = TRUE) +
  labs(title = "Close Price vs Trading Volume",
       x = "Volume (Millions)",
       y = "Close Price ($)") +
  theme_minimal()

ggsave("nvidia_03_close_volume.png", width = 8, height = 6)

# B) Open vs Close
ggplot(nvidia_plot, aes(x = Open, y = Close)) +
  geom_point(alpha = 0.4, color = "darkgreen", size = 1) +
  geom_abline(slope = 1, intercept = 0, color = "red", linetype = "dashed") +
  labs(title = "Open vs Close Price",
       subtitle = "Points on red line = no daily change",
       x = "Open Price ($)",
       y = "Close Price ($)") +
  theme_minimal()

ggsave("nvidia_04_open_close.png", width = 8, height = 6)

# C) High-Low Range vs Close
nvidia_plot$daily_range <- nvidia_plot$High - nvidia_plot$Low

ggplot(nvidia_plot, aes(x = Close, y = daily_range)) +
  geom_point(alpha = 0.4, color = "purple", size = 1) +
  geom_smooth(method = "lm", color = "red", se = TRUE) +
  labs(title = "Daily Price Range vs Close Price",
       x = "Close Price ($)",
       y = "Daily Range (High - Low) ($)") +
  theme_minimal()

ggsave("nvidia_05_range_close.png", width = 8, height = 6)

# Correlation matrix
cor_data <- nvidia_data %>%
  select(Open, High, Low, Close, Volume) %>%
  na.omit()

cat("\n=== Correlation Matrix ===\n")
print(round(cor(cor_data), 3))

# ============================================
# 4. LAG PLOTS (2 plots)
# ============================================

close_ts <- nvidia_data$Close

# Lag 1 (previous day)
lag_data <- data.frame(
  close = close_ts[-1],
  lag1 = lag(close_ts, 1)[-1]
)

ggplot(lag_data, aes(x = lag1, y = close)) +
  geom_point(alpha = 0.3, color = "steelblue", size = 1) +
  geom_abline(slope = 1, intercept = 0, color = "red", linetype = "dashed") +
  labs(title = "Lag Plot: Lag 1 (Previous Day)",
       x = "Close Price at t-1",
       y = "Close Price at t") +
  theme_minimal()

ggsave("nvidia_06_lag1.png", width = 8, height = 6)

# ============================================
# 5. AUTOCORRELATION (2 plots)
# ============================================

close_clean <- na.omit(close_ts)

png("nvidia_07_acf.png", width = 1000, height = 600)
acf(close_clean, lag.max = 100, main = "ACF - NVIDIA Close Price")
dev.off()

png("nvidia_08_pacf.png", width = 1000, height = 600)
pacf(close_clean, lag.max = 100, main = "PACF - NVIDIA Close Price")
dev.off()

# ============================================
# 6. STATIONARITY CHECK (2 plots)
# ============================================

# Rolling mean and SD
window_size <- 30  # 30-day window

nvidia_data$rolling_mean <- zoo::rollmean(nvidia_data$Close, 
                                          k = window_size, 
                                          fill = NA, 
                                          align = "right")
nvidia_data$rolling_sd <- zoo::rollapply(nvidia_data$Close, 
                                         width = window_size, 
                                         FUN = sd, 
                                         fill = NA, 
                                         align = "right")

ggplot(nvidia_data, aes(x = Date)) +
  geom_line(aes(y = Close), color = "gray", alpha = 0.5) +
  geom_line(aes(y = rolling_mean), color = "blue", linewidth = 1) +
  labs(title = "NVIDIA Close Price with Rolling Mean (30-day)",
       subtitle = "Blue line = rolling mean (NOT constant → not stationary)",
       x = "Date",
       y = "Close Price ($)") +
  theme_minimal()

ggsave("nvidia_09_rolling_mean.png", width = 12, height = 6)

ggplot(nvidia_data, aes(x = Date, y = rolling_sd)) +
  geom_line(color = "red", linewidth = 1) +
  labs(title = "Rolling Standard Deviation (30-day)",
       subtitle = "Is variance constant?",
       x = "Date",
       y = "Rolling SD") +
  theme_minimal()

ggsave("nvidia_10_rolling_sd.png", width = 12, height = 6)

# ============================================
# 7. KPSS TEST
# ============================================

close_for_test <- na.omit(nvidia_data$Close)

kpss_result <- kpss.test(close_for_test)
cat("\n================================================\n")
cat("KPSS Test - Original Close Price\n")
cat("================================================\n")
print(kpss_result)
cat(paste("p-value:", kpss_result$p.value, "\n"))
if (kpss_result$p.value < 0.05) {
  cat("CONCLUSION: NOT STATIONARY (p < 0.05)\n")
} else {
  cat("CONCLUSION: STATIONARY (p >= 0.05)\n")
}

# ============================================
# 8. DIFFERENCING (3 plots)
# ============================================

# First difference (daily returns)
close_diff1 <- diff(close_for_test, differences = 1)

plot(close_diff1, type = "l", main = "First Difference - NVIDIA Close",
     xlab = "Index", ylab = "Daily Change ($)", col = "steelblue")
dev.copy(png, "nvidia_11_first_diff.png", width = 1200, height = 600)
dev.off()

# KPSS test on first difference
kpss_diff1 <- kpss.test(close_diff1)
cat("\n================================================\n")
cat("KPSS Test - First Difference\n")
cat("================================================\n")
print(kpss_diff1)

# Log returns (better for stocks)
log_returns <- diff(log(close_for_test))

plot(log_returns, type = "l", main = "Log Returns - NVIDIA",
     xlab = "Index", ylab = "Log Return", col = "darkgreen")
dev.copy(png, "nvidia_12_log_returns.png", width = 1200, height = 600)
dev.off()

kpss_log <- kpss.test(log_returns)
cat("\n================================================\n")
cat("KPSS Test - Log Returns\n")
cat("================================================\n")
print(kpss_log)

# ACF of differenced data
png("nvidia_13_acf_diff.png", width = 1000, height = 600)
acf(close_diff1, lag.max = 50, main = "ACF - After First Differencing")
dev.off()

# ============================================
# 9. SUMMARY STATISTICS
# ============================================

summary_stats <- data.frame(
  Statistic = c("Mean", "Median", "SD", "Min", "Max", "Range"),
  Original = c(mean(close_for_test), median(close_for_test), 
               sd(close_for_test), min(close_for_test), 
               max(close_for_test), max(close_for_test) - min(close_for_test)),
  First_Diff = c(mean(close_diff1), median(close_diff1), 
                 sd(close_diff1), min(close_diff1), 
                 max(close_diff1), max(close_diff1) - min(close_diff1)),
  Log_Returns = c(mean(log_returns), median(log_returns), 
                  sd(log_returns), min(log_returns), 
                  max(log_returns), max(log_returns) - min(log_returns))
)

print(summary_stats)
write.csv(summary_stats, "nvidia_summary_statistics.csv", row.names = FALSE)


# hydro

hydro_data <- read.csv("/Users/cosmintimis/facultate/master/sem1/forecasting-and-predictive-modeling/romania_hydro_energy_generation.csv", 
                       header = TRUE)

# Check structure
cat("\n=== Hydro Data Structure ===\n")
print(head(hydro_data))
print(colnames(hydro_data))

# Check for missing values
cat("\nMissing values:\n")
print(colSums(is.na(hydro_data)))

cat("\nYear range:\n")
print(range(hydro_data$Year))

# ============================================
# 2. LINE PLOTS (1 plot)
# ============================================

ggplot(hydro_data, aes(x = Year, y = Value)) +
  geom_line(color = "steelblue", linewidth = 1) +
  geom_point(color = "darkblue", size = 2) +
  labs(title = "Romania Hydro Energy Generation",
       subtitle = paste("Unit:", unique(hydro_data$Unit)),
       x = "Year",
       y = paste("Energy Generation (", unique(hydro_data$Unit), ")")) +
  theme_minimal() +
  theme(plot.title = element_text(face = "bold"))

ggsave("hydro_01_generation.png", width = 12, height = 6)

# ============================================
# OBSERVATIONS
# ============================================
# - TREND: Look for increasing/decreasing pattern
# - SEASONALITY: NO (yearly data cannot have seasonality)
# - CYCLES: Possible multi-year cycles (weather/economic)

# ============================================
# 3. LAG PLOTS (2 plots)
# ============================================

energy_ts <- hydro_data$Value

# Multiple lags
par(mfrow = c(2, 2))
lag.plot(energy_ts, lags = 4, do.lines = FALSE, 
         main = "Lag Plots - Hydro Energy")
dev.copy(png, "hydro_02_lag_plots.png", width = 800, height = 800)
dev.off()

# Lag 1 (previous year)
lag_data <- data.frame(
  energy = energy_ts[-1],
  lag1 = lag(energy_ts, 1)[-1]
)

ggplot(lag_data, aes(x = lag1, y = energy)) +
  geom_point(color = "steelblue", size = 3) +
  geom_abline(slope = 1, intercept = 0, color = "red", linetype = "dashed") +
  labs(title = "Lag Plot: Lag 1 (Previous Year)",
       x = "Energy at t-1",
       y = "Energy at t") +
  theme_minimal()

ggsave("hydro_03_lag1.png", width = 8, height = 6)

# ============================================
# 4. AUTOCORRELATION (2 plots)
# ============================================

energy_clean <- na.omit(energy_ts)

png("hydro_04_acf.png", width = 1000, height = 600)
acf(energy_clean, lag.max = 20, 
    main = "ACF - Hydro Energy Generation")
dev.off()

png("hydro_05_pacf.png", width = 1000, height = 600)
pacf(energy_clean, lag.max = 20, 
     main = "PACF - Hydro Energy Generation")
dev.off()

# ============================================
# 5. STATIONARITY CHECK (2 plots)
# ============================================

# Rolling mean and SD (use 5-year window)
window_size <- 5

hydro_data$rolling_mean <- zoo::rollmean(hydro_data$Value, 
                                         k = window_size, 
                                         fill = NA, 
                                         align = "right")
hydro_data$rolling_sd <- zoo::rollapply(hydro_data$Value, 
                                        width = window_size, 
                                        FUN = sd, 
                                        fill = NA, 
                                        align = "right")

ggplot(hydro_data, aes(x = Year)) +
  geom_line(aes(y = Value), color = "gray", linewidth = 1) +
  geom_line(aes(y = rolling_mean), color = "blue", linewidth = 1.5) +
  geom_point(aes(y = Value), color = "darkblue", size = 2) +
  labs(title = "Hydro Energy with Rolling Mean (5-year)",
       subtitle = "Blue line = rolling mean. Is it constant?",
       x = "Year",
       y = "Energy Generation") +
  theme_minimal()

ggsave("hydro_06_rolling_mean.png", width = 12, height = 6)

ggplot(hydro_data, aes(x = Year, y = rolling_sd)) +
  geom_line(color = "red", linewidth = 1.5) +
  geom_point(color = "darkred", size = 2) +
  labs(title = "Rolling Standard Deviation (5-year)",
       subtitle = "Is variance constant?",
       x = "Year",
       y = "Rolling SD") +
  theme_minimal()

ggsave("hydro_07_rolling_sd.png", width = 12, height = 6)

# ============================================
# 6. KPSS TEST
# ============================================

energy_for_test <- na.omit(hydro_data$Value)

kpss_result <- kpss.test(energy_for_test)
cat("\n================================================\n")
cat("KPSS Test - Original Energy Data\n")
cat("================================================\n")
print(kpss_result)
cat(paste("p-value:", kpss_result$p.value, "\n"))
if (kpss_result$p.value < 0.05) {
  cat("CONCLUSION: NOT STATIONARY (p < 0.05)\n")
} else {
  cat("CONCLUSION: STATIONARY (p >= 0.05)\n")
}

# ============================================
# 7. DIFFERENCING (2 plots)
# ============================================

# First difference (year-to-year change)
energy_diff1 <- diff(energy_for_test, differences = 1)

plot(energy_diff1, type = "b", main = "First Difference - Hydro Energy",
     xlab = "Index", ylab = "Year-to-Year Change", 
     col = "steelblue", pch = 19)
dev.copy(png, "hydro_08_first_diff.png", width = 1200, height = 600)
dev.off()

# KPSS test on first difference
kpss_diff1 <- kpss.test(energy_diff1)
cat("\n================================================\n")
cat("KPSS Test - First Difference\n")
cat("================================================\n")
print(kpss_diff1)

# ACF of differenced data
png("hydro_09_acf_diff.png", width = 1000, height = 600)
acf(energy_diff1, lag.max = 15, 
    main = "ACF - After First Differencing")
dev.off()

# ============================================
# 8. SUMMARY STATISTICS
# ============================================

summary_stats <- data.frame(
  Statistic = c("Mean", "Median", "SD", "Min", "Max", "Range"),
  Original = c(mean(energy_for_test), median(energy_for_test), 
               sd(energy_for_test), min(energy_for_test), 
               max(energy_for_test), 
               max(energy_for_test) - min(energy_for_test)),
  First_Diff = c(mean(energy_diff1), median(energy_diff1), 
                 sd(energy_diff1), min(energy_diff1), 
                 max(energy_diff1), 
                 max(energy_diff1) - min(energy_diff1))
)

print(summary_stats)
write.csv(summary_stats, "hydro_summary_statistics.csv", row.names = FALSE)
