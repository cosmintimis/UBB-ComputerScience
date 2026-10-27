library('fpp3')
library('tidyverse')

global_economy
global_economy |>
  distinct(Country)

algeria_economy <- global_economy |>
  filter(Country == "Algeria")
algeria_economy |>
  autoplot(Exports) +
  geom_point() +
  labs(title = "Algerian exports")
ggsave("LinePlot_AlgeriaExports.png")

algeria_model <- algeria_economy |>
  model(ETS(Exports ~ error("A") + trend("N") + season("N")))

algeria_model |> 
  report()

algeria_model |>
  tidy()

algeria_model |>
  augment()

algeria_model |>
  gg_tsresiduals() -> p
p

ggsave("TSResiduals_SES_AlgerianExports.png", plot = p)

algeria_forecast <- algeria_model |>
  forecast(h = 5)

algeria_forecast |> view()


algeria_forecast |>
  autoplot(algeria_economy) + 
  geom_line(mapping = aes(y =.fitted), data = augment(algeria_model), color = "red") +
  labs(title = "Data (black), fitted value (red) and forecast")
ggsave("LinePlot_FittedForecast_SES_AlgeriaExport.png")

aus_economy <- global_economy |>
  filter(Code == "AUS") |>
  select(Population) |>
  mutate(Pop = Population / 10e6)

aus_economy

aus_economy |>
  autoplot() +
  geom_point() +
  labs(title = "Population of Australia (in millions)")
ggsave("LinePlot_AustraliaPopulation.png")

aus_economy_model <- aus_economy |>
  model(ETS(Pop ~ error("A") + trend("A") + season("N")))

aus_economy_model |>
  report()

aus_economy_model |>
  tidy()

aus_economy_model |>
  gg_tsresiduals()  -> p
p

ggsave("TSResiduals_HW_AustralianPopulation.png", plot = p)

aus_economy_model_augmented = aus_economy_model |>
  augment()

aus_economy_model_augmented

aus_economy_forecast <- aus_economy_model |>
  forecast(h = 10)

aus_economy_forecast |> view()

aus_economy_forecast |>
  autoplot() +
  autolayer(aus_economy, Pop) +
  autolayer(aus_economy_model_augmented, .fitted, color = "red") +
  labs(title = "Data, fitted values (red) and predictions")
ggsave("LinePlot_FittedForecast_HW_AustralianPopulation.png")


aus_economy_damped <- aus_economy |>
  model(Holt = ETS(Pop ~ error("A") + trend("A") + season("N")),
        Damped = ETS(Pop ~ error("A") + trend("Ad", phi = 0.8) + season("N")))

aus_economy_damped |> tidy()

aus_economy_damped[2] |> report()

aus_economy_damped |> 
  augment() |>
  view()

aus_economy_damped |>
  augment() |>
  autoplot(.fitted, linewidth = 1.5) +
  labs(title = "Fitted values for Holt and Damped Holt")
ggsave("LinePlot_Fitted_H_AustralianPopulation.png")

aus_economy_damped_forecast <- aus_economy_damped |>
  forecast(h = 15)

aus_economy_damped_forecast |>
  autoplot(aus_economy, level = NULL, linewidth = 1.5) +
  labs(title = "Comparison between Holt's and damped trend model")
ggsave("LinePlot_Forecast_HoltDamped_AustralianPopulation.png")


class(WWWusage)

www_usage <- WWWusage |>
  as_tsibble()

www_usage |> head(n = 15)

www_usage |>
  autoplot() +
  geom_point() +
  labs(title = "Internet usage")
ggsave("LinePlot_wwwusage.png")


www_usage_cv <- www_usage |>
  stretch_tsibble(.init = 10, .step = 1)

www_usage_cv |> view()

www_usage_model <- www_usage_cv |>
  model(SES = ETS(value ~ error("A") + trend("N") + season("N")),
        Holt = ETS(value~ error("A") + trend("A") + season("N")),
        Damped = ETS(value ~ error("A") + trend("Ad") + season("N")))

www_usage_model |>
  tidy() |> view()

www_usage_model |>
  forecast(h = 1) |>
  accuracy(www_usage)


www_usage |> 
  model(ETS(value ~ error("A") + trend("Ad") + season("N"))) |>
  forecast(h = 10) |>
  autoplot(www_usage) + 
  labs(title = "Forecasts for 10 minutes of internet usage, using the damped trend model")
ggsave("LinePlot_Forecast_Damped_wwwusage.png")


www_usage_train <- www_usage |>
  head(n = 80)

www_usage_test <- www_usage |>
  tail(n = 20)

www_usage_model2 <- www_usage_train |>
  model(SES = ETS(value ~ error("A") + trend("N") + season("N")),
        Holt = ETS(value ~ error("A") + trend("A") + season("N")),
        Damped_8 = ETS(value ~ error("A") + trend("Ad", phi = 0.8) + season("N")),
        Damped_9 = ETS(value ~ error("A") + trend("Ad", phi = 0.9) + season("N")),
        Damped_98 = ETS(value ~ error("A") + trend("Ad", phi = 0.98) + season("N")))

www_usage_model2 |>
  forecast(h = 20) |>
  accuracy(www_usage_test)


