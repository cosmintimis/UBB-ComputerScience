library('fpp3')
library('tidyverse')

gafa_stock

google_2015 <- gafa_stock |>
  filter(Symbol == "GOOG", year(Date) == 2015)

google_2015 |>
  autoplot(Close) +
  geom_point() +
  labs(title = "Google closing stock price for 2015")
ggsave("TimeSeriesPlot_Google2015Close.png")

google_2015 |>
  ACF(Close) |>
  autoplot() +
  geom_point() +
  labs(title = "ACF plot of Google closing stock price for 2015")
ggsave("ACF_Google2015Close.png")

google_2015 |>
  mutate(CloseD = difference(Close)) -> google_2015


google_2015 |>
  autoplot(CloseD) +
  geom_point() +
  labs(title = "Changes in Google closing stock price (differenced data)")
ggsave("TimeSeriesPlot_Google2015CloseDiff.png")

google_2015 |>
  ACF(CloseD) |>
  autoplot() +
  geom_point() +
  labs(title = "ACF plot of differenced Google closign stock price for 2015")
ggsave("ACF_Google2015CloseDiff.png")  

google_2015 |>
  features(CloseD, ljung_box, lag = 10)

google_2015 |>
  features(Close, ljung_box, lag = 10)

PBS |> 
  filter(ATC2 == "A10") |>
  summarize(Cost = sum(Cost) / 10e6) -> a10

a10 |>
  autoplot() +
  geom_point() +
  labs(title = "Antidiabetic drug sales")
ggsave("TimeSeriesPlot_Antidiabetic.png")

a10 |>
  mutate(CostD = difference(Cost)) -> a10

a10 |>
  autoplot(CostD) +
  geom_point() +
  labs(title = "Differenced antidiabetic drug sales")
ggsave("TimeSeriesPlot_AntidiabeticDiff.png")

a10 |>
  mutate(CostDLog = log(CostD)) -> a10

a10 |>
  autoplot(CostDLog) +
  geom_point() +
  labs(title = "Logarithm of the differenced antidiabetic drug sales")
ggsave("TimeSeriesPlot_AntidiabeticDiffLog.png")

a10 |> 
  mutate(CostL = log(Cost)) -> a10

a10 |>
  autoplot(CostL) +
  geom_point() +
  labs(title = "Logarithm of antidiabetic drug sales")
ggsave("TimeSeriesPlot_AntidiabeticCostLog.png")

a10 |>
  mutate(CostLDiff = difference(CostL)) -> a10

a10 |>
  autoplot(CostLDiff) +
  geom_point() +
  labs(title = "Difference of logarithm of antidiabetic drug sales")
ggsave("TimeSeriesPlot_AntidiabeticCostLogDiff.png")

a10 |>
  select(Cost) -> a10 #remove all the previous columns

a10 |>
  mutate(CostLog = log(Cost)) |>
  mutate(CostLogSDiff = difference(CostLog, 12)) ->a10

a10 |>
  autoplot(CostLogSDiff) +
  geom_point() +
  labs(title = "Seasonal differenced logarithm of drug sales")
ggsave("TimeSeriesPlot_Antidiabetic_CostLogSDiff.png") 

a10 |> 
  ACF(CostLogSDiff) |>
  autoplot() +
  geom_point() +
  labs(title = "ACF of the seasonally differenced logarithm of antidiabetic drug sales")
ggsave("ACF_Antidiabetic_CostLogSDiff.png")

a10 |>
  features(CostLogSDiff, ljung_box, lag = 24)

a10 |>
  features(CostLogSDiff, unitroot_kpss)


a10 |>
  features(CostLog, c(unitroot_ndiffs, unitroot_nsdiffs))
           
global_economy

egiptian_export <- global_economy |>
  filter(Code == "EGY") |>
  select(Exports)

egyptian_export |>
  autoplot(Exports) +
  geom_point() +
  labs(title = "Egyptian export")
ggsave("TimeSeriesPlot_EgyptianExport.png")

egyptian_arima_model <- egyptian_export |>
  model(ARIMA(Exports))

egyptian_arima_model |>
  report()

