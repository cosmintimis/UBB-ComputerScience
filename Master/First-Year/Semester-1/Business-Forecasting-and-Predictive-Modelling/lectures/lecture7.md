## Main Topics Covered

### 1. **The Forecasting Workflow**
Standard steps in forecasting projects:
- Data preparation (cleaning, handling missing values/outliers)
- Data visualization (line plots, seasonal plots, ACF, scatter plots)
- Define and train a model
- Check performance
- Generate forecasts

### 2. **Four Simple Forecasting Methods**
These baseline methods are primarily used for comparison rather than actual forecasting:

**Mean Method**: All future forecasts equal the historical average
- Formula: ŷ<sub>T+h|T</sub> = (y₁ + y₂ + ... + y<sub>T</sub>) / T

**Naive Method**: All forecasts equal the last observation
- Formula: ŷ<sub>T+h|T</sub> = y<sub>T</sub>

**Seasonal Naive Method**: Forecasts repeat the last seasonal pattern
- Best for seasonal data
- Formula uses observations from the same season in previous periods

**Drift Method**: Allows linear trend based on first-to-last observation
- Formula: ŷ<sub>T+h|T</sub> = y<sub>T</sub> + h × (y<sub>T</sub> - y₁)/(T - 1)

### 3. **Fitted Values and Residuals**
- **Fitted values** (ŷ<sub>t</sub>): Model predictions for training data points
- **Residuals** (e<sub>t</sub>): Difference between actual and fitted values (e<sub>t</sub> = y<sub>t</sub> - ŷ<sub>t</sub>)
- **Innovation residuals**: Residuals on transformed data

### 4. **Residual Diagnostics**
Good models should have innovation residuals that are:
1. **Uncorrelated** (essential)
2. **Zero mean** (essential)
3. Constant variance - homoscedasticity (desirable for prediction intervals)
4. Normally distributed (desirable for prediction intervals)

**Testing for autocorrelation**:
- Visual inspection using ACF plots
- **Box-Pierce test** and **Ljung-Box test** for formal statistical testing
- High p-values (>0.05) suggest residuals are consistent with white noise

### 5. **Prediction Intervals**
Forecasts include uncertainty through prediction intervals:
- 95% interval: ŷ<sub>T+h|T</sub> ± 1.96 × σ̂<sub>h</sub>
- Different multipliers for different confidence levels (50%, 80%, 90%, 95%, 99%)
- Intervals typically widen as forecast horizon increases
- Each baseline method has specific formulas for calculating σ̂<sub>h</sub>

### 6. **Transformations in Forecasting**
- Log or Box-Cox transformations can be applied before forecasting
- R handles automatic back-transformation
- After back-transformation, prediction intervals become asymmetric

### 7. **Forecasting with Decomposition**
Process:
- Decompose series into seasonal (Ŝ<sub>t</sub>) and seasonally adjusted (Â<sub>t</sub>) components
- Forecast seasonal component with SNAIVE
- Forecast adjusted component with another method (e.g., drift)
- Combine forecasted components
- Use `decomposition_model()` function in R

### 8. **Forecast Accuracy Measures**

**Scale-dependent measures** (same units as data):
- **MAE** (Mean Absolute Error): mean(|e<sub>t</sub>|)
- **RMSE** (Root Mean Squared Error): √mean(e<sub>t</sub>²)

**Percentage measures** (scale-independent):
- **MAPE** (Mean Absolute Percentage Error)
- **sMAPE** (Symmetric MAPE) - addresses MAPE's asymmetry issues

**Scaled measures** (scale-independent):
- **MASE** (Mean Absolute Scaled Error): Scales errors relative to naive method performance on training data
- MASE < 1 indicates better performance than naive benchmark

### 9. **Model Evaluation**
- Split data into training and test sets (typically 80/20)
- Test set should be at least as large as forecast horizon
- Use `accuracy()` function to compare models
- Avoid overfitting to training data

### 10. **Time Series Cross-Validation**
- Multiple training sets of increasing size
- Each test point is the next observation after training set
- More robust than single train-test split
- Implemented using `stretch_tsibble()` function with `.init` and `.step` parameters

## Key R Functions
- `MEAN()`, `NAIVE()`, `SNAIVE()`, `RW(drift())`
- `augment()`: Get fitted values and residuals
- `gg_tsresiduals()`: Diagnostic plots
- `forecast()`, `hilo()`: Generate forecasts and intervals
- `accuracy()`: Calculate error measures
- `decomposition_model()`: Forecast with decomposition

In general a forecasting workflow is organized in the following
way:
Data preparation (data cleaning/tidying)
Load, filter, transform, identify missing values, outliers, etc.
Data visualization
Line plot, seasonal plot, ACF, scatter plot, etc.
Define a model
Train the model
Check performance
Forecast


We have talked about ways to decompose a time series into
three components: trend, seasonal and remainder. We can
use decomposition before forecasting: decompose the data,
forecast the components separately, then combine the results.
In order to do this, we will consider that the time series is
made of two components only: the seasonal component (Sˆ
t)
and the seasonally adjusted components (Aˆ
t), which contains
the trend and the remainder.

Two popular measures of forecast accuracy are: Mean absolut
error (MAE) and Root mean squared error (RMSE) computed
in the following way:
MAE = mean(|et
|)
RMSE =
q
mean(e
2
t
)
Both MAE and RMSE are measures that should be minimised.
A method that minimizes MAE will forecast the median, while
a method minimizing the RMSE will forecast the mean.
