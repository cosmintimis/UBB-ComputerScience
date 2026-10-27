## **I. The Forecasting Workflow & Evaluation**

Building on previous lessons, a robust forecasting workflow requires moving beyond simple train-test splits to ensure model reliability.

### **Time Series Cross-Validation**

Cross-validation is considered superior to a simple split because it evaluates performance on a "rolling forecasting origin".

* 
**Methodology**: Several training sets are created with increasing size, and the test set is always the observation immediately following the training set.


* 
**Example**: For 20 observations, one might train on observations 1–5 and test on 6, then train on 1–6 and test on 7, continuing until training on 1–19 to test on 20 .


* 
**Implementation**: In R, this is achieved using the `stretch_tsibble` function, where users define the initial training length (`.init`) and the size increase for each step (`.step`).



### **Key Performance Indicators**

* 
**Fitted Values & Residuals**: Fitted values are 1-step forecasts made on the historical data used to build the model. The **residual** is the difference between the actual value and the fitted value.


* **Prediction Intervals**: These express the uncertainty of a forecast. Intervals generally widen as the forecast horizon increases or when a higher level of certainty (e.g., 95% vs. 80%) is required.


* **Performance Measures**:
* 
**Scale Dependent**: MAE and RMSE.


* 
**Scale Independent**: MAPE, sMAPE, and MASE.





---

## **II. Time Series Regression Models**

Regression models forecast a time series (, the forecast variable) by assuming it has a linear relationship with one or more other time series (, the predictor variables).

### **Linear Regression Basics**

* 
**Simple Linear Regression**: , where  is the explained part and  is the random error.


* 
**Multiple Linear Regression**: Used when multiple predictors exist: .


* 
**Least Squares Estimation**: The standard method for finding coefficients by minimizing the sum of the squares of the error terms.



### **Goodness of Fit**

* 
** (Coefficient of Determination)**: Measures the proportion of variation in the forecast variable explained by the model. Values range from 0 to 1, with 1 indicating a perfect fit.


* 
**Residual Standard Error**: Another measure of fit that accounts for the number of predictors ().



---

## **III. Predictor Selection and Special Variables**

Selecting the right predictors is critical to avoid **spurious regression**, where two unrelated series appear correlated simply because they share a similar trend.

### **Useful Predictors**

* 
**Trend**: A feature representing the time of an observation.


* 
**Dummy Variables**: Used for categorical data (e.g., "Holiday" vs. "No Holiday").


* If an attribute has  possible values, you need  dummy variables.


* 
**Seasonal Dummies**: Used for quarters, months, or days of the week.




* 
**Intervention Variables**: Dummies for "spikes" (one-period effects) or "steps" (permanent level shifts) .



### **Selection Strategies**

* 
**Poor Approaches**: Dropping variables solely based on scatterplots or discarding predictors based only on small p-values in a model containing all predictors .


* 
**Good Approaches**: Using measures of predictive accuracy via the `glance()` function.


* 
**Adjusted **: Preferred over standard  because it penalizes the unnecessary addition of predictors.


* 
**AICc, AIC, and CV**: Recommended because their primary objective is forecasting performance.





### **Stepwise Regression**

If fitting all possible combinations is not feasible, three procedures can limit experiments:

1. 
**Backwards Stepwise**: Start with all predictors and remove them one by one.


2. 
**Forward Stepwise**: Start with only an intercept and add predictors one by one.


3. 
**Hybrid**: A combination of adding and removing predictors.



---

## **IV. Non-Linear Regression**

If a linear relationship is insufficient, the model can be transformed:

* 
**Log Transformations**: Log-log, log-linear, or linear-log forms.


* 
**Piecewise Linear Trends**: Trends that "bend" at specific points called **knots**. This is useful for data where a trend changes direction at a specific point in time.
