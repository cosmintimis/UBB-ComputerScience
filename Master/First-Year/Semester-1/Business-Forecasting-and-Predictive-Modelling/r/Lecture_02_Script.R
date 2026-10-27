#install.packages("tidyverse")
#install.packages("fpp3")

library("tidyverse")
library("fpp3")

data()
view(co2)
view(melb_walkers)
view(starwars)
view(cars)

?data
data(package = "fpp3")
?co2
?starwars
?cars

class(cars)
class(starwars)
class(melb_walkers)

dim(cars)
dim(starwars)

count(cars)
class(count(cars))
class(dim(starwars))

head(starwars)
tail(starwars)

head(starwars, n = 10)

cars
starwars

#data frames
cars$speed
class(cars$speed)

cars[1]
cars[2]
cars[1, ]
cars[10, ]
cars[, 2]
cars[, 1]
cars[, 1][5]
cars
cars[1,2]
cars[2,2]

#read from CSV
df <- read.csv("Brent Spot Price.csv")
df
dim(df)
class(df)

#tibble
class(starwars)
dim(starwars)
head(starwars)
starwars[1,]
starwars[1,]$name

tbl <- read_csv("Brent Spot Price.csv")
class(tbl)
spec(tbl)
tbl

wines <- read.csv("wine.csv")
class(wines)

wines_tbl <- as_tibble(wines)
class(wines_tbl)


wines_df <- as.data.frame(wines_tbl)
wines_df
class(wines_df)

# library(readxl)
# wines_ex <- read_excel("d:/Teaching and stuff/Teaching/2025-2026/FPM/Lectures & Scripts/wineExcel.xlsx")
# class(wines_ex)
# 
# wines_tbl[1,]
# class(wines_tbl[1,])
# wines_tbl[, 1]
# class(wines_df[, 1])
# 
# olympic_running
# head(olympic_running)
# dim(olympic_running)
# olympic_running$Length
# olympic_running$Year
# olympic_running[1,]


write_csv(olympic_running, "Olympic_running.csv")

x <- data.frame(
  a = 2:10,
  b = c('a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i')
  
)
x
class(x)


y <- tibble(
  a = 2:10,
  b = 12:20,
  c = c('a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i')
)
y

class(y)


y <- tsibble(
  Year = 2015:2019,
  Observation = c(11, 52, 31, 76, 12),
  index = Year
)
y
class(y)

view(olympic_running)
olympic_running

w <- tsibble(
  Year = c(2011, 2012, 2013, 2014, 2011, 2012, 2013, 2014),
  Specializations = c("CS", "CS", "CS", "CS", "DS", "DS", "DS", "DS"),
  index = Year,
  key = Specializations
)
w
class(w)

#Dates
q1 <- yearquarter("2010 Q1")
q1
q2 <- yearquarter("2010 Quarter 2")
q2
q3 <- yearquarter("2010-04-01")
q3
q4 <- yearquarter("2010-04-01", fiscal_start = 7)
q4
?yearquarter
q5 <- make_yearquarter(year = 2010, quarter = 4)
q5

q6 <- make_yearquarter(year = rep(2010:2019, each = 4), quarter = rep(1:4, 10))
q6

m1 <- yearmonth("2010 April")
m1
m2 <- yearmonth("2010 07")
m2
m3 <- yearmonth("2010-08-29")
m3
m4 <- yearmonth("October 2010")
m4
m5 <- yearmonth("22-05-2023")
m5 <- yearmonth("22-05-2023", format="%d-%m-%y")
m5
m6 <-make_yearmonth(year = 2020, month = 11)
m6
m7 <- make_yearmonth(year = rep(2020:2023, each = 12), month = rep(1:12, 4))
m7
m8 <- yearmonth("2020 M06")
m8