egyptian_arima_model |>
  gg_tsresiduals() +
  labs(title = "Residual diagnostics for an ARIMA(2, 0, 1) model on Egyptian exports") -> p
p
ggsave("TSResid_EgyptianExport_ARIMA.png", plot = p)


egyptian_forecast <- egyptian_arima_model |>
  forecast(h = 10)

egyptian_forecast |>
  autoplot(egyptian_export) +
  labs(title = "Forecast of Egyptian export using an ARIMA (2, 0, 1) model ")
ggsave("TimeSEriesPlot_EgyptianExport_Forecast_Arima.png")

egyptian_export
egyptian_train <- egyptian_export |>
  head(n = 46)
egyptian_test <- egyptian_export |>
  tail(n = 12)

egyptian_models <- egyptian_train |>
  model (
    naive = NAIVE(Exports),
    mean = MEAN(Exports),
    arima1 = ARIMA(Exports ~ pdq(2, 0, 1)),
    arima2 = ARIMA(Exports ~ pdq(1, 2, 2)),
    arima3 = ARIMA(Exports ~ pdq(1, 1, 1)),
    ses = ETS(Exports)
  )

egyptian_models |>
  augment() |>
  autoplot(.fitted) + 
  autolayer(egyptian_export) + 
  labs(title = "Original (black) and fitted values for several models")

ggsave("TimeSeriesPlot_EgyptianExports_Forecast_6models.png")

egyptian_models |> 
  select(naive) |>
  report()

egyptian_models |>
  select(mean) |>
  report()

egyptian_models |>
  select(arima1) |>
  report()

egyptian_models |>
  select(arima2) |>
  report()

egyptian_models |>
  select(arima3) |>
  report()

egyptian_models |>
  select(ses) |>
  report()

egyptian_models |>
  select(naive) |>
  gg_tsresiduals() +
  labs(title = "Residual diagnostics for the naive model on Egyptian exports data") ->p
p
ggsave("TSResid_EgyptianExport_Naive.png", plot = p)

egyptian_models |>
  select(mean) |>
  gg_tsresiduals() +
  labs(title = "Residual diagnostics for the mean model on Egyptian exports data") ->p
p
ggsave("TSResid_EgyptianExport_Mean.png", plot = p)

egyptian_models |>
  select(arima1) |>
  gg_tsresiduals() +
  labs(title = "Residual diagnostics for the ARIMA(2, 0, 1) model on Egyptian exports data") ->p
p
ggsave("TSResid_EgyptianExport_ARIMA1.png", plot = p)

egyptian_models |>
  select(arima2) |>
  gg_tsresiduals() +
  labs(title = "Residual diagnostics for the ARIMA(1, 2, 2) model on Egyptian exports data") ->p
p
ggsave("TSResid_EgyptianExport_ARIMA2.png", plot = p)

egyptian_models |>
  select(arima3) |>
  gg_tsresiduals() +
  labs(title = "Residual diagnostics for the ARIMA(1, 1, 1) model on Egyptian exports data") ->p
p
ggsave("TSResid_EgyptianExport_ARIMA3.png", plot = p)

egyptian_models |>
  select(ses) |>
  gg_tsresiduals() +
  labs(title = "Residual diagnostics for the SES model on Egyptian exports data") ->p
p
ggsave("TSResid_EgyptianExport_SES.png", plot = p)

egyptian_forecast <- egyptian_models |>
  forecast(h = 12)

accuracy(egyptian_forecasts, egyptian_test)

egyptian_forecast |> autoplot(egyptian_export, level = NULL) +
  labs(title=  "Forecasts and actual data for several models on the Egyptian exports data")
ggsave("TimeSeriesPlot_EgyptianExport_Forecasts_6models.png")


egyptian_models2 <- egyptian_export |>
  model(
    m1 = ARIMA(Exports ~ pdq(2, 0, 1) + 0),
    m2 = ARIMA(Exports ~ pdq(2, 1, 1) + 0),
    m3 = ARIMA(Exports ~ pdq(2, 2, 1) + 0),
    m4 = ARIMA(Exports ~ pdq(1, 0, 1) + 1),
    m5 = ARIMA(Exports ~ pdq(4, 0, 1) + 1),
    m6 = ARIMA(Exports ~ pdq(3, 1, 1) + 1)
  )

