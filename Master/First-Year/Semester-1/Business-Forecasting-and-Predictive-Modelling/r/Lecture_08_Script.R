library("fpp3")
library("tidyverse")

googleData <- gafa_stock |>
  filter(Symbol == "GOOG" & 
           year(Date) == 2015)  
googleData |> view()

googleData <- googleData |>
  mutate(day = row_number()) |>
  update_tsibble(index = day, regular = TRUE) |>
  select(Close)

googleData
#cross-validation
google_2015_cv <- googleData |>
  stretch_tsibble(.init = 3, .step = 1)
google_2015_cv |> view()

google_2015_cv |>
  model(RW(Close ~drift())) |>
  forecast(h = 1) |> 
  accuracy(googleData)


us_change
us_change |> autoplot()

us_change |> 
  pivot_longer(c(Consumption, Income), names_to = "Series", values_to = "Values") |>
  autoplot(Values) +
  labs(title=  "Quarterly data about US Consumption and Income", y = "% change")
ggsave("LinePlot_UsConsumptionIncome.png")

us_change |>
  ggplot(mapping = aes(x = Income, y = Consumption)) + 
  labs(title = "Us Consumption vs. Income", x = "Income % quarterly change", y = "Consumption % quarterly change") +
  geom_point() +
  geom_smooth(method= "lm", se = FALSE)
ggsave("Scatter_UsConsumptionIncome.png")


us_change |>
  model(TSLM(Consumption ~ Income)) -> usChange_lm

usChange_lm |> tidy()

usChange_lm |>report()

us_change |>
  model(TSLM(Consumption ~ Income + Savings)) |>
  report()

us_change |>
  pivot_longer(-Quarter, names_to = "Name") -> us_change_long

us_change_long

us_change_long |>
  ggplot(mapping =  aes(x = Quarter, y =value, color = Name)) + 
  geom_line() +
  facet_grid(vars(Name), scales = "free_y") +
  guides(colour = "none")  +
  labs(title = "Time series plot of different possible predictor variables")
ggsave("LinePlot_UsChangeAll.png")

library(GGally)

us_change |>
  ggpairs(columns = 2:6) +
  labs(title = "Scatterplots and correlations for pairs of different possible predictor variables")
ggsave("PairPlot_UsChangeAll.png")

us_change |>
  model(TSLM(Consumption ~ Income + Savings + Unemployment + Production)) -> us_change_lm_all

us_change_lm_all |> 
  report()

us_change_lm_all |>
  augment()

us_change_lm_all |>
  augment() |>
  ggplot(mapping = aes(x = Quarter)) +
  geom_line(mapping = aes(y = Consumption, color = "Data")) +
  geom_line(mapping = aes(y = .fitted, color = "Fitted")) +
  guides(color = guide_legend(title = NULL)) +
  labs(title = "Consumption (red) vs. fitted value with a model with four predictors (blue)")
ggsave("LinePlot_FittedvsActual_UsChange.png")

us_change_lm_all |>
  augment() |>
  ggplot(mapping = aes(x = Consumption, y = .fitted)) +
  geom_point() +
  geom_abline(intercept = 0, slope = 1) +
  labs(x = "Actual value", y = "Fitted value", title = "Scatter plot of Consumption vs. Fitted value with a model with four predictors")
ggsave("ScatterPlot_FittedvsActual_UsChange.png")

residuals <- us_change |>
  model(all = TSLM(Consumption ~ Income + Savings + Unemployment + Production )) |>
  augment()

residuals

us_change |>
  model(all = TSLM(Consumption ~ Income + Savings + Unemployment + Production)) |>
  gg_tsresiduals() -> p
p
ggsave("ResidualDiag_UsChange_AllPredictors.png", plot = p)

us_change |>
  left_join(residuals, by = "Quarter") |>
  pivot_longer(c(Income, Production, Savings, Unemployment), names_to = "predictor", values_to = "x") |>
  ggplot(mapping = aes(x = x, y = .resid)) +
  geom_point() +
  facet_wrap(vars(predictor), scales = "free") +
  labs(y = "Residuals", x = "", title = "Scatter plots of the residuals against the predictor variables")
