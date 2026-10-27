library("tidyverse")
library("fpp3")

aus_production

recent_beer <- aus_production |>
  filter(year(Quarter) >= 2000) |>
  select(Quarter, Beer)

recent_beer |> 
  autoplot() + 
  geom_point() +
  labs(title = "Recent beer production")

acf <- recent_beer |> ACF()
acf 
class(acf)
class(aus_production)


acf |> as_tsibble() |>autoplot()
acf |> autoplot() + 
  geom_point() +
  labs(title = "ACF plot for recent beer production")

a10 <- PBS |>
  filter(ATC2 == "A10") |>
  select(Month, Concession, Type, Cost) |>
  summarize(TotalCost = sum(Cost)) |>
  mutate(Cost = TotalCost / 1000000)

a10 |> autoplot() +
  geom_point() +
  labs(title = "Antidiabetic drug sales")

a10 |> ACF() |> 
  autoplot() +
  geom_point() +
  labs(title = "ACF plot for antidiabetic drug sales")

a10 |> ACF(lag_max = 60) |>
  autoplot() + geom_point() +
  labs(title = "ACF plot for antidiabetic drug sales")

vic_elec

vic_elec |> autoplot() +
  labs(title= "Electricity demand in Victoria, Australia")

vic_elec |> ACF(Demand, lag_max = 480) |>
  autoplot() +
  labs("ACF plot for electricity demand in Victoria")


aus_livestock
?aus_livestock

aus_livestock |>
  filter(Animal == "Pigs", State == "Victoria", year(Month) >= 2014) -> aus_pigs

aus_pigs |> autoplot() +
  geom_point() +
  labs(title = "Number of pigs slaughtered in Victoria")

aus_pigs |>
  ACF() |>
  autoplot() +
  geom_point() +
  labs(title = "ACF plot for pigs slaugthered in Victoria")

aus_pigs |>
  ACF(lag_max = 50) |>
  autoplot() +
  geom_point() +
  labs(title = "ACF plot for pigs slaugthered in Victoria")

set.seed(39)
wn <- tsibble(sample = 1:50, wn = rnorm(50), index =  sample)
wn |> autoplot() + 
  geom_point() +
  labs(title = "50 samples of random values")


wn |> ACF() |>
  autoplot() +
  geom_point() +
  labs(title = "ACF of 50 random points")

aus_production

aus_gas <- aus_production |>
  select(Quarter, Gas)

aus_gas
aus_gas |> autoplot() + 
  geom_point() + 
  labs(title=  "Australian gas production")

aus_gas |> ACF(lag_max = 40) |> 
  autoplot() + 
  geom_point() + 
  labs(title = "ACF of Australian Gas production")

gafa_stock
google_2018 <- gafa_stock |>
  filter(Symbol == "GOOG", year(Date) == 2018)

google_2018 |>
  autoplot() +
  geom_point() +
  labs(title = "Google opening stock price in 2018")

google_2018 |>
  ACF() |>
  autoplot() +
  geom_point() +
  labs(title = "ACF of Google opening stock price in 2018")


google_2018 |>
  autoplot(difference(Open)) +
  geom_point() +
  labs(title = "Difference of Google opening stock price in 2018")


google_2018 |>
  ACF(difference(Open)) |>
  autoplot() +
  geom_point() +
  labs(title = "ACF of difference of Google opening stock price in 2018")


google_2018 |>
  autoplot(Close) +
  geom_point() +
    labs(title = "Google closing stock price in 2018")

google_2018 |>
  ACF(Close) |>
  autoplot() +
  geom_point() +
  labs(title = "Google closing stock price in 2018")

?features

google_2018 |>
  features(Close, unitroot_kpss)

library("tseries")

adf.test(google_2018$Close)


google_2018 |>
  autoplot(difference(Close)) +
  geom_point() +
  labs(title = "Difference of Google closing stock price in 2018")


google_2018 |>
  ACF(difference(Close)) |>
  autoplot() +
  geom_point() +
  labs(title = "ACF of difference of Google closing stock price in 2018")

google_2018 |>
  mutate(D = difference(Close))

google_2018 |>
  features(difference(Close), unitroot_kpss)

adf.test(difference(google_2018$Close) |> na.omit() )

aus_pigs 
aus_pigs |> autoplot()

aus_pigs |> features(Count, unitroot_kpss)

adf.test(aus_pigs$Count)

