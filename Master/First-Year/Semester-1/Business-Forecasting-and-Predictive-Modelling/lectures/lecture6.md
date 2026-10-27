## Time Series Decomposition - Methods Overview

### Classical Decomposition (1920)
The classical method splits a time series into:
- **Trend (T)**: Long-term movement
- **Seasonality (S)**: Regular periodic patterns
- **Remainder (R)**: What's left after removing trend and seasonality

**Additive model**: yt = St + Tt + Rt
**Multiplicative model**: yt = St × Tt × Rt

**Process**:
1. Compute moving average (m-MA or 2×m-MA) to estimate trend
2. Remove trend to get detrended series
3. Calculate seasonal component by averaging detrended values for each season
4. Compute remainder by removing trend and seasonal components

**Disadvantages**:
- No trend estimates for first/last observations
- Over-smooths rapid changes
- Cannot capture changing seasonal patterns
- Not robust to outliers

### X-11 Decomposition (1957, US Census Bureau)
An improved version of classical decomposition that:
- Provides trend estimates for all data points
- Allows seasonal component to vary slowly over time
- Handles holiday effects and trading day variations
- Works only with monthly and quarterly data
- Uses Henderson moving averages with special pre-defined weights
- Applies iterative refinement process (9 steps total)

### SEATS Method (1990s)
"Seasonal Extraction in ARIMA Time Series"
- Uses ARIMA forecasting to extend the series
- Provides estimates at endpoints
- Allows changing seasonality
- Limited to quarterly and monthly data

### STL Decomposition (1990)
"Seasonal and Trend decomposition using Loess"

**Advantages**:
- Works with any type of seasonality (weekly, monthly, quarterly, etc.)
- Seasonal pattern can change over time (rate controlled by user)
- Provides smoother trend estimates (smoothness controlled by user)
- Automatic parameter selection
- Robust to outliers (when robust flag is set)
- Customizable through parameters

**Key parameters**:
- **Trend window**: Controls how fast trend can change (default: 21)
- **Season window**: Number of consecutive years for seasonal estimation (default: 13, can be "periodic")
- **Robust**: Whether to use robust decomposition
- **Iterations**: Number of iterations to perform

**Disadvantage**: Only performs additive decomposition

### MSTL - Multiple Seasonal-Trend Decomposition (2021)
Extension of STL for multiple seasonalities:
- yt = Tt + S₁t + S₂t + ... + Sₙt + Rt
- Handles daily, weekly, monthly patterns simultaneously
- Accurate, computationally efficient, and robust
- Implemented in R's STL function with multiple periods

## Time Series Features

Features are numerical values describing time series properties:

### Basic Features
- Mean, minimum, maximum, quantiles

### Autocorrelation Features (feat_acf)
- First autocorrelation coefficient
- Sum of squares of first 10 autocorrelation coefficients
- Same features for differenced and twice-differenced data
- Seasonal lag autocorrelation (for seasonal data)

### STL-based Features (feat_stl)

**Strength of Trend**: FT = max(0, 1 - Var(Rt)/Var(Tt + Rt))
- Close to 1: strongly trended data
- Close to 0: little or no trend

**Strength of Seasonality**: FS = max(0, 1 - Var(Rt)/Var(St + Rt))
- Close to 1: strong seasonality
- Close to 0: no seasonality

**Other STL features**:
- seasonal_peak_year: Month/quarter with largest values
- seasonal_trough_year: Month/quarter with lowest values
- spikiness: Prevalence of spikes in remainder
- linearity: How linear the trend is
- curvature: Curvature of trend component
- stl_e_acf1, stl_e_acf10: Autocorrelation features of remainder

### Computing All Features
Using `feature_set(pkgs = "feasts")` computes 48 features total for each time series, useful for exploring and comparing multiple time series.

