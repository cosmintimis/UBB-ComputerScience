library("fpp3")
library("tidyverse")
library(cowplot) #for plot_grid
library("slider")
library("stats") # for loess

aus_production
beer <- aus_production |>
  select(Beer)

beer |>
  autoplot() +
  geom_point() +
  labs(title = "Australian Beer production")

beerDecomp <- beer |>
  model(classical_decomposition(Beer, type = "additive"))

beerDecomp |> 
  components()

p1 <- beerDecomp |>
  components() |>
  autoplot()
p1

beerDecomp |>
  components() |>
  ACF(random) |>
  autoplot() +
  geom_point() +
  labs(title = "ACF of the random component for the classical decomposition on the Australian Beer data")
ggsave("ACF_ClassicalDecompRandom_AusBeer.png")

p2 <- beer |> 
  model(stl = STL(Beer)) |> components() |> autoplot()

plot_grid(p1, p2)

beerDecomp2 <- beer |>
  model(stl = STL(Beer), 
        cd = classical_decomposition(Beer, type = "additive"))

beerDecomp2 |> components() |> view()

trends <- beerDecomp2 |>
  components() |>
  select(.model, Quarter, trend)

trends |> autoplot() +
  geom_line(size= 4, alpha = 0.2) +
  labs(title = "Trend components in STL and Classical decomposition for the Australian Beer data")

aus_beer |>
  autoplot() + 
  geom_point()

beer_short <- beer |>
  filter(year(Quarter) >= 1962, year(Quarter) < 1976) 

beer_short |>
  autoplot() +
  geom_point() +
  labs(title = "Australian beer production between 1962 and 1976")
ggsave("LinePlot_AusBeer_Short.png")

beer_short_decomp <- beer_short |>
  model(d = classical_decomposition(Beer, type = "additive"))

beer_short_decomp |>
  components() |>
  autoplot()
ggsave("Components_ClassicalDecomp_BeerShort.png")

beer_short_decomp |>
  components() |>
  ACF(random) |>
  autoplot() +
  geom_point() +
  labs(title = "ACF plot of the random components for the classical decomposition for Australian Beer production between 1962 and 1976")
ggsave("ACF_ClassicalDEcompositionRandom_AusBeerShort.png")

beer_recent <- beer |>
  tail(n = 60)

beer_recent |>
  autoplot() +
  geom_point() +
  labs("Australian beer production for the last 15 years")
ggsave("LinePlot_AusBeerRecent.png")

beer_recent_decomp <- beer_recent |>
  model(d = classical_decomposition(Beer, type = "additive"))

beer_recent_decomp |>
  components() |>
  autoplot()
ggsave("Components_ClassicalDecomp_AusBeerRecent.png")

beer_recent_decomp |>
  components() |>
  ACF(random) |>
  autoplot() + 
  geom_point() +
  labs(title = "ACF plot of the random component of the classical decomposition for the last 15 years of Australian Beer production")
ggsave("ACF_ClassicalDEcompositionRandom_AusBeerRecent.png")

a10 <- PBS |>
  filter(ATC2 == "A10") |>
  select(Month, Concession, Type, Cost) |>
  summarize(TotalCost = sum(Cost)) |>
  mutate(Cost = TotalCost / 1000000)

a10 |> 
  autoplot(Cost) +
  geom_point() +
  labs(title = "Antidiabetic drug sales")
ggsave("LinePLot_Antidiabetic.png")

a10_decomp <- a10 |>
  model(d = classical_decomposition(Cost, type = "multiplicative"))

a10_decomp |>
  components()

a10_decomp |>
  components() |>
  autoplot()
ggsave("Components_ClassicalDecomposition_Antidiabetic.png")

a10_decomp |>
  components() |>
  ACF(random, lag_max = 30) |>
  autoplot() +
  geom_point() +
  labs(title = "ACF of the random component from the classical decomposition of the Antidiabetic drug sales data")
ggsave("ACF_ClassicalDEcomp_Randon_Antidiabetic.png")


us_retail_employment
us_retail_employment |>
  autoplot() +
  geom_point() +
  labs(title = "Retail imployment in the US")
ggsave("LinePlot_UsRetail.png")

x_11_decomp <- us_retail_employment |>
  model(x11 = X_13ARIMA_SEATS(Employed ~ x11()))

x_11_decomp |>
   components() |> autoplot()
ggsave("X11_Components_UsRetail.png")

x_11_decomp |> 
  components() |>
  tail(n = 10)

x_11_decomp |>
   components() |>
  ACF(irregular) |>
  autoplot() + 
  geom_point() +
  labs("ACF of the X11 decomposition on the Us retail employment data")