lynx |> as_tsibble(index = Month) |> autoplot() + geom_point()

lynx |>
  as_tsibble(index = Month) |> 
  ACF(value) |>
  autoplot() +
  geom_point() +
  labs(title = "ACF of the lynx population")


lynx |>
  as_tsibble(index = Month) |>
  features(value, unitroot_kpss)

lynx_ts <- lynx |> as_tsibble()

adf.test(lynx_ts$value)

?aus_births
aus_births

aus_births |>
  filter(State == "VIC") ->vic_births

vic_births |>
  autoplot() + 
  labs(title = "Births in Victoria")

vic_births |>
  head(n = 70) |>
  autoplot() +
  geom_point()

vic_births |>
  ACF() |>
  autoplot() +
  geom_point() +
  labs(title = "ACF of the number of births in Victoria")

vic_births |> features(Births, unitroot_kpss)

adf.test(vic_births$Births)

vic_births <- vic_births |>
  mutate(BirthsD = difference(Births))

vic_births

vic_births |>
  autoplot(BirthsD) + 
  labs(title = "Difference of births in Victoria")

vic_births |>
  ACF(BirthsD) |>
  autoplot() +
  geom_point() +
  labs(title = "ACF of the difference of the number of births in Victoria")

vic_births |> features(BirthsD, unitroot_kpss)

adf.test(vic_births$BirthsD |> na.omit())

vic_births <- vic_births |> 
  mutate(BirthsSDiff = difference(Births, 12))

vic_births |> head(n = 15)

vic_births |>
  autoplot(BirthsSDiff) + 
  labs(title = "Seasonal difference of Births in Victoria")

vic_births |>
  ACF(BirthsSDiff) |>
  autoplot() +
  geom_point() +
  labs(title = "ACF of the seasonal difference of the number of births in Victoria")

vic_births |> features(BirthsSDiff, unitroot_kpss)

adf.test(vic_births$BirthsSDiff |> na.omit())

beer <- aus_production |>
  select(Beer)

beer

beer |> autoplot() +
  geom_point() +
  labs(title = "Beer production in Australia")

beer |> 
  ACF() |>
  autoplot() +
  geom_point() +
  labs(title = "ACF of beer production in Australia")

beer |>
  features(Beer, unitroot_kpss)

beer <- beer |> mutate(BeerSD = difference(Beer, 4))

beer |> autoplot(BeerSD) +
  geom_point() +
  labs(title = "Seasonally difference beer production in Australia")

beer |> 
  ACF(BeerSD) |>
  autoplot() +
  geom_point() +
  labs(title = "ACF of seasonally differenced  beer production in Australia")

beer |>
  features(BeerSD, unitroot_kpss)

beer <- beer |>
  mutate(BeerSD_D = difference(BeerSD, 1))

beer |> autoplot(BeerSD_D) +
  geom_point() +
  labs(title = "Differenced and seasonally differenced beer production in Australia")

beer |> 
  ACF(BeerSD_D) |>
  autoplot() +
  geom_point() +
  labs(title = "ACF of differenced  and seasonally differenced beer production in Australia")

beer |>
  features(BeerSD_D, unitroot_kpss)


beer |> features(Beer, unitroot_ndiffs)
beer |> features(Beer, unitroot_nsdiffs)
beer |> features(Beer, c(unitroot_ndiffs, unitroot_nsdiffs))

vic_births |> autoplot()
vic_births |> features(Births, c(unitroot_ndiffs, unitroot_nsdiffs))

vic_births |> features(difference(Births, 12), c(unitroot_ndiffs, unitroot_nsdiffs)) 

vic_births |> features(difference(Births, 1), c(unitroot_ndiffs, unitroot_nsdiffs))

google_2018 <- gafa_stock |> 
  filter(Symbol == "GOOG", year(Date) == 2018) |>
  select(Date, Close)

google_2018
google_2018 |> autoplot() + geom_point()
google_2018 |> ACF() |> 
  autoplot() + geom_point()
max(google_2018$Close)
min(google_2018$Close)
mean(google_2018$Close)

google_2018 |> autoplot(difference(Close)) + geom_point() 
google_2018 |> features(difference(Close), unitroot_kpss)

google_2018 |> ACF(difference(Close)) |> 
  autoplot() + geom_point()

#first value after difference is NA. max, min, mean cannot handle it
diff <- difference(google_2018$Close) |> tail(250)
diff
max(diff)
min(diff)
mean(diff)
