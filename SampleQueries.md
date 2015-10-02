# Introduction #

The Trader Decision Support System provides you with the raw data and leaves you to query it yourself, however these queries may help to explain how to use the system. They are given as samples of possible use of the data only, not as recommended trading strategies.

## ER Diagram ##

For reference, this is the ER Diagram for the backend database
![https://sites.google.com/site/traderdssproject/home/ER-Diagram.png](https://sites.google.com/site/traderdssproject/home/ER-Diagram.png)

# Sample Queries #

A sample of queries to show the purpose of each of the indicators.
  * General tips
    1. Ignore stocks with zero volume
    1. The stocks table has to be in the query. Join it with a second table with the foreign keys `date, symb, exch`
    1. The second table should be aliased to `b` to make copying queries easier
  * Where a sample chart is given. It is the chart of the first symbol returned by the query.
## The Moving Averages Table ##

  * Most of these are calculated by `update_moving_averages.sql`

### Fields in moving\_averages ###
  * **date, exch, symb**. These provide the foreign key with the stocks table
  * **close\_ma\_XXX**. The 10, 20, 30, 50, 100 and 200 day simple moving averages of the closing price calculated by this [formula](http://stockcharts.com/school/doku.php?id=chart_school:technical_indicators:moving_averages#sma_calculation)
  * **ema\_XXX**. The 10, 12, 20, 26, 30, 50, 100 and 200 exponential moving average of the closing price calculated by this [formula](http://stockcharts.com/school/doku.php?id=chart_school:technical_indicators:moving_averages#ema_calculation). The 12 and 26 day EMAs are included because they are often used by technical analysts.
  * **ma\_XXX\_diff**. The difference between today's close price and the 10, 20, 30, 50, 100 and 200 day moving average. Useful to decide if the price is above or below the moving average. Formula : today\_close - close\_ma\_XXX
  * **ma\_XXX\_dir**. +1 when ma\_XXX\_diff > 0, -1 when ma\_XXX\_diff < 0
  * **ma\_XXX\_run**. The number of days that ma\_XXX\_dir has been the same. Equally the number of days in a row that the simple moving average has been exceeded by close price.
  * **ma\_XX\_sum**. The sum of the ma\_XXX\_diff since the price came above or fell below the close\_ma\_XXX. In other words the sum of the close\_ma\_XXX for the duration of ma\_XXX\_run or since the ma\_XXX\_dir changed sign. They're all the same thing.
  * **volume\_ma\_XXX**. The 10, 20, 30, 50, 100, 200 day simple moving average of the volume.

### Sample Queries for moving\_averages ###
  * Use **ma\_10\_diff** to find the symbols with the gains over their 10 day moving averages. The trouble with this simple query is that the larger priced stocks will be at the top of the list.
```
select 
  quotes.symb as symb, close, volume, round(ma_10_diff, 2) as ma_10_diff 
from
  quotes, moving_averages b 
where 
  (quotes.date = b.date and quotes.symb = b.symb and quotes.exch = b.exch and volume > 0) 
order by 
  ma_10_diff
  desc;
```
> ![https://sites.google.com/site/traderdssproject/home/ma_10_diff.png](https://sites.google.com/site/traderdssproject/home/ma_10_diff.png)
  * if we normalize the moving average difference (**ma\_10\_diff**) with the close price we will get a list of the fastest growing stocks. Reverse it for the fastest losing stocks
```
select 
  quotes.symb as symb, close, volume, round(ma_10_diff / close, 2) as ma_10_diff
from
  quotes, moving_averages b 
where 
  (quotes.date = b.date and quotes.symb = b.symb and quotes.exch = b.exch and volume > 0) 
order by 
  ma_10_diff
  desc;
```
> ![https://sites.google.com/site/traderdssproject/home/ma_10_diff2.png](https://sites.google.com/site/traderdssproject/home/ma_10_diff2.png)
  * How about finding the stocks that have been above their moving average for the longest? Here we use **ma\_10\_run** to find the stocks that have exceeded their 10 day moving average the longest. We specify `ma_10_dir > 0` to exclude the ones that have been falling. We can reverse that to find all the falling stocks.
```
select
  quotes.symb as symb, close, volume, ma_10_run 
from
  quotes, moving_averages b
where
  ((quotes.date = b.date and quotes.symb = b.symb and quotes.exch = b.exch) and ma_10_dir > 0 and volume > 0)
order by
  ma_10_run 
  desc;
```
> ![https://sites.google.com/site/traderdssproject/home/ma_10_run_1.png](https://sites.google.com/site/traderdssproject/home/ma_10_run_1.png)
    * The longer moving averages can find some impressive gradients. This chart uses **ma\_100\_run** in the place of ma\_10\_run above. It shows a symbol that has a good long upwards run.
> > ![https://sites.google.com/site/traderdssproject/home/ma_100_run_1.png](https://sites.google.com/site/traderdssproject/home/ma_100_run_1.png)
    * You can combine them to find stocks that have certain historical and recent qualities. Like they've had a good 100 day moving average run, but fallen below their 10 day moving average.
  * we can find the stocks that are exceeding their moving averages by the most with the following
```
select
  quotes.symb as symb, close, volume, round(close_ma_10/close,2) as close_10_ratio
from
  quotes, moving_averages b 
where 
  ((quotes.date = b.date and quotes.symb = b.symb and quotes.exch = b.exch) and volume > 0)
order by
  close_10_ratio;
```

> ![https://sites.google.com/site/traderdssproject/home/close_10_ratio_1.png](https://sites.google.com/site/traderdssproject/home/close_10_ratio_1.png)
  * Combine this with **ma\_10\_run** to find stocks that have been doing well for a while, but are now taking off.
```
select
  quotes.symb as symb, close, volume, round(close_ma_10/close,2) as close_10_ratio
from
  quotes, moving_averages b 
where 
  ((quotes.date = b.date and quotes.symb = b.symb and quotes.exch = b.exch) and volume > 0 and ma_10_run > 20)
order by
  close_10_ratio;
```
> ![https://sites.google.com/site/traderdssproject/home/close_10_ratio_2.png](https://sites.google.com/site/traderdssproject/home/close_10_ratio_2.png)
## The Indicators Table ##
  * These are calculated by the `update_williams_pcr.sql` and `update_moving_averages.sql`
### Fields in indicators ###
  * **wpr\_XXX**. The 10, 20, 30, 50, 100 and 200 day Williams Percent Range. Calculated according to the normal [formula](http://en.wikipedia.org/wiki/Williams_%25R)
  * **mapr\_XXX**. The formula is ma\_XXX\_sum / ma\_XXX\_run. It's use is in ordering symbols according by their performance. Normalising it with close\_ma\_XXX may be a good idea. Perhaps that should be done to create a mapr\_rank?
### Sample queries on the indicators table ###
  * Use **mapr\_XXX** to rank stocks by their 10 day performance
```
select
  quotes.symb as symb, close, volume, round(mapr_10/close,2) as mapr_10
from
  quotes, indicators b where ((quotes.date = b.date and quotes.symb = b.symb and quotes.exch = b.exch) and volume > 0)
order by
  mapr_10
  desc;
```
> ![https://sites.google.com/site/traderdssproject/home/mapr_1.png](https://sites.google.com/site/traderdssproject/home/mapr_1.png)
### Sample queries on the gaps table ###
  * use **gap\_sum\_XXX** to rank stocks by the size of the gaps in the last 10 days
```
select
  quotes.symb as symb, close, volume, gap_sum_10, days_since_gap_up, round(gap_sum_10/close,2) as gap_sum_r, round(gap/close, 2) as gap_r
from
  quotes, gaps b
where
   (quotes.date = b.date and quotes.symb = b.symb and quotes.exch = b.exch) and volume > 0
order by
  gap_sum_r
```
  * use **gap\_sum\_XXX** to rank stocks by the size of the gaps in the last 10 days and there was a gap yesterday and it was positive.
```
select
  quotes.symb as symb, close, volume, gap_sum_10, days_since_gap_up, round(gap_sum_10/close,2) as gap_sum_r, round(gap/close, 2) as gap_r
from
  quotes, gaps b
where
   (quotes.date = b.date and quotes.symb = b.symb and quotes.exch = b.exch) and volume > 0 and days_since_gap_up = 1 and gap > 0
order by
  gap_sum_r
```