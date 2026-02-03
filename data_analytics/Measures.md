
# 📈🗂️ Measures

This document lists each measure with a business-friendly name, a short description of the business logic, and the DAX expression.

---

## Revenue (Total Revenue)

* Table: DAX measures
* Business description: Total sales value for the selected context (sum of sales amounts).

```dax
SUM('gold fact_sales'[sales_amount])
```

---

## Quantity (Total Quantity Sold)

* Table: DAX measures
* Business description: Total number of items/units sold in the selected context.

```dax
SUM('gold fact_sales'[quantity])
```

---

## Cost (Total Cost)

* Table: DAX measures
* Business description: Total cost of goods sold (COGS) for the selected context.

```dax
SUM('gold fact_sales'[cost])
```

---

## Profit (Total Profit)

* Table: DAX measures
* Business description: Simple profit metric calculated as Revenue less Cost for the selected context.

```dax
[Revenue] - [Cost]
```

---

## #Customers (Unique Customers)

* Table: DAX measures
* Business description: Number of unique customers who made purchases in the selected context.

```dax
DISTINCTCOUNT('gold fact_sales'[customer_key])
```

---

## #Orders (Unique Orders)

* Table: DAX measures
* Business description: Number of unique order identifiers in the selected context.

```dax
DISTINCTCOUNT('gold fact_sales'[order_number])
```

---

## rev_diff (Revenue Change vs Last Year)

* Table: DAX measures
* Business description: Revenue change compared to the prior period (uses a helper function `diffFromLY`). Use for trend analysis year-over-year.

```dax
diffFromLY([Revenue])
```

---

## profit_diff (Profit Change vs Last Year)

* Table: DAX measures
* Business description: Profit change compared to the prior period using the same `diffFromLY` helper.

```dax
diffFromLY([Profit])
```

---

## cost_diff (Cost Change vs Last Year)

* Table: DAX measures
* Business description: Cost change compared to the prior period using the `diffFromLY` helper.

```dax
diffFromLY([Cost])
```

---

## rev_arrow (Revenue Direction Indicator)

* Table: DAX measures
* Business description: Visual indicator (arrow) showing revenue direction compared to previous period; relies on `arrows` helper which returns an indicator value or symbol.

```dax
arrows([Revenue])
```

---

## rev_color (Revenue Color Indicator)

* Table: DAX measures
* Business description: Color/indicator value derived from revenue performance (uses `color` helper). Useful for conditional formatting.

```dax
color([Revenue])
```

---

## profit_color (Profit Color Indicator)

* Table: DAX measures
* Business description: Color/indicator value derived from profit performance.

```dax
color([Profit])
```

---

## cost_color (Cost Color Indicator)

* Table: DAX measures
* Business description: Color/indicator value for cost performance (uses `color_cost` helper).

```dax
color_cost([Cost])
```

---

## profit_arrow (Profit Direction Indicator)

* Table: DAX measures
* Business description: Arrow indicator for profit direction, uses `arrows` helper.

```dax
arrows([Profit])
```

---

## cost_arrow (Cost Direction Indicator)

* Table: DAX measures
* Business description: Arrow indicator for cost direction, uses `arrows` helper.

```dax
arrows([Cost])
```

---

## qty_diff (Quantity Change vs Last Year)

* Table: DAX measures
* Business description: Quantity (units) change vs prior period using `diffFromLY` helper.

```dax
diffFromLY([Quantity])
```

---

## qty_arrow (Quantity Direction Indicator)

* Table: DAX measures
* Business description: Arrow indicator showing whether quantity increased or decreased vs prior period.

```dax
arrows([Quantity])
```

---

## qty_color (Quantity Color Indicator)

* Table: DAX measures
* Business description: Color/indicator for quantity performance (uses `color` helper).

```dax
color([Quantity])
```

---

## first_order (Year of First Order)

* Table: DAX measures
* Business description: Returns the year of the earliest order date in the current filter context (customer first order year).

```dax
YEAR(CALCULATE(MIN('gold fact_sales'[order_date])))
```

---

## AOV (Average Order Value)

* Table: DAX measures
* Business description: Average revenue per order (Revenue divided by number of orders).

```dax
DIVIDE([Revenue],[#Orders])
```

