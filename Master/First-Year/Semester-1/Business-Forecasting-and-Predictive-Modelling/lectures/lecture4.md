## Main Topics Covered

### 1. Autocorrelation

**Computing Autocorrelation:**
- Autocorrelation measures correlation between a time series and its lagged values
- For lag k, the autocorrelation coefficient rk measures correlation between yt and yt−k
- Formula: rk = ∑(yt − ȳ)(yt−k − ȳ) / ∑(yt − ȳ)²
- In R: use `ACF()` function, visualize with `autoplot()`

**Interpreting ACF Plots:**
- **Seasonal data**: High autocorrelation at lags that are multiples of the frequency (e.g., lags 4, 8, 12 for quarterly data)
- **Trended data**: High autocorrelation for small lags that decreases as lag increases
- **Blue dashed lines**: Represent significance bounds ±1.96/√T

### 2. White Noise

- Time series where autocorrelation is close to 0 for most lag values
- 95% of autocorrelation values should fall within ±1.96/√T
- If all or at most 5% of autocorrelations fall outside these bounds, the data is likely white noise
- White noise is stationary

### 3. Stationarity

**Definition:**
A time series is stationary if:
- It has no trend (roughly horizontal)
- It has constant variance (homoscedastic)
- It has no predictable patterns (no seasons)
- Summary statistics (mean, variance) don't depend on time

**Visual Identification:**
- Stationary time series have ACF plots that drop quickly to zero
- Non-stationary time series show gradual decrease in ACF, with large positive first autocorrelation

**Statistical Tests:**

*KPSS Test (preferred for forecasting):*
- Null hypothesis: The time series is stationary
- If p-value < 0.05, reject H0 → time series is non-stationary
- In R: `features(variable, unitroot_kpss)`

*ADF Test:*
- Null hypothesis: The time series is non-stationary
- If p-value < 0.05, reject H0 → time series is stationary
- In R: `adf.test()` from tseries package

When tests disagree, prefer the KPSS test result.

### 4. Differencing

**First-Order Differencing:**
- Transformation: y't = yt − yt−1
- Used to stabilize the mean and remove trends
- In R: `difference(variable)`

**Seasonal Differencing:**
- Transformation: y't = yt − yt−m (where m is the seasonal period)
- Used for seasonal data
- In R: `difference(variable, lag_value)`

**Combined Differencing:**
- Sometimes both seasonal and first-order differencing are needed
- Recommended order: apply seasonal differencing first, then check if first-order is still needed

**Determining Required Differencing:**
- `unitroot_ndiffs`: indicates number of first-order differences needed
- `unitroot_nsdiffs`: indicates number of seasonal differences needed
- These functions work independently; after applying one type, recheck if the other is still needed

**Back-Transformation:**
- Predictions on differenced data must be transformed back to original scale
- For first-order: yt+1 = y't+1 + yt

### 5. Random Walk Model

When differenced time series is white noise with mean 0:
- Model: yt = yt−1 + εt (where εt is white noise)
- Each observation equals the previous one plus random noise
- Common in financial and economic data (e.g., stock prices)
- Best forecast: yT+1|T = yT (naive forecast)

## Key Takeaways

- Some forecasting methods require stationary time series
- Use KPSS and ADF tests to verify stationarity
- Apply differencing to make non-stationary data stationary
- ACF plots help identify trends, seasonality, and stationarity
- White noise is stationary but not all stationary series are white noise