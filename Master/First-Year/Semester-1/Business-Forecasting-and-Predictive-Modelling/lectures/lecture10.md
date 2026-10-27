## **I. Stationarity and Differencing**

A stationary time series is one whose properties do not depend on the time at which the series is observed.

### **Identifying Stationarity**

* **Visual Characteristics**: Stationary series should have no predictable patterns in the long term, meaning no trend and no seasonality.
* **ACF Plots**: For stationary data, the Autocorrelation Function (ACF) drops to zero quickly. In non-stationary data, the ACF decreases slowly and often has a large positive value for lag 1.
* **White Noise**: While a series might look stationary, the ACF and Ljung-Box tests are necessary to confirm if the data is white noise or if autocorrelations remain.

### **Differencing**

Differencing is the process of computing the change between consecutive observations to make a non-stationary time series stationary.

* **First-order Differencing**: .
* **Second-order Differencing**: Differencing the already differenced data if the first order is insufficient.
* **Seasonal Differencing**: Computing the change between an observation and the corresponding observation from the previous year: .

---

## **II. Mathematical Notation: Backshift Operator**

The backward shifting operator, **B**, is used to denote data shifted backwards by a time unit.

* **Single Lag**: .
* **Double Lag**: .
* **Differencing with B**: First-order differencing can be written as .

---

## **III. ARIMA Model Components**

An ARIMA model is a combination of three parts: **AR(p)**, **I(d)**, and **MA(q)**.

### **1. AutoRegressive Models (AR)**

In an autoregression model, we forecast the variable using a linear combination of its **past values**.

* **Formula**: .
* **AR(1) Behavior**: If ,  is white noise; if  and ,  is a random walk.

### **2. Moving Average Models (MA)**

An MA model uses **past forecast errors** in a regression-like model.

* **Formula**: .

### **3. Integrated Part (I)**

This represents the number of **differencing** steps required to make the series stationary.

---

## **IV. The ARIMA Framework**

The full model is denoted as **ARIMA(p, d, q)**:

* **p**: Order of the autoregressive part.
* **d**: Degree of first differencing involved.
* **q**: Order of the moving average part.

### **Model Selection**

To select the best parameters, R uses the `ARIMA()` function, which tries to minimize information criteria such as **AIC, AICc, or BIC**. A good ARIMA model should also have residuals that behave like **white noise** (checked via `gg_tsresiduals()`).


Using the AICc measure we can only compare models, where
the order of the differencing is the same. If we want to test
models with different orders of differencing, we need other
methods, for example, train-test validation.