w1 <- yearweek("2020 Week4")
w1
w2 <- yearweek("2020 W25")
w2
w3 <- yearweek("2023-10-12")
w3
w4 <- yearweek("2023-10-12", week_start = 7)
w4
w5 <- yearweek("2023 Wk40")
w5
w6 <- yearweek("2023-02")
w6
w7 <- make_yearweek(year = 2022, week = 5)
w7
w8 <- make_yearweek(year = 2022, week = 60)
w8
w9 <- make_yearweek(year = 2020, week = 53)
w9
w10 <- make_yearweek(year = 2021, week = 53)
w10

is_53weeks(2021)
is_53weeks(2020)

d1 <- as_date("2023-09-30")
d1
d2 <- as_date("2023 09 25")
d2
d3<- ymd("2020-06-15")
d3
d4 <- ymd(20200605)
d4
d5 <- ymd("Date is 2020 12 22")
d5
s1 <- seq(as_date("2020-01-01"), as_date("2020-03-20"), by = "1 day")
s1

weeks <- seq(as_date("2020-01-01"), as_date("2020-03-20"), by = "1 week")
weeks
weeks <- yearweek(weeks)
weeks

months <- seq(as_date("2020-01-01"), as_date("2020-06-30"), by = "1 month")
months
months <- yearmonth(months)
months

dt1 <- ymd_hms("2023-09-30 01:00:00")
dt1
dt2 <- ymd_hm("2023-09-30 02:50")
dt2
dt3 <- as_datetime("2013-05-25 14:00:00.00")
dt3


#Piping
read.csv("Brent Spot Price.csv") |>
  mutate(X = yearmonth(X)) |>
  as_tsibble(index = X) -> exTsibble
exTsibble


#Tabular data
read.csv("Brent Spot Price.csv") |>
  mutate(Date = yearmonth(X)) |>
  mutate(Price = Brent.crude.oil.spot.price..Monthly..dollars.per.barrel.) |>
  as_tsibble(index = Date) -> exTsibble
exTsibble  

olympic_running |>
  mutate(AverageTime = (Time / Length)) -> olympic_running_avg
olympic_running_avg

read.csv("Brent Spot Price.csv") |>
  mutate(Date = yearmonth(X)) |>
  mutate(Price = Brent.crude.oil.spot.price..Monthly..dollars.per.barrel.) |>
  as_tsibble(index = Date) |>
  select(Date, Price) -> exTsibble
exTsibble  


read.csv("Brent Spot Price.csv") |>
  mutate (Date = yearmonth(X)) |>
  mutate(Price = Brent.crude.oil.spot.price..Monthly..dollars.per.barrel.) |>
  as_tsibble(index = Date) |>
  select(-X, -Brent.crude.oil.spot.price..Monthly..dollars.per.barrel.) -> exTsibble
exTsibble  

olympic_running |> 
  distinct(Sex)

olympic_running |>
  distinct(Length)

olympic_running |>
  distinct(Sex, Length)

olympic_running |>
  distinct(Year) |>
  print(n = 20)

olympic_running |>
  filter (Sex == "men")

olympic_running |>
  filter(Sex == "men", Length == "100")

olympic_running |>
  filter(Year == 1900)

olympic_running |>
  mutate(AverageTime = Length / Time) |>
  filter(AverageTime > 9)

olympic_running |>
  filter(is.na(Time) == TRUE)

olympic_running |>
  filter(is.na(Time) == TRUE) |>
  view()

olympic_running |>
  filter(is.na(Time) == TRUE) |>
  write_csv("FilteredOlympic.csv")

olympic_running |>
  slice(1:20)

olympic_running |>
  unite(NewColName, Length, Sex, Time, sep = "-")

olympic_running |>
  unite(NewColName, Length, Sex, Time, sep = "-", remove = FALSE) -> olympic_name

olympic_name

olympic_name |>
  as_tsibble(index = Year, key = c(Length, Sex)) -> olympic_name_ts

olympic_name_ts