egyptian_models2 |>
  forecast(h = 50) -> egyptian_forecasts2

egyptian_forecast2 |> 
  filter(.model == "m1") |> 
  autoplot(egyptian_export) +
  labs(title = "ARIMA(2, 0, 1) model with zero constant, forecast for 50 years")
ggsave("TimeSeriesPlot_EgyptianExport_Forecast_Model1.png")


egyptian_forecast2 |> 
  filter(.model == "m2") |> 
  autoplot(egyptian_export) +
  labs(title = "ARIMA(2, 1, 1) model with zero constant, forecast for 50 years")
ggsave("TimeSeriesPlot_EgyptianExport_Forecast_Model2.png")

egyptian_forecast2 |> 
  filter(.model == "m3") |> 
  autoplot(egyptian_export) +
  labs(title = "ARIMA(2, 2, 1) model with zero constant, forecast for 50 years")
ggsave("TimeSeriesPlot_EgyptianExport_Forecast_Model3.png")

egyptian_forecast2 |> 
  filter(.model == "m4") |> 
  autoplot(egyptian_export) +
  labs(title = "ARIMA(1, 0, 1) model with constant, forecast for 50 years")
mean(egyptian_export$Exports)
ggsave("TimeSeriesPlot_EgyptianExport_Forecast_Model4.png")

egyptian_forecast2 |> 
  filter(.model == "m5") |> 
  autoplot(egyptian_export) +
  labs(title = "ARIMA(4, 0, 1) model with  constant, forecast for 50 years")
ggsave("TimeSeriesPlot_EgyptianExport_Forecast_Model5.png")

egyptian_forecast2 |> 
  filter(.model == "m6") |> 
  autoplot(egyptian_export) +
  labs(title = "ARIMA(3, 1, 1) model with constant, forecast for 50 years")
ggsave("TimeSeriesPlot_EgyptianExport_Forecast_Model6.png")


egyptian_export |>
  ACF() |>
  autoplot() +
  geom_point() +
  labs(title = "ACF Plot of Egyptian exports")
ggsave("ACF_EgyptianExports.png")

egyptian_export |>
  PACF() |>
  autoplot() +
  geom_point() +
  labs(title = "PACF Plot of Egyptian exports")
ggsave("PACF_EgyptianExports.png")


egyptian_export |>
  gg_tsdisplay(plot_type = "partial") +
  labs(title = "Time plot, ACF and PACF plots for Egyptian exports") ->p
p
ggsave("TSDisplay_EgyptianExports.png", plot = p)


egyptian_export |> 
  model(m1 = ARIMA(Exports ~ pdq(4, 0, 0)),
        m2 = ARIMA(Exports ~ pdq(2, 0, 1))) -> egyptian_model3

egyptian_model3 |>
  select(m1) |>
  report()

egyptian_model3 |>
  select(m2) |>
  report()


african_exports <- global_economy |>
  filter(Code == "CAF") |>
  select(Exports)

african_exports |>
  autoplot() +
  geom_point() +
  labs(title = "Central African Exports")
ggsave("TimeSeriesPlot_AfricanExport.png")

african_exports |>
  features(Exports, unitroot_ndiffs)

african_exports |>
  mutate(ExportsDiff = difference(Exports)) |>
  gg_tsdisplay(ExportsDiff, plot_type = "partial") -> p
p
ggsave("TSDisplay_AfricanExport.png")

african_models <- african_exports |> 
  model(m1 = ARIMA(Exports ~ pdq(0, 1, 3)),
        m2=  ARIMA(Exports ~ pdq(2, 1, 0)),
        m3 = ARIMA(Exports),
        m4 = ARIMA(Exports, stepwise = FALSE ))


african_models
african_models |> 
  glance() |>
  view() 

selected <- african_models |>
  select(m4)

selected |>
  gg_tsresiduals() +
  labs(title = "Residuals for the ARIMA(3, 1, 0) model") ->p
p
ggsave("TSResid_AfricanExports_ARIMA.png")

selected |>
  augment () |>
  features(.innov, ljung_box, lag = 10, dof = 3)

