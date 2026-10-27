library("tidyverse")
library("fpp3")

#autoplot
olympic_running |>
  autoplot()

olympic_running |>
  filter(Length == 100 & Sex == "men") |>
  autoplot()

?PBS

PBS 

PBS |>
  distinct(Concession, Type)

PBS |>
  distinct(ATC1_desc)

PBS |>
  distinct(ATC2_desc) |>
  view()

PBS |>
  distinct(ATC1_desc, ATC2_desc) |>
  view()


a10 <- PBS |>
  filter(ATC2 == "A10") |>
  select(Month, Concession, Type, Cost) |>
  summarize(TotalCost = sum(Cost)) |>
  mutate(Cost = TotalCost / 1000000)


a10

a10 |>
  autoplot(TotalCost) +
  labs(x = "Month", y = "Million $", title = "Antidiabetic drug sales")


a10 |>
  autoplot(TotalCost) +
  geom_point() +
  labs(x = "Month", y = "Million $", title = "Antidiabetic drug sales")


a10 |>
  head( n = 35) |>
  autoplot() + 
  geom_point() +
  labs(x = "Month", y = "Million $", title = "First 35 observations for antidiabetic drug sales")


#Vitamins
a11 <- PBS |>
  filter(ATC2 == "A11") |>
  select(Month, Concession, Type, Cost) |>
  summarize(TotalCost = sum(Cost)) |>
  mutate(Cost = TotalCost / 1000000)

#mineral supplements
a12 <- PBS |>
  filter(ATC2 == "A12") |>
  select(Month, Concession, Type, Cost) |>
  summarize(TotalCost = sum(Cost)) |>
  mutate(Cost = TotalCost / 1000000)

#analgesics
n02 <- PBS |>
  filter(ATC2 == "N02") |>
  select(Month, Concession, Type, Cost) |>
  summarize(TotalCost = sum(Cost)) |>
  mutate(Cost = TotalCost / 1000000)


a11 |>
  autoplot(TotalCost) +
  geom_point() +
  labs(x = "Month", y = "Million $", title = "Monthly vitamin sales")

a12 |>
  autoplot(TotalCost) +
  geom_point() +
  labs(x = "Month", y = "Million $", title = "Monthly mineral supplements sales")

n02 |>
  autoplot(TotalCost) +
  geom_point() +
  labs(x = "Month", y = "Million $", title = "Monthly analgesics sales")

AirPassengers |>
  as_tsibble() |>
  autoplot() +
  geom_point() +
  labs(title = "Airline passengers")

?EuStockMarkets
EuStockMarkets |>
  as_tsibble() |>
  filter(key == "DAX") |>
  autoplot(value) +
  labs(x = "Business day", y = "Closing price", title = "Daily closing prices for DAX stock index")

aus_production
aus_bricks <- aus_production |>
  select(Bricks)

aus_bricks |>
  autoplot() +
  geom_point() +
  labs(x= "Quarter", y = "Bricks", title = "Australian clay brick production")

aus_bricks |>
  head(n = 20) |>
  autoplot() +
  geom_point()

lynx |>
  as_tsibble() |>
  autoplot() +
  geom_point() +
  labs(x = "Year", y = "Number of lynx trapped", title =  "Annual number of lynx trapped in McKenzie river district")

vic_elec

vic_elec |> as_tibble() |>
  mutate(Time = force_tz(Time, tzone = "UTC")) |> write.csv("vic_elec.csv")

vic_elec |>
  autoplot(Demand) +
  labs(x = "half hour", y = "demand", title = "Electricity demand for Victoria (Australia)")

vic_elec |>
  head (n = 3000) |>
  autoplot(Demand) + 
  labs(x = "half hour", y = "demand", title = "First 3000 observations of electricity demand for Victoria (Australia)")

vic_elec |>
  head (n = 1000) |>
  autoplot(Demand) + 
  geom_point() + 
  labs(x = "half hour", y = "demand", title = "First 1000 observations of electricity demand for Victoria (Australia)")

gafa_stock |>
  filter(Symbol == "AAPL") |>
  autoplot(difference(Close)) + 
  labs(x = "Trading day", y = "Difference in closing price", title = "Difference in closing price for Apple stocks")

a10 |>
  gg_season(TotalCost) + 
  labs(x = "Month", y = "Total Cost", title = "Seasonal plot for antidiabetic drug sales")

AirPassengers |>
  as_tsibble() |>
  gg_season(value, labels = "left") +
  labs(x = "Month", y = "Number of passengers in thousands", title = "Airline passengers")

vic_elec |> 
  gg_season(Demand) +
  labs(title = "Electricity demand in Victoria")

vic_elec |> 
  gg_season(Demand, period = "day") +
  labs(title = "Electricity demand in Victoria (daily season)")

vic_elec |>
  gg_season(Demand, period= "week") +
  labs(title = "Electricity demand in victoria (weekly season)") 

?EuStockMarkets
EuStockMarkets

EuStockMarkets |>
  as_tsibble() |>
  filter(key == "DAX") |>
  gg_season()

EuStockMarkets |>
  as_tsibble() |>
  filter(key == "DAX") |>
  mutate(Date = as.Date(index)) |>
  update_tsibble(index = Date) |>
  select(Date, value) -> DaxStock

DaxStock

DaxStock |>
  fill_gaps(.full = TRUE) -> DaxStockNoMissing

DaxStockNoMissing

DaxStockNoMissing |>
  gg_season(value) +
  labs(title = "DAX stock (yearly season)")

DaxStockNoMissing |>
  gg_season(value, period = "month") +
  labs(title = "DAX stock (monthly season)")

DaxStockNoMissing |>
  gg_season(value, period = "week") +
  labs(title = "DAX stock (weekly season)")

