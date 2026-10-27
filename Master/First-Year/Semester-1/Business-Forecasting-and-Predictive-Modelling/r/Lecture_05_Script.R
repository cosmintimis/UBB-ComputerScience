library("tidyverse")
library("fpp3")
library(cowplot) #for plot_grid
library("slider") #for the moving average

a10 <- PBS |>
  filter(ATC2 == "A10") |>
  select(Month, Concession, Type, Cost) |>
  summarize(TotalCost = sum(Cost)) |>
  mutate(Cost = TotalCost / 1000000)
a10 |> autoplot()

a10_one_year <- a10 |> head(n = 12)

#save plot in variable to display two plots on plot_grid
p1 <- a10_one_year |>
  autoplot() +
  geom_point()

p1

a10_one_year <- a10_one_year |>
  mutate(CostPerDay = Cost / days_in_month(Month))

p2 <- a10_one_year |>
  autoplot(CostPerDay) +
  geom_point() 

p2

plot_grid(p1, p2)

global_economy
ro_economy <- global_economy |>
  filter(Country == "Romania", is.na(GDP) == FALSE, is.na(Population) == FALSE)

ro_economy |>
  autoplot(GDP) +
  geom_point() +
  labs(title = "Romanian GDP") -> p1

p1

ro_economy |>
  mutate(GDPPerCapita = GDP / Population) -> ro_economy

ro_economy |> autoplot(GDPPerCapita) +
  geom_point() +
  labs(title = "Romanian GDP per capita") -> p2
p2

plot_grid(p1, p2)

ro_economy


aus_retail
aus_retail |> tail()
aus_retail |>
  distinct(Industry)

book_retail <- aus_retail |>
  filter(Industry == "Newspaper and book retailing")

book_retail |>
  group_by(Industry) |>
  index_by(Year = year(Month)) |>
  summarize(Turnover = sum(Turnover)) -> yearly_book_retail

p1 <- yearly_book_retail |> 
  autoplot(Turnover) + 
  geom_point() +
  labs(title = "Yearly turnover for newspaper and book retailing")
p1

aus_economy <- global_economy |>
  filter(Country == "Australia")
aus_economy
aus_economy |>
  autoplot(CPI) +
  geom_point() +
  labs("CPI for Australia")

yearly_book_retail
aus_economy

yearly_book_retail_CPI <- yearly_book_retail |>
  left_join(aus_economy, by = "Year")

yearly_book_retail_CPI

yearly_book_retail_CPI |>
  mutate(Adjusted_turnover = Turnover / CPI * 100) |>
  select(Year,Turnover, Adjusted_turnover) -> book_retail_CPI

book_retail_CPI

p2 <- book_retail_CPI |>
  autoplot(Adjusted_turnover) +
  geom_point() +
  labs(title = "Adjusted turnover for newspaper and book retailing")

p2

plot_grid(p1, p2, nrows = 2, ncol = 1)

food_retail <- aus_retail |>
  filter(Industry == "Food retailing") |>
  summarize(Turnover = sum(Turnover))

food_retail |>
  autoplot() +
  geom_point() +
  labs(title = "Turnover for food retail in Australia")

food_retail |>
  autoplot(sqrt(Turnover)) +
  geom_point() +
  labs(title = "Square root of turnover for food retail in Australia")

food_retail |>
  autoplot(Turnover^(1/3)) +
  geom_point() +
  labs(title = "Cube root of turnover for food retail in Australia")

food_retail |>
  autoplot(log(Turnover)) +
  geom_point() +
  labs(title = "Logarithm of turnover for food retail in Australia")

food_retail |>
  autoplot(-1/Turnover) +
  geom_point() +
  labs(title = "Inverse of turnover for food retail in Australia")

food_retail |>
  autoplot(box_cox(Turnover, 0.8)) + 
  geom_point() +
  labs(title = "Turnover for food retail after a Box Cox transformation with lambda = 0.8")

