## I. Time Series Patterns

When analyzing time series data, we look for three primary components:

* **Trend**: Exists when there is a long-term increase or decrease in the data. It does not have to be linear; it can change direction.
* **Seasonal**: Occurs when a time series is affected by seasonal factors such as the time of year or the day of the week. Seasonality is always of a fixed and known period.
* **Cyclic**: Occurs when the data exhibit rises and falls that are not of a fixed frequency. These fluctuations are usually due to economic conditions and are often related to the "business cycle".

> **Note**: It is important to distinguish between "seasonal" and "cyclic" patterns. Seasonal patterns have a constant length, whereas cyclic patterns have variable lengths, usually longer than two years.

---

## II. Seasonal Plots

Seasonal plots allow us to see the data from each season (e.g., each year) superimposed on each other to identify patterns.

* **`gg_season()`**: This function plots the data against the individual "seasons" in which the data is observed.
* **Usage**: In the example of Australian holiday trips, a seasonal plot helps identify which quarter consistently has the highest number of trips.
* **Sub-daily Data**: For data with high frequency (e.g., hourly), the `period` parameter can be used to define the season, such as `period = "day"` or `period = "week"`.

---

## III. Seasonal Subseries Plots

While a seasonal plot groups data by years, a **seasonal subseries plot** emphasizes the seasonal pattern by grouping data from the same season together.

* **`gg_subseries()`**: This function creates separate mini-plots for each season.
* **Features**:
* Blue horizontal lines indicate the **mean** for each specific season across the entire dataset.
* It helps clearly see the changes within a season over time.



---

## IV. Lag Plots and Autocorrelation

Understanding how current values relate to previous values is critical for time series modeling.

### 1. Lag Plots

* **Definition**: A lag plot displays the relationship between  (the value at time ) and  (the value at time , known as "lag ").
* **Function**: `gg_lag(geom = "point")` creates a grid of scatterplots for different lags.
* **Interpretation**: A strong positive relationship in a lag plot suggests strong autocorrelation at that lag.

### 2. Autocorrelation Function (ACF)

* **Definition**: Autocorrelation measures the linear relationship between lagged values of a time series.
* **ACF Plot (`ACF()`)**: Displays the correlation coefficients () for various lags.
* **Relationship to Patterns**:
* **Trended data**: ACF plots typically show large, positive values for small lags that decrease slowly as lags increase.
* **Seasonal data**: ACF plots show higher correlations at the seasonal lags (multiples of the seasonal period).
* **Trend + Seasonality**: Both effects appear in the ACF plot.



---

## V. White Noise

**White noise** refers to time series data that shows no patterns or correlations.

* **Characteristics**: For white noise, the autocorrelations () should be close to zero.
* **Critical Values**: We expect 95% of the spikes in an ACF plot to lie within the bounds , where  is the length of the time series.
* **Significance**: If more than 5% of spikes are outside these bounds, or if a single spike is very large, the series is likely not white noise.