library(fpp3)
library(GGally)

# 1. NVIDIA (Multivariate)
nvidia_raw <- read.csv("/Users/cosmintimis/facultate/master/sem1/forecasting-and-predictive-modeling/nvidia-stock.csv", 
                       check.names = FALSE, 
                       stringsAsFactors = FALSE)

nvidia_raw$Date <- as.Date(nvidia_raw$Date)

nvidia_ts <- nvidia_raw %>%
  as_tsibble(index = Date)

nvidia_ts %>% 
  select(Close, Open, High, Low, Volume) %>%
  as_tibble() %>% 
  ggpairs() + 
  labs(title = "Scatterplots for NVIDIA Data")

fit_mv <- nvidia_ts %>%
  model(
    Model1_Simple  = TSLM(Close ~ Open),
    Model2_Complex = TSLM(Close ~ Open + High + Low + Volume)
  )

cat("\n=== MULTIVARIATE REGRESSION RESULTS ===\n")
report(fit_mv %>% select(Model1_Simple))
report(fit_mv %>% select(Model2_Complex))

# Compare AICc/BIC
fit_mv %>% glance() %>% select(.model, adj_r_squared, AICc, BIC) %>% print()


# 2. WEATHER ANALYSIS (Seasonal)

weather_raw <- read.csv("/Users/cosmintimis/facultate/master/sem1/forecasting-and-predictive-modeling/open-meteo-borsa-mm.csv", 
                        check.names = FALSE, 
                        stringsAsFactors = FALSE)

weather_raw$time <- as.POSIXct(weather_raw$time, format="%Y-%m-%dT%H:%M", tz="UTC")

weather_ts <- weather_raw %>%
  mutate(Month = yearmonth(time)) %>% 
  group_by(Month) %>%
  summarise(AvgTemp = mean(`temperature_2m (°C)`, na.rm = TRUE)) %>%
  ungroup() %>%
  as_tsibble(index = Month)

# --- Seasonal Data Split ---
# Keep the last 12 months for testing
test_start_month <- max(weather_ts$Month) - 11

train_data <- weather_ts %>% filter(Month < test_start_month)
test_data  <- weather_ts %>% filter(Month >= test_start_month)

cat("\n=== SEASONAL DATA SPLIT ===\n")
cat("Training end:", as.character(max(train_data$Month)), "\n")
cat("Test start:  ", as.character(min(test_data$Month)), "\n\n")

# --- Modeling (S1 & S2) ---
fit_seasonal <- train_data %>%
  model(
    S1_SeasonOnly  = TSLM(AvgTemp ~ season()),
    S2_SeasonTrend = TSLM(AvgTemp ~ trend() + season())
  )

report(fit_seasonal %>% select(S2_SeasonTrend))

# --- Residual Diagnostics ---
fit_seasonal %>% select(S2_SeasonTrend) %>% gg_tsresiduals()

# Ljung-Box Test
fit_seasonal %>% 
  select(S2_SeasonTrend) %>%
  augment() %>%
  features(.innov, ljung_box, lag = 10) %>%
  print()

# --- Forecast & Accuracy ---
fc_seasonal <- fit_seasonal %>% forecast(test_data)

accuracy(fc_seasonal, test_data) %>% 
  select(.model, RMSE, MAE, MAPE, MASE) %>%
  print()

# Refit on full dataset
fit_final_s1 <- weather_ts %>% model(S1_SeasonOnly  = TSLM(AvgTemp ~ season()))
fit_final_s2 <- weather_ts %>% model(S2_SeasonTrend = TSLM(AvgTemp ~ trend() + season()))

fc_final_s1 <- fit_final_s1 %>% forecast(h = 10)
fc_final_s2 <- fit_final_s2 %>% forecast(h = 10)

autoplot(weather_ts) +
  autolayer(fc_final_s1, series = "Seasonal Only", PI = FALSE) +
  autolayer(fc_final_s2, series = "Seasonal + Trend", PI = FALSE) +
  labs(title = "10-Month Forecast: Comparison of S1 and S2",
       y = "Temperature (°C)", x = "Year")

cat("\n=== FINAL COMPARISON: Model S2 vs Baselines ===\n")

acc_s2 <- accuracy(fc_seasonal, test_data)
print(acc_s2 %>% select(.model, RMSE, MAE))

fit_baselines <- train_data %>%
  model(
    Mean   = MEAN(AvgTemp),
    SNaive = SNAIVE(AvgTemp)
  )

fc_baselines <- fit_baselines %>% forecast(test_data)

acc_baselines <- accuracy(fc_baselines, test_data)

print(acc_baselines %>% select(.model, RMSE, MAE))

# 3. ROMANIA HYDRO (Yearly Trend Analysis )

hydro_raw <- read.csv("/Users/cosmintimis/facultate/master/sem1/forecasting-and-predictive-modeling/romania_hydro_energy_generation.csv", 
                      header = TRUE,
                      stringsAsFactors = FALSE)
hydro_ts <- hydro_raw %>%
  as_tsibble(index = Year)

# Since it is yearly, we look for Trend, not Seasonality
autoplot(hydro_ts, Value) +
  labs(title = "Romania Hydro Energy Generation (Yearly)",
       y = "Generation",
       x = "Year")

fit_hydro <- hydro_ts %>%
  model(
    Drift_Model = RW(Value ~ drift()),      
    Linear_Trend = TSLM(Value ~ trend())
  )

cat("\n=== HYDRO MODEL REPORT ===\n")
report(fit_hydro %>% select(Linear_Trend))

fc_hydro <- fit_hydro %>% forecast(h = 5)

autoplot(hydro_ts, Value) +
  autolayer(fc_hydro, level = NULL) + 
  labs(title = "Forecast: Hydro Generation Trend",
       y = "Generation (Value)",
       x = "Year")