ggsave("Scatter_ResidvsPredictor_UsChange.png")

residuals |>
  ggplot(mapping = aes(x = .fitted, y = .resid)) +
  geom_point() +
  labs(x = "Fitted value", y = "Residuals", title = "Scatterplot of fitted values against residuals")
ggsave("Scatter_FittedVsResidual_UsChange.png")

aus_airpassengers
guinea_rice

cor(aus_airpassengers$Passengers |> head(n = 42), guinea_rice$Production)

aus_airpassengers |>
  autoplot() +
  labs(title = "Australian air passengers") -> p1
p1

guinea_rice |>
  autoplot() +
  labs(title = "Guinea rice production") -> p2
p2

library(cowplot)
plot_grid(p1, p2, nrow =2) ->p3
p3
ggsave("LinePlot_AirPassengersvsGuineaRice.png", plot = p3)

joined <- aus_airpassengers |>
  head(n = 42) |>
  left_join(guinea_rice, by = "Year")

joined

joined |>
  ggplot(mapping = aes(x = Passengers, y = Production)) +
  geom_point() +
  labs(x = "Air passengers in Australia", y = "Rice production in Guinea", title = "Scatterplot of Australian air passengers vs. Guinea rice production")
ggsave("Scatterplot_AirPassengersvsGuineaRice.png")

model <- joined |>
  model(model = TSLM(Passengers ~ Production))

model |> report()

aus_airpassengers |> summary()

model |>
  gg_tsresiduals() + 
  labs(title = "Residuals of the model that predicts Auatralian air passengers using Guinea rice production") ->p
ggsave("ResidualDiag_AirPassengersvsGuineaRice.png", plot = p)

model |>
  augment() |>
  features(.innov, ljung_box, lag = 8) #high p-value means white noise

air_model <- aus_airpassengers |>
  model(m = TSLM(Passengers ~ trend()))
air_model |>
  report()

air_model |>
  gg_tsresiduals() +
  labs(title = "Residuals of a model that forecasts Australian air passengers based on trend") -> p
ggsave("ResidualDiag_AirPassengersvsTrend.png", plot = p)


aus_production
recent_production <- aus_production |>
  filter(year(Quarter) >= 1992)

recent_production |>
  autoplot(Beer) + 
  geom_point()+
  labs(title = "Quarterly Australian beer production")
ggsave("LinePlot_BeerProduction.png")

beer_fit <- recent_production |>
  model(TSLM(Beer ~ trend() + season()))
beer_fit |> report()

beer_fit |>
  gg_tsresiduals() +
  labs(title = "Residuals of the model to predict Australian beerp roduction using trend and seasonal dummies") ->p
p
ggsave("ResidualDiag_AusBeervsTrendAndSeason.png", plot = p)

beer_fit |>
  augment() |>
  features(.innov, ljung_box, lag = 8)

beer_fit |> augment() |>
  ggplot(mapping = aes(x = Quarter)) +
  geom_line(mapping = aes(y = Beer, colour = "Actual"), linewidth = 1) +
  geom_line(mapping = aes(y = .fitted, colour = "Fitted"), linewidth = 1) +
  guides(colour = guide_legend(title = "Series")) +
  labs(title = "Actual value (Red) vs. Fitted value (Blue) for the model to predict Australian beer production using trend and seasonal dummies")
ggsave("LinePlot_ActualVs.Fitted_Beer.png")

beer_fit |> augment() |>
  ggplot() +
  geom_point(mapping = aes(x = Beer, y = .fitted, colour = quarter(Quarter))) +
  geom_abline(intercept = 0, slope = 1) +
  guides (colour = guide_legend("Title")) +
  labs(title = "Scatterplot of actual value vs. fitted value for the model to predict Australian beer production using trend and seasonal dummies")
ggsave("Scatter_ActualVsFitted_Beer.png")

beer_fit |> augment() |>
  ggplot() +
  geom_point(mapping = aes(x = .innov, y = .fitted, colour = quarter(Quarter))) +
  geom_abline(intercept = 0, slope = 1) +
  guides (colour = guide_legend("Title")) +
  labs(title = "Scatterplot of residuals vs. fitted value for the model to predict Australian beer production using trend and seasonal dummies")
