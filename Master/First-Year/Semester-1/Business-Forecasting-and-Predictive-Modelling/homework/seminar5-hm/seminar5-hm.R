library(fpp3)

# Load Data
weather_raw <- read.csv("/Users/cosmintimis/facultate/master/sem1/forecasting-and-predictive-modeling/open-meteo-borsa-mm.csv", 
                        check.names = FALSE)
weather_raw$time <- as.POSIXct(weather_raw$time, format="%Y-%m-%dT%H:%M", tz="UTC")

# Aggregate to Monthly Average Temperature (Seasonality = 12)
weather_ts <- weather_raw %>%
  mutate(Month = yearmonth(time)) %>%
  group_by(Month) %>%
  summarise(AvgTemp = mean(`temperature_2m (°C)`, na.rm = TRUE)) %>%
  as_tsibble(index = Month)

# Plot to verify Seasonality
weather_ts %>%
  autoplot(AvgTemp) +
  labs(title = "Monthly Average Temperature (Borsa)", y = "Temp (C)")

# --- TRAIN / TEST SPLIT ---
# We keep the last 12 months
test_start <- max(weather_ts$Month) - 11
train_data <- weather_ts %>% filter(Month < test_start)
test_data  <- weather_ts %>% filter(Month >= test_start)

cat("Training End: ", as.character(max(train_data$Month)), "\n")
cat("Test Start:   ", as.character(min(test_data$Month)), "\n\n")

# 4 models:
# 1. Baseline: Seasonal Naive (SNAIVE)
# 2. ETS: Automatic Exponential Smoothing
# 3. ARIMA_Manual
# 4. ARIMA_Auto

fit_models <- train_data %>%
  model(
    
    Baseline_SNaive = SNAIVE(AvgTemp),
    
    ETS_Auto = ETS(AvgTemp),
    
    ARIMA_Manual = ARIMA(AvgTemp ~ pdq(1,0,0) + PDQ(1,1,0)),
    
    ARIMA_Auto = ARIMA(AvgTemp)
  )

print(fit_models)

# Forecast on Test Set
fc_models <- fit_models %>% forecast(test_data)

# Accuracy Comparison (RMSE, MAE)
accuracy(fc_models, test_data) %>%
  select(.model, RMSE, MAE, MAPE) %>%
  arrange(RMSE) %>%
  print()

# Visual Comparison
fc_models %>%
  autoplot(weather_ts %>% filter(Month >= test_start - 24), level = NULL) +
  labs(title = "Forecast Comparison: Actual vs Models",
       y = "Temperature (C)")


# ARIMA_Auto is the best
fit_models %>% select(ARIMA_Auto) %>% gg_tsresiduals()

# Ljung-Box Test
fit_models %>%
  select(ARIMA_Auto) %>%
  augment() %>%
  features(.innov, ljung_box, lag = 24, dof = 3) %>%
  print()

cat("--- ETS Model Parameters ---")
report(fit_models %>% select(ETS_Auto))

cat("--- ARIMA Auto Parameters ---")
report(fit_models %>% select(ARIMA_Auto))