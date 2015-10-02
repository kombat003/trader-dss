  * Shorts are treated as an asset in the portfolio. Effectively a loan of the amount gained by selling short.
  * When sold they liberate all the amount recorded in portfolio->holdings for them because that contains the amount that has to be paid back or is liberated by replacing them for less than they were originally sold for.

For example.

You short sell 10 shares at £100. Your holdings increases by £1000, effectively keeping £1000 in reserve to pay back the shares. If you close the short at the same price you get your £1000. If not you get £1000 plus the difference between the sort opening and closing prices. So if you close the short at £90 you get `£1000 + 10*(100-90) = £1100`. If you close the short at £110 you get `£1000 + 10*(100-110) = £900`.

If the following formula is used, it can be applied to both longs and shorts equally.

```
$value = ($opening_price * abs($volume)) + ($volume * ($close_price - $opening_price))
```

For a long this collapses to `$volume * $close_price`, but for a short it allows `$value` to contain the realizable value of the short.