ggsave("Scatter_ResidualsVsFittedValues.png")

us_change |>
  model(all = TSLM(Consumption ~ Income + Savings + Unemployment + Production)) |>
  glance() -> measures

measures |> view()

measures <- measures |> 
  select(adj_r_squared, CV, AIC, AICc, BIC)

measures

recent_production <- aus_production |>
  filter(year (Quarter) >= 1992)

beer_fit <- recent_production |>
  model(TSLM(Beer ~ trend() + season()))

beer_forecast <- forecast(beer_fit)

beer_forecast |> 
  autoplot(recent_production) +
  labs(title = "Forecast of beer production using trend and seasonal dummies")
ggsave("LinePlot_Forecast_Beer.png")


consumptionFit <- us_change |>
  model(all = TSLM(Consumption ~ Income + Savings + Unemployment))


new_data(us_change, 4)

future_scenarios <- scenarios(
  increase = new_data(us_change, 8) |>
    mutate(Income = 1, Savings = 0.5, Unemployment = 0),
  decrease = new_data(us_change, 8) |>
    mutate(Income=-1, Savings = -0.5, Unemployment = 0),
  names_to = "Scenarios"
)

consumptionForecast <- forecast(consumptionFit, new_data = future_scenarios)

us_change |>
  autoplot(Consumption) +
  autolayer(consumptionForecast)  +
  labs(title = "Example of scenario-based forecasting, considering an increase and a decrease scenario")
ggsave("LinePlot_Scenario_UsConsumption.png")

vitamins <- PBS |> 
  filter(ATC2 == "A11") |>
  select(Month, Concession, Type, Cost) |>
  summarize(TotalCost = sum(Cost)) |>
  mutate(Cost = TotalCost / 1000000)

autoplot(vitamins, Cost) +
  labs(title = "Monthly vitamin prescription data")
ggsave("LinePlot_Vitamins.png")

vitamins_model1 <- vitamins |>
  model(TSLM(Cost ~ trend()))
vitamins_model1 |> report()

vitamins |> ggplot(mapping = aes(x = Month, y = Cost)) +
  geom_line() +
  geom_line(data = fitted(vitamins_model1), aes(y = .fitted, colour = .model)) +
  labs(title = "Vitamin prescription data and the linear model considering trend as predictor")
ggsave("LinePlot_VitaminsVsPrediction.png")

vitamins_model2 <- vitamins |> 
  model(TSLM(Cost ~ trend(knots = yearmonth("2000 Jan"))))
vitamins_model2 |> report()

vitamins |> ggplot(mapping = aes(x = Month, y = Cost)) +
  geom_line() +
  geom_line(data = fitted(vitamins_model2), aes(y = .fitted, colour = .model)) +
  labs(title = "Vitamin prescription data and the linear model with one knot considering trend as predictor")
ggsave("LinePlot_VitaminsVsPrediction_Knots.png")

boston_marathon
boston_marathon |> distinct(Event)

boston_marathon |> 
  filter(Year >= 1924) |>
  filter(Event == "Men's open division") |> 
  mutate(Minu  = as.numeric(Time)/60) ->boston_men

boston_men
boston_men |> autoplot(Minutes) +
  geom_point() +
  labs(title = "Boston marathon winning time")
ggsave("LinePlot_BostonMarathon.png")

boston_model <- boston_men |>
  model(linear = TSLM(Minutes ~ trend()), 
        logarithmic = TSLM(log(Minutes) ~ trend()),
        piecewise = TSLM(Minutes ~ trend(knots = c(1950, 1980)))
  )
boston_model |> 
  accuracy() |> 
  arrange(MAE)       

boston_forecast <- boston_model |> forecast(h = 10)
boston_forecast |> view()

boston_men |>
  autoplot(Minutes) +
  autolayer(boston_forecast) +
  geom_line(data = fitted(boston_model), aes(y = .fitted, colour = .model)) +
  labs(title = "Boston marathon winning times with three models based on trend (trend, log(trend), trend with 2 knots) and forecasts for 10 years")
ggsave("LinePlot_BostonMarathon_Forecast.png")