selected |>
  forecast(h = 5) |>
  autoplot(african_exports) +
  labs(title = "5 year forecast for Central African exports")
ggsave("TimeSeriesPlot_AfricanExports_Forecasts_ARIMA.png")


leisure <- us_employment |>
  filter(Title == "Leisure and Hospitality", year(Month) > 2000) |>
  mutate(Employed = Employed / 1000) |>  #to work with smaller values
  select(Employed, Month)

leisure |> autoplot() +
  geom_point() +
  labs(title = "US employment: leisure and hospitality")
ggsave("TimeSeriesPlot_UsLeisure.png")


leisure |>
  gg_tsdisplay(difference(Employed, lag = 12), plot_type = "partial", lag = 36) +
  labs(title = "Time plot, ACF and PACF plots of the seasonally differenced employment data")->p
p
ggsave("TSDisplay_Leisure.png", plot = p)


leisure |>
  gg_tsdisplay(difference(difference(Employed, lag = 12)), plot_type = "partial", lag = 36) +
  labs(title = "Time plot, ACF and PACF plots of the seasonally and normally differenced employment data")->p
p
ggsave("TSDisplay_Leisure2Diff.png", plot = p)

leisure |> features(Employed, c(unitroot_ndiffs, unitroot_nsdiffs))

leisure_models <- leisure |>
  model(arima012011 = ARIMA(Employed ~ pdq(0, 1, 2) + PDQ(0, 1,1)),
        arima210011 = ARIMA(Employed ~ pdq(2, 1, 0) + PDQ(0, 1, 1)),
        auto = ARIMA(Employed, stepwise = FALSE, approx = FALSE))

leisure_models 

leisure_models |> 
  glance()

leisure_models |>
  select(auto) |>
  gg_tsresiduals(lag = 36) +
  labs(title = " Residual diagnostics for the ARIMA(2, 1, 0)(1, 1, 1)_12 model") -> p
p
ggsave("TSResid_Leisure_ARIMA.png", plot = p)


leisure_models |> 
  select(auto) |>
  augment() |>
  features(.innov, ljung_box, dof = 4, lag = 24) #white noise


leisure_models |>
  select(auto) |>
  forecast(h = 36) |>
  autoplot(leisure) +
  labs(title = "Forecasts for three years with an ARIMA(2, 1, 0)(1, 1, 1)_12 model")
ggsave("TimeSeriesPlot_Leisure_Forecast_ARIMA.png")


corticosteroid <- PBS |>
  filter(ATC2 == "H02") |>
  summarise(Cost = sum(Cost)/1e6) # to have smaller values

corticosteroid |> autoplot() +
    geom_point() +
    labs(title = "Corticosteroid drug prescriptions")  
ggsave("TimeSeriesPlot_Corticosteroid.png")


corticosteroid <- corticosteroid |> 
  mutate(CostL = log(Cost))
corticosteroid |> autoplot(CostL) +
  geom_point() +
  labs(title = "Logarithm of corticosteroid drug prescriptions")
ggsave("TimeSeriesPlot_CorticosteroidLog.png")

lambda <- corticosteroid |> 
  features(Cost, guerrero)
lambda #will print 0.0315
corticosteroid <- corticosteroid |> 
  mutate(CostBC = box_cox(Cost, lambda))

corticosteroid |> 
  select(-Cost) |> 
  pivot_longer(cols = c(CostL, CostBC), names_to= "Transformation", values_to= "Value") |> 
  autoplot() +
  labs(title = "Logarithm vs. Box-Cox transformation of corticosteroid drug prescriptions")
ggsave("TimeSeriesPlot_Corticosteroid_LogvsBC.png")

corticosteroid |> features(log(Cost), c(unitroot_ndiffs, unitroot_nsdiffs))

corticosteroid |> 
  gg_tsdisplay(difference(log(Cost), 12), plot_type = "partial", lag_max = 24) +
  labs(title = " Time plot, ACF and PACF plots for the seasonally differenced corticosteroid drug prescription data") -> p
p
ggsave("TSDisplay_Corticosteorid_LogSDiff.png", plot = p)