x_11_decomp |>
  components() |>
  ggplot(aes(x = Month)) +
  geom_line(aes(y = Employed ), colour = "gray", size = 2) +
  geom_line(aes(y = season_adjust), colour = "blue", size = 2) +
  geom_line(aes(y = trend), colour = "red", size = 2) +
  labs(title = "Total employment in US retail (gray), versus trend determined by X-11 (red) versus seasonally adjusted data determinend by X-11(blue)")
  
ggsave("LinePlot_Trend_SeasonallyAdjusted_X11_UsRetail.png")


x_11_decomps <- us_retail_employment |>
  model(x11_1 = X_13ARIMA_SEATS(Employed ~ x11(trendma = 9)),
  x11_2 = X_13ARIMA_SEATS(Employed ~ x11(trendma = 27)),
  x11_3 = X_13ARIMA_SEATS(Employed ~ x11(trendma = 39)),
  x11_4 = X_13ARIMA_SEATS(Employed ~ x11(seasonalma = "s3x1")),
  x11_5 = X_13ARIMA_SEATS(Employed ~ x11(seasonalma = "s3x5")),
  x11_6 = X_13ARIMA_SEATS(Employed ~ x11(seasonalma = "s3x9")))
x_11_decomps |>
  components()

x_11_decomps |>
  components() |> as_tsibble(key = .model, index = Month) |>
  filter(.model == "x11_1" | .model == "x11_2" | .model == "x11_3") |>
  autoplot(trend, size = 2, alpha = 0.7)
ggsave("LinePLot_Trend_X11_9_27_39_UsRetail.png")


x_11_decomps |>
  components() |> as_tsibble(key = .model, index = Month) |>
  filter(.model == "x11_4" | .model == "x11_5" | .model == "x11_6") |>
  autoplot(seasonal, size = 2, alpha = 0.7)
ggsave("LinePLot_Seasonal_X11_3_5_9_UsRetail.png")


seats_decomp <- us_retail_employment |>
  model(s = X_13ARIMA_SEATS(Employed ~ seats()))

seats_decomp |>
  components()

seats_decomp |>
  components() |>
  autoplot()
ggsave("Seats_ComponentsPlot_UsRetail.png")

seats_decomp |>
  components() |>
  ACF(irregular) |>
  autoplot() +
  geom_point() +
  labs(title = "ACF of the irregular term in the Seats decomposition of us retail data")

us_retail_employment |> autoplot()

us_retail_employment_index <- us_retail_employment |>
  mutate(Nr = seq(from = 1, to = 357, by = 1))
us_retail_employment_index |> 
  autoplot(Employed) + 
  geom_point()

loess_model <- loess(Employed ~ Nr, data = us_retail_employment_index, span = 0.1)
loess_model
us_retail_employment_index <- us_Retail_employment_index |>
  mutate(Smoothed = predict(loess_model))
us_retail_employment_index

us_retail_employment_index |>
  ggplot(mapping = aes(x = Nr)) +
  geom_line(mapping = aes(y = Smoothed), color = "red", size = 1.5) +
  geom_point(mapping = aes(y = Employed), color = "blue", size = 1.5) +
  geom_line(mapping = aes(y = Employed), color = "gray", size = 1)
ggsave("LinePlot_LoessExample_UsRetail.png")

stl_dcm <- us_retail_employment |>
  model(Stl = STL(Employed)) |>
  components()
stl_dcm |> autoplot()

stl_dcm |>
  ACF(remainder) |>
  autoplot() +
  geom_point()

ggsave("Components_STL_UsEmployed.png")

stl_dcm2 <- us_retail_employment |>
  model(Stl = STL(Employed ~ trend(window = 5))) |>
  components()
stl_dcm2 |> autoplot()
ggsave("Components_STL_UsEmployedTW5.png")

stl_dcm3 <- us_retail_employment |>
  model(Stl = STL(Employed ~ trend(window = 51))) |>
  components()
stl_dcm3 |> autoplot()
ggsave("Components_STL_UsEmployedTW51.png")

stl_dcm4 <- us_retail_employment |>
  model(Stl = STL(Employed ~ trend(window = 501))) |>
  components()
stl_dcm4 |> autoplot()
ggsave("Components_STL_UsEmployedTW501.png")

stl_dcm5 <- us_retail_employment |>
  model(Stl = STL(Employed ~ season(window = 5))) |>
  components()
stl_dcm5 |> autoplot()
ggsave("Components_STL_UsEmployedSW5.png")

stl_dcm6 <- us_retail_employment |>
  model(Stl = STL(Employed ~ season(window = 25))) |>
  components()
