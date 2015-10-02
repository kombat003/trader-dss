# Introduction #

These are the changes to the database structure since [r309](https://code.google.com/p/trader-dss/source/detail?r=309). They will continue until Release 0.2 when a new file will be started


# Details #

  * Add a column to show the trade opening or closing
```
alter table trades add column tr_type char(1);
```
> Then update the tr\_type field by hand to set the transaction type. ('O' for open, 'C' for close) if you have existing transactions.

  * The primary key on holdings is too restrictive. Remove it
```
alter table holdings drop constraint holdings_pkey;
```
> remove the hid index
```
drop index idx_holdings_hid;
```
> Now add a primary key on hid
```
alter table holdings add primary key (hid);
```

  * Add a `hid` column to the trades table
```
alter table trades add column hid integer;
```

  * Noticed that the yahoo data is wrong in more than 600,000 records! It looks like simple mistakes not corruption. This to fix it. (Yeah, it's not DDL, I know)
```
update quotes set high=open where open > high;
update quotes set low=open where open < low;
update quotes set high=close where close > high;
update quotes set low=close where close < low;
```

  * The `update_all_exchange_indicators` function has changed to take an exchange as a parameter. This was needed to manage multiple exchanges in the database. Replace the definition with
```
\i functions/update_exchange_indicators.sql
```
  * Add the 10 .. 200 day exponential moving averages columns to the moving\_averages table and load the updated moving averages function.
```
alter table moving_averages add column ema_10 numeric(9,2), add column ema_20 numeric(9,2);
alter table moving_averages add column ema_30 numeric(9,2), add column ema_50 numeric(9,2);
alter table moving_averages add column ema_100 numeric(9,2), add column ema_200 numeric(9,2);
\i functions/update_moving_averages.sql
COMMENT ON COLUMN moving_averages.ema_10 IS 'The 10 day Exponential Moving Average';
COMMENT ON COLUMN moving_averages.ema_20 IS 'The 20 day Exponential Moving Average';
COMMENT ON COLUMN moving_averages.ema_30 IS 'The 30 day Exponential Moving Average';
COMMENT ON COLUMN moving_averages.ema_50 IS 'The 50 day Exponential Moving Average';
COMMENT ON COLUMN moving_averages.ema_100 IS 'The 100 day Exponential Moving Average';
COMMENT ON COLUMN moving_averages.ema_200 IS 'The 200 day Exponential Moving Average';
```
  * Now update all the moving averages
```
select update_moving_averages(date, symb, exch, close, volume) from quotes order by date, symb, exch;
```
  * Need to be able to find gap information more easily, so the gaps table needs to be expanded
```
alter table gaps add column last_gap numeric(9,2);
alter table gaps add column days_since_gap_up integer;
alter table gaps add column days_since_gap_down integer;
COMMENT ON COLUMN gaps.last_gap IS 'The most recent gap or zero if there has not been one';
COMMENT ON COLUMN gaps.days_since_gap_up IS 'The count of days since the last gap up or zero';
COMMENT ON COLUMN gaps.days_since_gap_down IS 'The count of days since the last gap down or zero';
```
  * Still more gaps info. Too many charts are distorted by huge jumps. I suspect that they're splits, but I can't find good info on splits
```
alter table gaps add column gap_sum_10 numeric(9,2);
alter table gaps add column gap_sum_20 numeric(9,2);
alter table gaps add column gap_sum_30 numeric(9,2);
alter table gaps add column gap_sum_50 numeric(9,2);
alter table gaps add column gap_sum_100 numeric(9,2);
alter table gaps add column gap_sum_200 numeric(9,2);
COMMENT ON COLUMN gaps.gap_sum_10 IS 'The sum of the gaps in the last 10 traded days';
COMMENT ON COLUMN gaps.gap_sum_20 IS 'The sum of the gaps in the last 20 traded days';
COMMENT ON COLUMN gaps.gap_sum_30 IS 'The sum of the gaps in the last 30 traded days';
COMMENT ON COLUMN gaps.gap_sum_50 IS 'The sum of the gaps in the last 50 traded days';
COMMENT ON COLUMN gaps.gap_sum_100 IS 'The sum of the gaps in the last 100 traded days';
COMMENT ON COLUMN gaps.gap_sum_200 IS 'The sum of the gaps in the last 200 traded days';
```
  * Load the new function
```
\i functions/update_gaps.sql
```
  * update the gaps table
```
select update_gaps(date, symb, exch, low, high) from quotes order by date, symb, exch;
```