#Sequence
food_retail |> autoplot(Turnover) + geom_point()
food_retail |> autoplot(box_cox(Turnover, 1)) + geom_point()
food_retail |> autoplot(box_cox(Turnover, 0.95)) + geom_point()
food_retail |> autoplot(box_cox(Turnover, 0.9)) + geom_point()
food_retail |> autoplot(box_cox(Turnover, 0.85)) + geom_point()
food_retail |> autoplot(box_cox(Turnover, 0.8)) + geom_point()
food_retail |> autoplot(box_cox(Turnover, 0.75)) + geom_point()
food_retail |> autoplot(box_cox(Turnover, 0.7)) + geom_point()
food_retail |> autoplot(box_cox(Turnover, 0.65)) + geom_point()
food_retail |> autoplot(box_cox(Turnover, 0.6)) + geom_point()
food_retail |> autoplot(box_cox(Turnover, 0.55)) + geom_point()
food_retail |> autoplot(box_cox(Turnover, 0.5)) + geom_point()
food_retail |> autoplot(box_cox(Turnover, 0.45)) + geom_point()
food_retail |> autoplot(box_cox(Turnover, 0.4)) + geom_point()
food_retail |> autoplot(box_cox(Turnover, 0.35)) + geom_point()
food_retail |> autoplot(box_cox(Turnover, 0.3)) + geom_point()
food_retail |> autoplot(box_cox(Turnover, 0.25)) + geom_point()
food_retail |> autoplot(box_cox(Turnover, 0.2)) + geom_point()
food_retail |> autoplot(box_cox(Turnover, 0.15)) + geom_point()
food_retail |> autoplot(box_cox(Turnover, 0.10)) + geom_point()
food_retail |> autoplot(box_cox(Turnover, 0.05)) + geom_point()
food_retail |> autoplot(box_cox(Turnover, 0)) + geom_point()
food_retail |> autoplot(box_cox(Turnover, -0.1)) + geom_point()
food_retail |> autoplot(box_cox(Turnover, -0.2)) + geom_point()
food_retail |> autoplot(box_cox(Turnover, -0.3)) + geom_point()
food_retail |> autoplot(box_cox(Turnover, -0.4)) + geom_point()
food_retail |> autoplot(box_cox(Turnover, -0.5)) + geom_point()
food_retail |> autoplot(box_cox(Turnover, -0.6)) + geom_point()
food_retail |> autoplot(box_cox(Turnover, -0.7)) + geom_point()
food_retail |> autoplot(box_cox(Turnover, -0.8)) + geom_point()
food_retail |> autoplot(box_cox(Turnover, -0.9)) + geom_point()
food_retail |> autoplot(box_cox(Turnover, -1)) + geom_point()

food_retail |>
  features(Turnover, guerrero)

food_retail |> autoplot(box_cox(Turnover, 0.0895)) + geom_point()
ggsave("TimeSeriesPlot_FoodRetail_Guerrero.png")


#Decomposition

us_employment

us_retail_employment <- us_employment |>
  filter(Title == "Retail Trade", year(Month) >= 1990) |>
  select(-Series_ID, -Title)

us_retail_employment
us_retail_employment |>
  autoplot() +
  geom_point() + 
  labs(title = "US retail employment")

dcmp <- us_retail_employment |>
  model(stl = STL(Employed))
class(dcmp)
dcmp
components(dcmp)

components(dcmp) |> autoplot()

us_retail_employment |>
  autoplot(Employed, color = "gray", size = 3) +
  autolayer(components(dcmp), trend, color = "red", size = 2) +
  labs(title = "Original data (grey) and trend component (red) for the STL decomposition of the US retail employment")

components(dcmp) |>
  gg_subseries(season_year)


aus_production
beer <- aus_production |>
  select(Quarter, Beer)

beer |> autoplot() +
  geom_point() +
  labs(title = "Australian beer production")

dcmpBeer <- beer |>
  model(stl = STL(Beer))

components(dcmpBeer)

components(dcmpBeer) |>
  autoplot()

a10 |> autoplot() +
  geom_point()

dcmp_a10 <- a10 |>
  model(stl = STL(Cost))

components(dcmp_a10)

components(dcmp_a10) |>
  autoplot()


dcmp_a10L <- a10 |> model(stl = STL(log(Cost)))
components(dcmp_a10L)

components(dcmp_a10L) |>
  autoplot()

components(dcmp) |>
  ACF(remainder, lag_max = 30) |>
  autoplot() +
  geom_point() +
  labs(title = "ACF plot of the remainder for the STL decomposition of the US retail employment")

components(dcmpBeer) |>
  ACF(remainder, lag_max = 30) |>
  autoplot() +
  geom_point() +
  labs(title = "ACF plot of the remainder for the STL decomposition of the Australian Beer production")

components(dcmp_a10) |>
  ACF(remainder, lag_max = 30) |>
  autoplot() +
  geom_point() +
  labs(title = "ACF plot of the remainder for the STL decomposition of the Antidiabetic drug sales")

components(dcmp_a10L) |>
  ACF(remainder, lag_max = 30) |>
  autoplot() +
  geom_point() +
  labs(title = "ACF plot of the remainder for the STL decomposition of the log of the Antidiabetic drug sales")

us_retail_employment |>
  autoplot(Employed, color = "gray", size = 3) +
  autolayer(components(dcmp), season_adjust, color = "red", size = 2) +
  labs(title = "Original data (grey) and seasonally adjusted component (red) for the STL decomposition of the US retail employment")