www_usage_model2 |> 
  forecast(h = 20) |> 
  autoplot(www_usage, level = NULL, linewidth = 1.5) + 
  labs(title = "Forecasts of internet usage for the 5 methods with 80-20 train test split") +
  guides(color = "none")
ggsave("LinePlot_Forecast_5Methods_wwwusage_nolegend.png")

tourism

aus_holiday <- tourism |>
  filter(Purpose == "Holiday") |>
  summarise(Trips = sum(Trips) / 1e3)

aus_holiday |>
  autoplot() +
  geom_point() +
  labs(title ="Plot of quarterly visitor nights in Australia")
ggsave("LinePlot_AustraliaVisitors.png")  


aus_holidays_model <- aus_holidays |>
  model(additive = ETS(Trips ~ error("A") + trend("A") + season("A")),
        multiplicative = ETS(Trips ~ error("A") + trend("A") + season("M")))

aus_holidays_model |> tidy()


aus_holidays_forecast <- aus_holidays_model |>
  forecast(h = "3 years")

aus_holidays_forecast |> 
  autoplot(aus_holidays, level = NULL) +
  labs(title = "3 year forecast with additive and multiplicative Holt-Winter's method")
ggsave("LinePLot_Forecast_HW_AustraliaVisitors.png")  


aus_holidays_model[1] |> augment() |> autoplot(.fitted, color = "red", linewidth = 1.2) +
  autolayer(aus_holidays, color = "black", linewidth =1.2) +
  autolayer(aus_holidays_model[2] |> augment(), .fitted, color = "blue", linewidth = 1.2) +
  labs(title = "Fitted values for the additive (red) and multiplicative model (blue) and the actual observations")
ggsave("LinePlot_Fitted_HW_AustraliaVisitors.png")

aus_holidays_model[1] |>
  gg_tsresiduals() ->p
p
ggsave("TSResiduals_HW_ADD_AustraliaVisitors.png", plot = p)

aus_holidays_model[2] |>
  gg_tsresiduals() -> p
p
ggsave("TSResiduals_HW_Mult_AustraliaVisitors.png", plot = p)


aus_holidays_model[1] |>
  components() |>
  autoplot() +
  labs(title=  "Decomposition of the ETS(A, A, A) model")
ggsave("Decomposition_ETS_HW_Add_AustraliaVisitors.png")

comp <- aus_holidays_model[1] |> components()
view(comp)

aus_holidays_model[2] |>
  components() |>
  autoplot() +
  labs(title=  "Decomposition of the ETS(A, A, M) model")
ggsave("Decomposition_ETS_HW_Mult_AustraliaVisitors.png")

accuracy(aus_holidays_model)


pedestrian #two years, hourly data

#pick second half of 2016 and aggregate into daily
pedestrian_short <- pedestrian |>
  filter(Date >= "2016-07-10", Sensor == "Southern Cross Station") |>
  index_by (Date) |>
  summarize(Count = sum(Count)/ 1000)

pedestrian_short

pedestrian_short  |> autoplot(Count) +
  geom_point() + 
  labs(title = "Pedestrian traffic")
ggsave("LinePlot_PedestrianTraffic.png")

pedestrian_short |> gg_season(period = "week") + #remember seasonal plot?
  labs(title = "Seasonal plot of pedestrian traffic")
ggsave("Seasonal_PedestrianTraffic.png")

pedestrian_train <- pedestrian_short |>
  filter(Date <= "2016-07-31")

pedestrian_model <- pedestrian_train |>
  model(add = ETS(Count ~ error("A") + trend("Ad") + season("A")),
        mult = ETS(Count ~ error("A") + trend("Ad") + season("M"))) #Experiment with M and A 

pedestrian_model[1] |>
  report()

pedestrian_forecast <- pedestrian_model |> 
  forecast(h = "2 weeks")

pedestrian_forecast |> autoplot(pedestrian_short |>
                                  filter(Date <= "2016-08-14")) +
  labs(title = "Plot of pedestrian data and 2 week forecast")
ggsave("LineLplot_Forecast_HW_Pedestrian.png")

pedestrian_test <-pedestrian_short |>
  filter(Date >= "2016-08-01", Date <= "2016-08-14")

accuracy(pedestrian_forecast, data = pedestrian_test)


aus_holidays <- tourism |>
  filter(Purpose == "Holiday") |>
  summarize(Trips = sum(Trips)/1e3)

aus_holidays |> 
  autoplot() + 
  geom_point() +
  labs(title = "Quarterly overnight trips (thousands) with holiday purpose in Australia")

aus_holidays_model <- aus_holidays |>
  model(ETS(Trips))
report(aus_holidays_model)


pedestrian_short <- pedestrian |>
  filter(Date >= "2016-07-10", Sensor == "Southern Cross Station") |>
  index_by (Date) |>
  summarize(Count = sum(Count)/ 1000)
pedestrian_model <- pedestrian_short |>
  model(ETS(Count))
pedestrian_model |> report()   

aus_economy <- global_economy |>
  filter(Code == "AUS") |>
  select(Population) |>
  mutate(Pop = Population / 1e6) #just to work with smaller values

aus_economy_model <- aus_economy |>
  model(ETS(Pop))
aus_economy_model |> report()    