corticosteroid |> 
  gg_tsdisplay(difference(difference(log(Cost), 12)), plot_type = "partial", lag_max = 24) +
  labs(title = " Time plot, ACF and PACF plots for the seasonally and normally differenced corticosteroid drug prescription data") -> p
p
ggsave("TSDisplay_Corticosteorid_LogSDiffDiff.png", plot = p)

corticosteroid |> model(
  arima210012 = ARIMA(log(Cost) ~ pdq(2, 1, 0) + PDQ(0, 1, 2)),
  arima211012 = ARIMA(log(Cost) ~ pdq(2, 1, 1) + PDQ(0, 1, 2)),
  arima310012 = ARIMA(log(Cost) ~ pdq(3, 1, 0) + PDQ(0, 1, 2)),
  arima210011 = ARIMA(log(Cost) ~ pdq(2, 1, 0) + PDQ(0, 1, 1)),
  arima210111 = ARIMA(log(Cost) ~ pdq(2, 1, 0) + PDQ(1, 1, 1)),
  arima311012 = ARIMA(log(Cost) ~ pdq(3, 1, 1) + PDQ(0, 1, 2)),
  arima210210 = ARIMA(log(Cost) ~ pdq(2, 1, 0) + PDQ(2, 1, 0))
) -> corticosteroid_models

corticosteroid_models |> glance() |> arrange(AICc)

corticosteroid_models |> 
  select(arima211012) |>
  gg_tsresiduals(lag_max = 36) +
  labs(title = "Residuals diagnostics for the ARIMA(2, 1, 1) (0, 1, 2)_12 model") ->p
p
ggsave("TSResid_Corticosteorid_ARIMA.png", plot = p)

corticosteroid_models |>
  select(arima211012) |>
  augment() |>
  features(.innov, ljung_box, lag = 36, dof = 5) #fails, it is not white noise.

corticosteroid |> 
  model(ARIMA(log(Cost), stepwise = FALSE, approx = FALSE)) -> corticosteroid_best_model
corticosteroid_best_model

corticosteroid_best_model |>
  augment() |>
  features(.innov, ljung_box, lag = 36, dof = 6)


corticosteroid_train <- corticosteroid |> head(n = 180)
corticosteroid_test <- corticosteroid |> tail(n = 24)

corticosteroid_train |> model(
  arima210012 = ARIMA(log(Cost) ~ pdq(2, 1, 0) + PDQ(0, 1, 2)),
  arima211012 = ARIMA(log(Cost) ~ pdq(2, 1, 1) + PDQ(0, 1, 2)),
  arima310012 = ARIMA(log(Cost) ~ pdq(3, 1, 0) + PDQ(0, 1, 2)),
  arima210011 = ARIMA(log(Cost) ~ pdq(2, 1, 0) + PDQ(0, 1, 1)),
  arima210111 = ARIMA(log(Cost) ~ pdq(2, 1, 0) + PDQ(1, 1, 1)),
  arima311012 = ARIMA(log(Cost) ~ pdq(3, 1, 1) + PDQ(0, 1, 2)),
  arima210210 = ARIMA(log(Cost) ~ pdq(2, 1, 0) + PDQ(2, 1, 0)),
  arima301111 = ARIMA(log(Cost) ~ pdq(3, 0, 1) + PDQ(1, 1, 1)),
  arima213011 = ARIMA(log(Cost) ~ pdq(2, 1, 3) + PDQ(0, 1, 1)),
  arima301012 = ARIMA(log(Cost) ~ pdq(3, 0, 1) + PDQ(0, 1, 2))
) -> corticosteroid_train_models

corticosteroid_forecasts <- corticosteroid_train_models |> 
  forecast(h = 24)

accuracy(corticosteroid_forecasts, corticosteroid_test) |> arrange(RMSE)


corticosteroid_forecasts |> 
  filter(.model == "arima213011") |>
  autoplot(corticosteroid) + 
  labs(title ="2 year forecast using an ARIMA(2, 1, 3)(0, 1, 1)_12 model")
ggsave("TimeSeriesPlot_Corticosteorid_Forecast_ARIMA.png")

corticosteroid_models |> 
  augment() |> 
  features(.innov, ljung_box, lag = 24) |>
  arrange(desc(lb_pvalue))
