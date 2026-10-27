## I. Introduction to Time Series Features

Features are numerical summaries used to characterize time series. Instead of analyzing the raw data, we can look at statistics such as the mean, minimum, maximum, or more complex measures like trend and seasonality.

The **`features()`** function in R is used to compute these summaries. It returns a tibble where each row represents one time series (identified by its key) and columns contain the computed features.

---


The most frequently used mathematical transformations are:
Square root
Cube root
Take the logarithm

## II. STL Decomposition

STL stands for **Seasonal and Trend decomposition using Loess**. It decomposes a time series () into three components:

1. **Trend-cycle ()**: The long-term direction.
2. **Seasonal ()**: The repeating patterns.
3. **Remainder ()**: Everything else (noise).

### Strength of Trend and Seasonality

Based on this decomposition, we can measure how "strong" the trend or seasonality is by comparing the variance of the remainder to the variance of the trend-adjusted or seasonally-adjusted data:

* **Trend Strength ()**: Measures how much of the variation (excluding seasonality) is due to the trend. Values are between 0 and 1, where values close to 1 indicate a strong trend.
* **Seasonal Strength ()**: Measures the strength of the seasonal pattern. Values close to 1 indicate strong seasonality.

---

## III. Other Important Features

The lecture identifies several additional features that can be extracted using the `feat_stl()` function:

* **Spikiness**: Measures the prevalence of outliers in the remainder component.
* **Linearity**: Measures whether the trend component is linear.
* **Curvature**: Measures the "bend" in the trend component.
* **Seasonal Periodicity**: Identifies the length of the seasonal cycle (e.g., 4 for quarterly, 12 for monthly).
* **Seasonal Peak and Trough**: Indicates which time unit (month/quarter) contains the highest and lowest seasonal effects.

---

## IV. The Feature Space and Visualization

When dealing with hundreds or thousands of time series (e.g., sales data for many different products), analyzing each one individually is impossible.

### Feature-Based Analysis

* We can compute features for all series and use them to find series with similar patterns.
* Scatterplots of features (e.g., Trend Strength vs. Seasonal Strength) help identify groups of series or **outliers**—series that behave very differently from the rest.

### Dimensionality Reduction (PCA)

* **Principal Component Analysis (PCA)** is used when we have many features.
* It combines many features into a few "Principal Components" (PC1, PC2, etc.) that capture the most important information.
* Plotting PC1 vs. PC2 allows for a global view of all time series to identify clusters or anomalies.

### Moving averages
Moving averages are needed in order to estimate the
trend-cycle component in the classical decomposition