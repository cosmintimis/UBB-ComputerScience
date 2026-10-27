## I. Course Logistics & Grading

The course consists of 2 hours of lecture and 1 hour of seminar per week. Grading depends on your specific study program:

| Criteria | Data Science (8 credits) | Cyber Security/Cloud (5 credits) |
| --- | --- | --- |
| **Written Exam** | 40% (Last week of semester) 

 | 50% (Exam session) 

 |
| **Seminar Assignments** | 30% (At least 4) 

 | 50% (At least 2) 

 |
| **Theoretical Report** | 30% (20+ pages, 2+ papers) 

 | N/A |

* 
**Passing Requirement:** A final grade of , an exam grade of , and completion of minimum seminar assignments.


* 
**Seminar Rules:** Assignments must be presented during seminars for full credit; late submissions via MS Teams are capped at a grade of 6.



---

## II. Fundamentals of Forecasting

**Forecasting** is defined as the process of making predictions based on past and present data.

### Key Concepts

* 
**Forecast Horizon:** The number of future periods being predicted.


* 
**Short-term:** Days, weeks, or months.


* 
**Medium-term:** 1–2 years.


* 
**Long-term:** Many years.




* 
**Qualitative vs. Quantitative:** * **Qualitative:** Used when no historical data exists; relies on expert subjective opinion.


* 
**Quantitative:** Used when historical data is available and past patterns are expected to repeat.





### Types of Time Series Data

In forecasting, we typically work with **time series**, where observations occur in successive order over time.

* 
**Variables:** Can be **univariate** (one variable), **bivariate** (two connected variables), or **multivariate** (multiple connected variables).


* 
**Data Type:** Usually numerical, but can be **categorical** (e.g., sleep states, weather conditions).


* 
**Frequency:** Usually measured at equal intervals (daily, monthly), but can be irregular.



---

## III. Forecasting Models

There are three primary ways to set up a forecasting problem, illustrated by predicting Electricity Demand (ED):

1. 
**Explanatory (Regression) Model:** Uses predictor variables that influence the outcome.







2. 
**Time Series Model:** Assumes the future depends only on past values of the same variable.







3. 
**Mixed Model:** Combines both predictor variables and past observations.








---

## IV. The Forecasting Workflow

A standard workflow consists of six essential steps:

1. 
**Problem Definition:** Understanding who will use the forecast and for what purpose.


2. 
**Gathering Information:** Collecting historical data and expertise.


3. 
**Preliminary Analysis:** Plotting data to identify patterns or outliers.


4. 
**Choosing and Fitting Models:** Estimating parameters based on historical data.


5. 
**Evaluating the Model:** Testing performance on new, unused data (**forecast error**).


6. 
**Deployment and Monitoring:** Using the model in production and checking if it still fits over time.



---

## V. Key Notations

* 
: The observation at time .


* 
: The forecast of  (the average value of the forecast distribution).


* 
: The number of steps in advance (horizon).


* 
**Point Forecast:** A single predicted value (usually wrong).


* 
**Prediction Interval:** A range (e.g., 80%) indicating the probability that the actual value will fall within those bounds.