---

## top_customers (Top Customers (Revenue))

* Table: DAX measures
* Business description: Returns revenue only for customers ranked in top N by revenue (N defined by `'NO.Customers'[#Customers Value]`). Useful to isolate top customer contribution.

```dax
IF( 
    RANKX(ALL('gold dim_customers'[customer_name]), [Revenue], , DESC, Skip) 
        <= 'NO.Customers'[#Customers Value],
    [Revenue]
)
```

---

## last_order (Year of Most Recent Order)

* Table: DAX measures
* Business description: Returns the year of the most recent order date in the current selection.

```dax
YEAR(CALCULATE(MAX('gold fact_sales'[order_date])))
```

---

## no.cust_new_old (New vs Returning Customers (percentage text))

* Table: DAX measures
* Business description: Returns a formatted text showing percentage of new vs returning customers for the selected year (requires `date_table[year]`). Useful for customer composition reporting.

```dax
VAR new =
    COUNTX (
        FILTER (
            'gold dim_customers',
            'gold dim_customers'[First_order] = SELECTEDVALUE ( date_table[year] )
        ),
        'gold dim_customers'[customer_key]
    )
VAR perc_new =
    DIVIDE ( new, [#Customers] ) * 100
VAR old = [#Customers] - new
VAR perc_old =
    DIVIDE ( old, [#Customers] ) * 100
VAR space = UNICHAR(160) & UNICHAR(160) & UNICHAR(160) & UNICHAR(160)

RETURN
IF (
    ISFILTERED ( date_table[year] ),
    "New" & "   " & FORMAT(perc_new, "0.00") & " %" &
    space & "|" & space & "Old" & "   " & FORMAT(perc_old, "0.00") & " %",
    ""
)
```

---

## no.ord_new_old (New vs Returning Orders (percentage text))

* Table: DAX measures
* Business description: Same idea as `no.cust_new_old` but using order counts to show percentage of orders from new vs returning customers.

```dax
VAR new =
    COUNTX (
        FILTER (
            'gold dim_customers',
            'gold dim_customers'[First_order] = SELECTEDVALUE ( date_table[year] )
        ),
        [#Orders]
    )
VAR perc_new =
    DIVIDE ( new, [#Orders] ) * 100
VAR old = [#Orders] - new
VAR perc_old =
    DIVIDE ( old, [#Orders] ) * 100
VAR space = UNICHAR(160) & UNICHAR(160) & UNICHAR(160) & UNICHAR(160)

RETURN
IF (
    ISFILTERED ( date_table[year] ),
    "New" & "   " & FORMAT(perc_new, "0.00") & " %" &
    space & "|" & space & "Old" & "   " & FORMAT(perc_old, "0.00") & " %",
    ""
)
```

---

## rev_new_old (New vs Returning Revenue (percentage text))

* Table: DAX measures
* Business description: Shows revenue contribution from new vs returning customers as a formatted text for the selected year.

```dax
VAR new =
    SUMX (
        FILTER (
            'gold dim_customers',
            'gold dim_customers'[First_order] = SELECTEDVALUE ( date_table[year] )
        ),
        [Revenue]
    )
VAR perc_new =
    DIVIDE ( new, [Revenue] ) * 100
VAR old = [Revenue] - new
VAR perc_old =
    DIVIDE ( old, [Revenue] ) * 100
VAR space = UNICHAR(160) & UNICHAR(160) & UNICHAR(160) & UNICHAR(160)

RETURN
IF (
    ISFILTERED ( date_table[year] ),
    "New" & "   " & FORMAT(perc_new, "0.00") & " %" &
    space & "|" & space & "Old" & "   " & FORMAT(perc_old, "0.00") & " %",
    ""
)
```

---

## profit% (Profit Margin)

* Table: DAX measures
* Business description: Profit as a percentage of revenue, formatted as text with a percent sign.

```dax
FORMAT( DIVIDE([Profit],[Revenue]) * 100, "0.00" ) & " %"
```

---

## ASP (Average Selling Price)

* Table: DAX measures
* Business description: Revenue divided by quantity, indicating average price per unit sold.

```dax
DIVIDE([Revenue],[Quantity])
```

---

## mom_rev (Month-over-Month Revenue Change)