wines <- read_csv("wine.csv")             
summary(wines)
summary(wines$Rose)
sum(wines)
sum(wines$Rose)


wines |>
  filter(Year == 1985) |>
  select(Rose) |>
  sum()

#autoplot
olympic_running |> view()

olympic_running |>
  filter(Sex == "men", Length == 100) -> men100

men100
men100 |> autoplot()

olympic_running |>
  filter(Sex == "men", Length == 100) |>
  mutate(AvgTime = Length / Time) -> men100Avg

men100Avg
men100Avg |> autoplot()
men100Avg |> autoplot(AvgTime)

men100 |> autoplot() +
  labs(x = "Year", y = "Running time", 
       title = "Running times at the olympic games", subtitle = "100 meters men", 
       caption = "Plot of running times for the 100 meters men at the olympic games from 1896 to 2016")

wines |>
  unite(Date, Year, Month, sep = "-") |> 
  mutate(Date = yearmonth(Date)) |>
  as_tsibble(index = Date) ->winesTs

winesTs
autoplot(winesTs)
autoplot(winesTs, Red)

winesTs |>
  slice(1:24) |>
  autoplot(Total)


autoplot(winesTs, Total) +
  autolayer(winesTs, Red)

autoplot(winesTs, Total, color = "Green") +
  autolayer(winesTs, Red, color = "Red") + 
  autolayer(winesTs, Fortified, color = "Blue")


#Long and wide
olympic_running |> autoplot()

winesTs |> autoplot()

winesTs |> 
  pivot_longer(Red, names_to = "Type", values_to = "QuantitySold") -> winesLonger
winesLonger

winesTs |> 
  pivot_longer(c(Fortified, Drywhite, Sweetwhite, Rose, Red, Sparkling, Total), names_to = "Type", values_to = "QuantitySold") -> winesLong
winesLong

winesLong |> autoplot()

olympic_running |> 
  pivot_wider(names_from= Sex, values_from = Time) -> olympic_running_wider
olympic_running_wider |> view()

olympic_running |> 
  pivot_wider(names_from= c(Sex), values_from = Time) |>
  pivot_wider(names_from = c(Length), values_from= c(men, women)) -> olympic_running_wider
olympic_running_wider |> view()
autoplot(olympic_running_wider)


#penguins
penguins <- read_csv("penguins.csv")


ggplot(data = penguins)


ggplot(data = penguins,
       mapping = aes(x = flipper_length_mm, y = body_mass_g))


ggplot(data = penguins,
       mapping = aes(x = flipper_length_mm, y = body_mass_g)) +
  geom_point()

ggplot(data = penguins, mapping = aes(x = flipper_length_mm, y = body_mass_g)) +
  geom_point() +
  labs(title = "Plot of penguin flipper length vs body mass", x = "Flipper length in milimeters", y = "Body mass in grams")

penguins |> 
  filter(is.na(flipper_length_mm) == FALSE & is.na(body_mass_g)== FALSE) -> penguinsNoNA

cor(penguinsNoNA$flipper_length_mm, penguinsNoNA$body_mass_g)    

ggplot(data = penguins,
       mapping = aes(x = flipper_length_mm, y = body_mass_g, color = species)) +
  geom_point() +
  labs(title = "Plot of penguin flipper length vs body mass", x = "Flipper length in milimeters", y = "Body mass in grams")


penguinsNoNA |> filter(species == "Adelie") ->penguinsAdelie
penguinsNoNA |> filter(species == "Chinstrap") -> penguinsChinstrap
penguinsNoNA |> filter(species == "Gentoo") -> penguinsGentoo   

cor(penguinsAdelie$flipper_length_mm, penguinsAdelie$body_mass_g)
cor(penguinsChinstrap$flipper_length_mm, penguinsChinstrap$body_mass_g)
cor(penguinsGentoo$flipper_length_mm, penguinsGentoo$body_mass_g)