vic_elec

vic_elec |>
  autoplot(Demand)

dcmp_vicElec <- vic_elec |>
  model(stl = STL(Demand))
dcmp_vicElec |> components()

dcmp_vicElec |>
  components() |>
  autoplot() 

dcmp_vicElec_short <- vic_elec |>
  head(n = 1000) |>
  model(stl = STL(Demand))

dcmp_vicElec_short |>
  components() |>
  autoplot() 

google <- gafa_stock |>
  filter(Symbol == "GOOG")
google


google |> autoplot(Close) +
  labs(title = "Google stock closing price")

dcmp_google <- google |>
  model(stl = STL(Close))

google <- google |>
  mutate(Index = seq(from = 1, to = 1258, by = 1))

google <-tsibble(Close = google$Close, Index = google$Index, index = Index)

google

dcmp_google <- google |>
  model(stl = STL(Close))

dcmp_google |> components()
dcmp_google |> 
  components() |>
  autoplot()

googleNoMissing <- gafa_stock |>
  filter(Symbol == "GOOG") 
googleNoMissing  |> 
  complete(Date = seq(as.Date("2014-01-02"), as.Date("2018-12-31"), by = "day")) |>
  as_tsibble(index = Date) -> googleNoMissing

googleNoMissing

dcmp_google2 <- googleNoMissing |>
  model(stl = STL(Close))


googleNoMissingFilled <- gafa_stock |>
  filter(Symbol == "GOOG") 
googleNoMissingFilled  |> 
  complete(Date = seq(as.Date("2014-01-02"), as.Date("2018-12-31"), by = "day")) |>
  as_tsibble(index = Date) |>
  fill(Close, .direction = "down") -> googleNoMissingFilled

googleNoMissingFilled

dcmp_google2 <- googleNoMissingFilled |>
  model(stl = STL(Close))

dcmp_google2 |> components()
dcmp_google2 |>
  components() |>
  autoplot()

#moving average

global_economy |>
  filter(Country == "Australia") |>
  select(Exports) -> aus_exports

aus_exports |> autoplot() +
  geom_point() +
  labs(title = "Exports for Australia")

aus_exports_withMA <- aus_exports |>
  mutate(MA3 = slider::slide_dbl(Exports, mean, .before = 1, .after = 1, .complete = TRUE)) |> 
  mutate(MA5 = slider::slide_dbl(Exports, mean, .before = 2, .after = 2, .complete = TRUE)) |>
  mutate(MA7 = slider::slide_dbl(Exports, mean, .before = 3, .after = 3, .complete = TRUE)) -> aus_exports_withMA

aus_exports_withMA |> tail()

aus_exports_withMA |>
  autoplot(Exports, color = "grey", size = 3) + 
  autolayer(aus_exports_withMA, MA3, color = "red", size = 2) +
  labs(title = "Exports for Australia (grey) and a 3-MA (red)")

aus_exports_withMA |>
  autoplot(Exports, color = "grey", size = 3) + 
  autolayer(aus_exports_withMA, MA5, color = "red", size = 2) +
  labs(title = "Exports for Australia (grey) and a 5-MA (red)")

aus_exports_withMA |>
  autoplot(Exports, color = "grey", size = 3) + 
  autolayer(aus_exports_withMA, MA7, color = "red", size = 2) +
  labs(title = "Exports for Australia (grey) and a 7-MA (red)")

vic_elec_daily <- vic_elec |>
  mutate(Day = as_date(Time)) |>
  index_by(Day) |>
  summarize(AVGDemand = mean(Demand))

vic_elec_daily

vic_elec_daily |>
  autoplot() +
  geom_point() +
  labs(title = "Daily average electricity demand for Victoria, Australia")

vic_elec_daily <- vic_elec_daily |> slice(90: 180)

vic_elec_daily |>
  mutate(MA3 = slider::slide_dbl(AVGDemand, mean, .before=1, .after = 1, .complete = TRUE)) |>
  mutate(MA5 = slider::slide_dbl(AVGDemand, mean, .before=2, .after = 2, .complete = TRUE)) |>
  mutate(MA7 = slider::slide_dbl(AVGDemand, mean, .before=3, .after = 3, .complete = TRUE)) |>
  mutate(MA9 = slider::slide_dbl(AVGDemand, mean, .before=4, .after = 4, .complete = TRUE)) |>
  mutate(MA11 = slider::slide_dbl(AVGDemand, mean, .before=5, .after = 5, .complete = TRUE))  ->vic_elec_daily_withMA

vic_elec_daily_withMA |>
  autoplot(AVGDemand, color = "grey", size = 3) + 
  autolayer(vic_elec_daily_withMA, MA3, color = "red", size = 2) +
  labs(title = "Daily average electricity demand ofr Victoria (grey) and a 3-MA (red)")