* Table: DAX measures
* Business description: Month-over-month change for revenue using `mom` helper function.

```dax
mom([Revenue])
```

---

## mom_cost (Month-over-Month Cost Change)

* Table: DAX measures
* Business description: Month-over-month change for cost using `mom` helper.

```dax
mom([Cost])
```

---

## mom_profit (Month-over-Month Profit Change)

* Table: DAX measures
* Business description: Month-over-month change for profit using `mom` helper.

```dax
mom([Profit])
```

---

## ytd_rev (Year-to-Date Revenue)

* Table: DAX measures
* Business description: Running total of revenue for the year to date (uses `ytd_` helper).

```dax
ytd_([Revenue])
```

---

## ytd_cost (Year-to-Date Cost)

* Table: DAX measures
* Business description: Running total of cost for the year to date (uses `ytd_` helper).

```dax
ytd_([Cost])
```

---

## ytd_profit (Year-to-Date Profit)

* Table: DAX measures
* Business description: Running total of profit for the year to date (uses `ytd_` helper).

```dax
ytd_([Profit])
```

---

## YTD_title (Selected Measure YTD Title)

* Table: DAX measures
* Business description: Returns a label string showing which YTD metric is selected (Revenue YTD / Profit YTD / Cost YTD) based on the `Measure` slicer selection.

```dax
IF(
    SELECTEDVALUE('Measure'[Measure Order]) = 0, "Revenue YTD",
    IF( SELECTEDVALUE('Measure'[Measure Order]) = 1, "Profit YTD", "Cost YTD" )
)
```

---

## MOM (Selected Measure MOM Value)

* Table: DAX measures
* Business description: Switches between month-over-month measures (`mom_rev`, `mom_profit`, `mom_cost`) depending on `Measure` selection.

```dax
IF(
    SELECTEDVALUE('Measure'[Measure Order]) = 0, [mom_rev],
    IF( SELECTEDVALUE('Measure'[Measure Order]) = 1, [mom_profit], [mom_cost] )
)
```

---

## ColorMOM (MOM Color Code)

* Table: DAX measures
* Business description: Produces a numeric color code (1/2) depending on whether MOM is positive or negative; used for conditional formatting.

```dax
SWITCH(
    TRUE(),
    [MOM] > 0, 1,
    [MOM] < 0, 2
)
```

---

## YTD Revenue (Revenue YTD (context-sensitive))

* Table: DAX measures
* Business description: Returns revenue YTD, optionally filtered by `Measure` slicer.

```dax
VAR SelOrder = SELECTEDVALUE('Measure'[Measure Order])
RETURN
IF(
    ISBLANK(SelOrder),
    [ytd_rev],
    IF(SelOrder = 0, [ytd_rev], BLANK())
)
```

---

## YTD Profit (Profit YTD (context-sensitive))

* Table: DAX measures
* Business description: Returns profit YTD when `Measure` selection corresponds to profit.

```dax
VAR SelOrder = SELECTEDVALUE('Measure'[Measure Order])
RETURN
IF(
    ISBLANK(SelOrder),
    BLANK(),
    IF(SelOrder = 1, [ytd_profit], BLANK())
)
```

---

## Selected Measure Line Color (Chart Line Color for Selected Measure)

* Table: DAX measures
* Business description: Returns a hex color string to style chart lines depending on which measure is selected in `Measure` slicer.

```dax
SWITCH(
    SELECTEDVALUE('Measure'[Measure Order]),
    0, "#476D5B",
    1, "#09124F",
    2, "#EFB5B9"
)
```

---

## YTD Cost (Cost YTD (context-sensitive))

* Table: DAX measures
* Business description: Returns cost YTD when `Measure` selection corresponds to cost.

```dax
VAR SelOrder = SELECTEDVALUE('Measure'[Measure Order])
RETURN
IF(
    ISBLANK(SelOrder),
    BLANK(),
    IF(SelOrder = 2, [ytd_cost], BLANK())
)
```

---

## #Customers Value (Selected Customers Parameter)

* Table: NO.Customers
* Business description: Returns the selected numeric value from the `NO.Customers` table used to parameterize top-customer thresholds.

```dax
SELECTEDVALUE('NO.Customers'[#Customers])
```

---
