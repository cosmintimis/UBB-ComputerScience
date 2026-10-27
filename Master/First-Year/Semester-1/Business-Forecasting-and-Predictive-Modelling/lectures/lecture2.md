## I. Getting Started with R and RStudio

* 
**Tools**: The lecture utilizes **R** as the programming language and **RStudio** as the Integrated Development Environment (IDE).


* **RStudio Panes**: The IDE is organized into key areas:
* 
**Console** (bottom left): For typing direct commands.


* 
**Source** (top left): For writing and saving scripts.


* 
**Plots/Packages/Help** (bottom right): For viewing visualizations, managing libraries, and reading documentation.




* **Packages**: These are collections of code, documentation, and data. Two critical packages for this course are `tidyverse` and `fpp3`.


* 
**Installation**: Use `install.packages("package_name")` (done once).


* 
**Loading**: Use `library("package_name")` (done every session).





---

## II. Data Structures in R

There are three primary ways to store tabular and time series data in R:

| Type | Description | Key Functions |
| --- | --- | --- |
| **Data Frame** | Simple tabular data representation.

 | <br>`data.frame()`, `read.csv()` 

 |
| **Tibble** | A "neater" version of a data frame with better internal representation.

 | <br>`tibble()`, `as_tibble()`, `read_csv()` 

 |
| **Tsibble** | A **Time series tibble**. It requires an **index** (time variable) and optional **keys** to identify multiple time series.

 | <br>`tsibble()`, `as_tsibble()` 

 |

### Wide vs. Long Formats

* 
**Wide Data**: Each row is a unique time point; different variables are in separate columns (e.g., wine types as columns).


* **Long Data**: Multiple rows can exist for the same time point; keys determine the specific time series. This format is preferred for `autoplot`.


* 
**Transformation**: Use `pivot_longer()` to turn columns into rows and `pivot_wider()` for the reverse.



---

## III. Data Manipulation and Piping

* 
**The Pipe Operator (`|>`)**: Used to chain multiple operations together, passing the result of the left side as the first parameter to the right.


* **Core Tidyverse Functions**:
* 
`mutate()`: Changes existing columns or creates new ones.


* 
`select()`: Picks specific columns (use `-column_name` to remove).


* 
`filter()`: Extracts rows based on conditions (e.g., `is.na(Time) == FALSE`).


* 
`slice()`: Extracts rows based on their index.


* 
`unite()`: Combines multiple columns into one (useful for creating time indexes).





---

## IV. Data Visualization with `ggplot2`

Visualizations are built by adding layers using the `+` sign.

### Time Series Plots

* 
**`autoplot()`**: Automatically chooses a line plot for time series data.


* 
**`autolayer()`**: Used to add additional time series to an existing plot.



### General Plots (The Penguin Example)

* 
**Aesthetics (`aes`)**: Maps variables to visual cues like `x`, `y`, `color`, `shape`, and `size`.


* **Geoms**: Geometrical objects used to represent data:
* 
`geom_point()`: Scatterplots.


* 
`geom_smooth(method = "lm")`: Adds a linear model best-fit line.


* 
`geom_bar()`: Bar charts for categorical data distribution.


* 
`geom_histogram()`: Distribution for numerical data.




* 
**Faceting**: `facet_wrap(vars(attribute))` splits one plot into multiple subplots based on a categorical variable.


* 
**Saving**: `ggsave("filename.png")` saves the most recent plot.