vic_elec_daily_withMA |>
  autoplot(AVGDemand, color = "grey", size = 3) + 
  autolayer(vic_elec_daily_withMA, MA5, color = "red", size = 2) +
  labs(title = "Daily average electricity demand ofr Victoria (grey) and a 5-MA (red)")

vic_elec_daily_withMA |>
  autoplot(AVGDemand, color = "grey", size = 3) + 
  autolayer(vic_elec_daily_withMA, MA7, color = "red", size = 2) +
  labs(title = "Daily average electricity demand ofr Victoria (grey) and a 7-MA (red)")

vic_elec_daily_withMA |>
  autoplot(AVGDemand, color = "grey", size = 3) + 
  autolayer(vic_elec_daily_withMA, MA9, color = "red", size = 2) +
  labs(title = "Daily average electricity demand ofr Victoria (grey) and a 9-MA (red)")

vic_elec_daily_withMA |>
  autoplot(AVGDemand, color = "grey", size = 3) + 
  autolayer(vic_elec_daily_withMA, MA11, color = "red", size = 2) +
  labs(title = "Daily average electricity demand ofr Victoria (grey) and a 11-MA (red)")

vic_elec_daily_withMA |>
  mutate(MA21 = slider::slide_dbl(AVGDemand, mean, .before=10, .after = 10, .complete = TRUE)) -> vic_elec_daily_withMA

vic_elec_daily_withMA |>
  autoplot(AVGDemand, color = "grey", size = 3) + 
  autolayer(vic_elec_daily_withMA, MA21, color = "red", size = 2) +
  labs(title = "Daily average electricity demand ofr Victoria (grey) and a 21-MA (red)")

beer
beer |> autoplot() +
  geom_point() +
  labs(title = "Australian beer production")

beer |> mutate(MA4 = slider::slide_dbl(Beer, mean, .before = 2, .after = 1, complete = TRUE)) |>
  mutate(MA2x4 = slider::slide_dbl(MA4, mean, .before= 0, .after = 1, complete = TRUE)) -> beer_withMA


beer_withMA |>
  autoplot(Beer, color = "grey", size = 3) +
  autolayer(beer_withMA, MA4, color = "red", size = 2) +
  autolayer(beer_withMA, MA2x4, color = "green", size = 2) +
  labs(title = "Australia beer production (grey) and 4-MA (red) and 2x4-MA (green)" )

beer_withMA_Short <- beer_withMA |> head(n = 32)
beer_withMA_Short |> autoplot(Beer, color = "grey", size = 3) +
  autolayer(beer_withMA_Short, MA4, color = "red", size = 2) +
  autolayer(beer_withMA_Short, MA2x4, color = "green", size = 2)

climate <- read_csv("DailyDelhiClimate.csv")
climate
climate_ts <- climate |> as_tsibble(index = date)
climate_ts |> autoplot(meanpressure) + 
  geom_point() +
  labs(title = "Daily mean pressure for Delhi")

climate_ts |> head(n = 700) |> autoplot(meanpressure) + 
  geom_point() 
 
climate |> summary()

position <- which(climate_ts$meanpressure == max(climate_ts$meanpressure))
position

climate_ts$meanpressure[1183] <- 1200

climate_ts_short <- climate_ts |> filter(year(date) == 2016, month(date) < 5)
climate_ts_short |> autoplot(meanpressure) + 
  geom_point() +
  labs(title = "First 4 moths of daily mean pressure for Delhi")

climate_ts_short <- climate_ts_short |>
  mutate(MA7 = slider::slide_dbl(meanpressure, mean, .before = 3, .after = 3, .complete = TRUE)) |>
  mutate(MA11 = slider::slide_dbl(meanpressure, mean, .before = 5, .after = 5, .complete = TRUE))

climate_ts_short |> autoplot(meanpressure, color = "grey", size = 3) +
  autolayer(climate_ts_short, MA7, color = "red", size = 2) +
  autolayer(climate_ts_short, MA11, color = "green", size = 2) + 
  labs(title = "Daily mean pressure for Delhi (grey) and a 7-MA (red) and 11-MA (green)")

climate_ts_short <- climate_ts_short |>
  mutate(MM7 = slider::slide_dbl(meanpressure, median, .before = 3, .after = 3, .complete = TRUE))
climate_ts_short |> autoplot(meanpressure, color = "grey", size = 3) +
  autolayer(climate_ts_short, MA7, color = "red", size = 2) +
  autolayer(climate_ts_short, MM7, color = "green", size = 2) + 
  labs(title = "Daily mean pressure for Delhi (grey) and a 7-MA (red) and 7-MM (green)")