stl_dcm6 |> autoplot()
ggsave("Components_STL_UsEmployedSW25.png")

stl_dcm7 <- us_retail_employment |>
  model(Stl = STL(Employed ~ season(window = "periodic"))) |>
  components()
stl_dcm7 |> autoplot()
ggsave("Components_STL_UsEmploySPeriodic.png")

#look at the ACFs
stl_dcm
stl_dcm4 |> ACF(remainder) |>
  autoplot() + 
  geom_point()


stl_dcm8 <- us_retail_employment |>
  model(s = STL(Employed ~ trend(window = 13) + season(window = 25))) |>
  components() 
stl_dcm8 |> autoplot()
ggsave("Components_STL_UsEmployedTW13_SPeriodic.png")

stl_dcm8 |>
  ACF(remainder) |>
  autoplot() +
  geom_point()


climate <- read_csv("DailyDelhiClimate.csv")
climate
climate_ts <- climate |> as_tsibble(index = date)
climate_ts |> autoplot(meanpressure) + 
  geom_point() +
  labs(title = "Daily mean pressure for Delhi")
ggsave("TimeSeriesPlot_DailyClimate.png")

climate_ts |> head(n = 700) |> autoplot(meanpressure) + 
  geom_point() 

climate |> summary()

position <- which(climate_ts$meanpressure == max(climate_ts$meanpressure))
position

climate_ts$meanpressure[1183] <- 1200

climate_ts_short <- climate_ts |> filter(year(date) == 2016, month(date) < 5)
climate_ts_short |> autoplot(meanpressure)
ggsave("LinePLot_DailyClimateShort.png")

stl_climate <- climate_ts_short |>
  model(s = STL(meanpressure)) |>
  components()
stl_climate |> autoplot()
ggsave("Components_STL_Climate.png")

stl_climate2 <- climate_ts_short |>
  model(s = STL(meanpressure, robust = TRUE)) |>
  components()
stl_climate2 |> autoplot()
ggsave("Components_STL_ClimateRobust.png")


stl_dcm11 <- us_retail_employment |>
  model(stl = STL(Employed ~ season(period = 6))) |> components()
stl_dcm11 |> autoplot()
ggsave("Components_STL_UsEmployed_Period6.png")
stl_dcm11 |> ACF(remainder) |> autoplot()

stl_dcm12 <- us_retail_employment |>
  model(stl = STL(Employed ~ season(period = c(6, 12)))) |> components()
stl_dcm12 |> autoplot()
ggsave("Components_STL_UsEmployed_Period6_12.png")

vic_elec
vic_elec |>
  index_by(hour = floor_date(Time, "hour")) |>
  summarize(AVGDemand = mean(Demand)) -> vic_elec_hourly

vic_elec_hourly

vic_elec_hourly |>
  gg_season(AVGDemand, period = 24 * 7)

vic_elec_hourly <- vic_elec_hourly |>
  filter(year(hour) == 2012, month(hour) <= 6)

vic_elec_hourly |>
  autoplot() + 
  labs(title = "Hourly electricty demand in Victoria, Australia for the first 6 months of 2012")
ggsave("LinePlot_HourlyVicElec.png")

vic_elec_hourly |>
  model(ms = STL(AVGDemand ~ season(period = c(24, 24 * 7)))) |>
  components() |>
  autoplot()
ggsave("Components_STL_VicElec.png")

tourism

tourism |>
  features(Trips, list(Mean = mean)) |>
  arrange(desc(Mean))

tourism |>
  features(Trips, quantile)

tourism |>
  features(Trips, quantile) |>
  arrange(`50%`) |> view ()

tourism |>
  features(Trips, feat_acf) |> view()


tourism |>
  features(Trips, feat_stl) |> view()

tourism |>
  features(Trips, feat_stl) |>
  ggplot(aes(x = trend_strength, y = seasonal_strength_year, col = Purpose)) +
  geom_point() +
  facet_wrap(vars(State)) 
ggsave("SeasonalStrength_vs_TrendStrength_Trips.png")


tourism |>
  features(Trips, feat_stl) |> 
  filter(seasonal_strength_year == max(seasonal_strength_year)) |>
  left_join(tourism, by = c("State", "Region", "Purpose"), multiple = "all") |>
  ggplot(aes(x = Quarter, y = Trips)) + 
  geom_line() + 
  facet_grid(vars(State, Region, Purpose))
ggsave("StrongestSEason.png")


tourism_features <- tourism |>
  features(Trips, feature_set(pkgs = "feasts"))
tourism_features |> view()