DaxStockNoMissing |>
  gg_season(value, period = 5) +
  labs(title = "DAX stock (5 day season)")

gg_season(A10, labels= "left" , polar = TRUE) + 
  ylab("Million $") +
  ggtitle("Antidiabetic drug sales - polar seasonal plot")

a10 |> gg_subseries() +
  labs(title = "Seasonal subseries plot of antidiabetic drug sales")

a11 |> gg_subseries() +
  labs(title = "Seasonal subseries plot of vitamin sales")

aus_bricks |>
  gg_subseries() + 
  labs(title = "Australian brick production")

vic_elec

vic_elec |> pivot_longer(cols = c("Demand", "Temperature"), names_to = "Attribute", values_to = "Value") -> vic_elec_long

vic_elec_long

vic_elec_long |> autoplot()

ggplot(data = vic_elec_long) +
  geom_line(mapping = aes(x = Date, y = Value)) +
  facet_wrap(vars(Attribute), scales = "free_y", nrow = 2, ncol = 1) 

ggplot(data = vic_elec) +
  geom_point(mapping = aes(x = Temperature, y = Demand)) +
  labs(title = "Scatterplot of Temperature vs. Demand for electricity in Victoria")

ggplot(data = vic_elec) +
  geom_point(mapping = aes(x = Temperature, y = Demand, color = Holiday)) +
  labs(title = "Scatterplot of Temperature vs. Demand for electricity in Victoria")

tourism
tourism |>
  distinct(Purpose)

tourism |>
  distinct(State)

tourism |> write.csv("tourism.csv")

tourism |>
  distinct(Region)

visitors <- tourism |>
  group_by(State) |>
  summarize(Trips = sum(Trips))    
visitors |> autoplot()

ggplot(data = visitors) + 
  geom_line(mapping = aes(x = Quarter, y = Trips)) +
  facet_grid(vars(State), scales = "free_y")


library("GGally")

visitors_wide <- visitors |> pivot_wider(values_from = Trips, names_from = State)
visitors_wide

ggpairs(visitors_wide, columns = 2:9)


tips

tips |> write.csv("tips.csv")

ggpairs(tips)

ggpairs(tips, columns = c(1,2,4,5,6,7), mapping = aes(color = sex))

ggpairs(tips, columns =c(1,2,4,5,6,7), mapping = aes(colour = sex), 
        lower = list(continuous = "smooth", combo = "facetdensity", discrete = "rowbar"))


ggpairs(tips, columns =c(1,2,4,5,6,7), 
        lower = list(continuous = "smooth", combo = "facetdensity", discrete = "rowbar", mapping = aes(colour = sex)))


aus_production
recent_beer <- aus_production |>
  filter(year(Quarter) >= 2000) |>
  select(Quarter, Beer)

recent_beer
recent_beer |> autoplot() +
  geom_point()

ggsave("TimeSeriesPlot_AusBeer.png")

recent_beer |> 
  gg_lag(lags = 1, geom = "point") +
  scale_color_manual(values = c("black", "red", "brown4", "royalblue")) +
  geom_point(size = 10) +
  labs(title = "Lag plot for australian beer production after 2000")

ggsave("Lag_Beer.png")

recent_beer |> 
  gg_lag(lags = 1) +
  scale_color_manual(values = c("black", "red", "brown4", "royalblue")) +
  geom_point(size = 5) +
  labs(title = "Lag plot for australian beer production after 2000")

ggsave("Lag_Beer2.png")

recent_beer |> 
  gg_lag() +
  scale_color_manual(values = c("black", "red", "brown4", "royalblue")) +
  geom_point() +
  labs(title = "Lag plot for australian beer production after 2000")

ggsave("Lag_Beer3.png")

recent_beer |> 
  gg_lag(lags = c(4,8,12, 16, 20), geom= "point") +
  scale_color_manual(values = c("black", "red", "brown4", "royalblue")) +
  labs(title = "Lag plot for australian beer production after 2000")

ggsave("Lag_Beer4.png")

a10 |> autoplot()

a10 |> gg_lag(lags = 1:24, geom = "point") +
  labs(title = "Lag plot for antidiabetic drug sales")

ggsave("Lag_Antidiabetic.png")

a10 |>
  model(stl = STL(Cost)) |>
  components() |> 
  as_tibble() |>
  mutate(NoTrend = season_year + remainder) |>
  as_tsibble(index = Month) -> a10_NoTrend

a10_NoTrend |> autoplot(NoTrend)

a10_NoTrend |> gg_lag(NoTrend, lags = 1:24, geom = "point") +
  labs(title = "Time series plot of antidiabetic drug data, after the trend was eliminated.")

ggsave("TimeSeriesPlot_Antidiabetic_NoTrend.png")

a10_NoTrend |> gg_lag(NoTrend, lags = seq(from = 12, to = 203, by = 12), geom = "point")  +
  labs(title = "Lag plot for antidiabetic drug sales data without the trend")

ggsave("Lag_AntidiabeticNoTRend.png")

a10_NoTrendL <- a10 |>
  mutate(CostLog = log(Cost)) |>
  model(stl = STL(CostLog)) |>
  components() |>
  mutate(NoTrend = season_year + remainder) |>
  as_tsibble(index = Month) -> a10_NoTrendLog

a10_NoTrendLog |> autoplot(NoTrend)

a10_NoTrendLog |> gg_lag(NoTrend, lags = seq(from = 12, to = 203, by = 12), geom = "point") +
  labs(title = "Lag plot for antidiabetic drug sales without trend and with equal seasonal components")

ggsave("Lag_Antidiabetic_NoTrendEqualSEason.png")