Classical decomposition breaks down a time series into its fundamental components to help us understand the underlying patterns and make better forecasts. The method works by first isolating the trend using moving averages (2×m-MA for even periods or m-MA for odd periods), which smooths out short-term fluctuations to reveal the long-term direction of the data. Next, we remove this trend from the original data to get the detrended series, which contains only seasonality and randomness. We then estimate the seasonal component by averaging the detrended values for each season (like averaging all January values, all February values, etc.) and adjust these averages to sum to zero, creating a repeating seasonal pattern across all years. Finally, we calculate the remainder by subtracting both the trend and seasonal components from the original data, leaving us with the irregular, unpredictable fluctuations.
Why do this? Decomposition serves several critical purposes: (1) it helps us understand what drives our data by separating long-term trends from regular seasonal patterns and random noise, (2) it enables better forecasting by allowing us to model each component separately and then recombine them, (3) it facilitates seasonally adjusted analysis by removing seasonal effects to see the true underlying trends (like economists do with employment data), and (4) it helps identify anomalies by examining the remainder component for unusual patterns that don't fit the trend or seasonal behavior. Essentially, it transforms one complex problem (modeling the entire time series) into three simpler problems (modeling trend, seasonality, and remainder separately).

Some problems/disadvantages of the classical decomposition method: You do not have trend-cycle estimates for the first and last few observations (since the moving average is not computed for these). The trend-cycle tends to over-smooth rapid rises and falls in data. It cannot capture if seasonal patterns change over time (it just repeats the same sequence of data) Not robust for unusual data (for example: changes in monthly air passenger traffic due to a strike). In practice, it is not recommended to use the classical decomposition anymore, since there are better alternatives.

According to the above document, the X11 algorithm is the
following, assuming monthly data and multiplicative
decompositions:

Use a 2x12-MA to create an initial estimate of the trend
component. 6 values at both ends will not have trend values.

Remove the trend from the series (by dividing by it), leaving
only the seasonal and irregular/random/remainder
components.

Build a preliminary estimate of the seasonal component, by
applying a 3x3-MA on the detrended season for each month
separately. Missing values at the ends are replaced by
repeating the previous year’s pattern.

Compute the seasonally adjusted time series, by dividing the
original one by the seasonal component.

Re-estimate the trend, by applying a 9, 13 or 23 term
Henderson moving average to the seasonally adjusted values.
Use asymetric filters at the end to have an estimate for every
time step

Divide the original time series by this new estimate of trend
and re-estimate the season again (repeat step 3).


Final estimate of seasonally adjusted data is computed by
dividing the original time series by this new seasonal
component.


 Compute the final estimate of the trend component by
applying a 9, 13 or 23 term Henderson moving average.


Compute the final estimate of the irregular component, by
diving the time series by the trend and the seasonal
component.


### SEATS 
- allows estimates at the endpoints and it allows
changing seasonality, but, similar to X11, it only works for
quarterly and monthly data.

---

Advantages of STL:
Flexible: it can handle a wide range of time series, including
ones where the seasonal pattern changes over time (and the
rate of change can be controlled by the user). It can also
handle any type of seasonality (weekly, monthly, quarterly, etc.)
Improved accuracy: it can provide a smoother estimate of the
trend than the classical decomposition. Smoothness of the
trend can also be controlled by the user.
Automatic parameter selection: the method automatically
selects the best parameters
Customizability: on the other hand, through different
parameters, it offers the possibility to fine-tune the
decomposition according to the characteristics of the data.
Robust: user can specify that they want a robust
decomposition, and then occasional unusual observations will
not affect the trend and seasonal components (only the
remainder will be affected).

Disadvantages of STL:
Can only do additive decomposition (for other types of time
series transformations are needed).


OESS is a regression method, which fits a curve to a set of
points, but this curve is built by fitting several models on
subsets of the data (for every point, only points in its
neighbourhood are considered).


### Multiple Seasonal-Trend Decomposition using Loess (MSTL)


Remember, autocorrelation is the correlation between a time
series and its lagged version (version with some time steps
behind).
We have talked about the acf plot, where autocorrelation
values for different lags are visualized.
But we can compute new numerical features from
autocorrelation, for example, the sum of squares for the first
10 autocorrelations is an indicator of how much
autocorrelation is in the data in general.
We can also difference the data and compute autocorrelation
in this new series (both for simple and seasonal differences).
We can difference the already differenced data as well and
compute autocorrelation features for this as well.

Other STL features:
seasonal peak year - which month or quarter contains the
largest values (the peak of the season). For example, in
tourism data, if the peak is Q1, people are travelling more in
winter (except if we are talking about Australia, because Q1 is
summer there).
seasons through year - which month or quarter contains the
lowest values
spikiness - measures the prevalence of spikes in the remainder
linearity - how linear the trend component is
curvature - measures the curvature of the trend component
stl e acf1 - the first autocorrelation value of the remainder
stl e acf10 - the sum of the squares of the first 10
autocorrelation features