ggplot(data = penguins,
       mapping = aes(x = flipper_length_mm, y = body_mass_g, color = species)) +
  geom_point() +
  geom_smooth(method = "lm")


ggplot(data = penguins,
       mapping = aes(x = flipper_length_mm, y = body_mass_g)) +
  geom_point(mapping = aes(color = species)) +
  geom_smooth(method = "lm")


ggplot(data = penguins, mapping = aes(x = flipper_length_mm, y = body_mass_g)) +
  geom_point(mapping = aes(color = species)) +
  geom_smooth(method = "lm", se = FALSE) +
  labs(title = "Plot of penguin flipper length vs body mass and the best fit linear model", x = "Flipper length in milimeters", y = "Body mass in grams")

ggplot(data = penguins, mapping = aes(x = flipper_length_mm, y = body_mass_g)) +
  geom_point(mapping = aes(color = species)) +
  geom_smooth(method = "lm", level = 0.99)  + 
  labs(title = "Plot of penguin flipper length vs body mass and the best fit linear model", x = "Flipper length in milimeters", y = "Body mass in grams")


ggplot(data = penguins, mapping = aes(x = flipper_length_mm, y = body_mass_g, 
                                      color = species, size = bill_length_mm, alpha = bill_length_mm)) +
  geom_point() +
  labs(title = "Plot of penguin flipper length vs body mass", x = "Flipper length in milimeters", y = "Body mass in grams")

ggplot(data = penguins, mapping = aes(x = flipper_length_mm, 
                          y = body_mass_g, color = species, size = sex)) +
  geom_point() +
  labs(title = "Plot of penguin flipper length vs body mass", x = "Flipper length in milimeters", y = "Body mass in grams")


ggplot(data = penguins,  mapping = aes(x = flipper_length_mm, y = body_mass_g)) +
  geom_point(shape = "square", color = "tan") +
  labs(title = "Plot of penguin flipper length vs body mass", x = "Flipper length in milimeters", y = "Body mass in grams")


colors()


ggplot(data = penguins,  mapping = aes(x = flipper_length_mm, y = body_mass_g, color = species)) +
  geom_point( shape = "square") +
  labs(title = "Plot of penguin flipper length vs body mass", x = "Flipper length in milimeters", y = "Body mass in grams") + 
  scale_color_manual(values = c("magenta", "salmon", "tan", "yellow"))


ggplot(data = penguins, mapping = aes(x = flipper_length_mm, y = body_mass_g, color = species, shape = species)) +
  geom_point() +
  facet_wrap(vars(island)) +
  labs(title = "Plot of penguin flipper length vs body mass", x = "Flipper length in milimeters", y = "Body mass in grams")


ggplot(data = penguins, mapping = aes(x = flipper_length_mm, y = body_mass_g, color = sex, shape = sex)) +
  geom_point() +
  facet_wrap(vars(island, species), nrow = 3, ncol = 3) +
  labs(title = "Plot of penguin flipper length vs body mass", x = "Flipper length in milimeters", y = "Body mass in grams")   


ggplot(data = penguins, mapping = aes(x = species)) +
  geom_bar()

ggplot(data = penguins, mapping = aes(x = species)) +
  geom_bar(color = "red") 

ggplot(data = penguins, mapping = aes(x = species)) +
  geom_bar(color = "red", fill = "red")

ggplot(data = penguins, mapping = aes(x = species)) +
  geom_bar(mapping = aes(fill = island)) 

ggplot(data = penguins, mapping = aes(x = body_mass_g)) +
  geom_histogram()

ggplot(data = penguins, mapping = aes(x = body_mass_g)) +
  geom_histogram(binwidth = 200)
ggsave(filename = "penguin-plot.png")

myplot <- ggplot(data = penguins, mapping = aes(x = species)) + 
  geom_bar()
#do other stuff here
ggsave(filename = "penguin-plot2.png", plot = myplot)

