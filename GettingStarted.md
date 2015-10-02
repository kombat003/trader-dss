# Introduction #

A brief tutorial to get you started

# Goals #
Trader has a number of goals.

  * Fun to implement and use
  * A testbed for technical analysis and trading schemes
  * A training ground for trading
  * A complete data warehouse of stock prices and technical indicators

# Concepts #

  * A portfolio is a collection of stocks you've (virtually) traded.
    * It can only contain shares from a single exchange.
    * It has a current working date which doesn't change until you choose to move to the next trading day. You cannot travel backwards in time (surprise!)
    * Portfolios also have a parcel size. That's the value of the minimum trade you want to make in that portfolio. It's not enforced, but the number of shares put into the watch or buy list is calculated using this.
  * A query is written in SQL and can be named and saved for later use.
    * Queries are hard to write and debug.
    * You need to understand the indicators and the database structure to write them.
    * A query must include the 'quotes' table so that the current date and exchange can be filtered on. [Issue 26](http://code.google.com/p/trader-dss/issues/detail?id=26)
    * A query must include the 'symb' field named as 'symb' so that the chart can be drawn.
  * **not yet implemented** A chart is a graph of stock information and indicators. They can be named and saved then combined with a query to help make trading decisions. Scheduled for the 0.2 release.

# Getting started #
  * login via the 'login.php' page and select the 'portfolios' tab.
  * Create a portfolio.
  * Try a query or two. Here's one to get you started
|**Select**|quotes.symb as symb, close, volume, mapr\_10, mapr\_20, mapr\_30, mapr\_50|
|:---------|:-------------------------------------------------------------------------|
|**From**  |quotes, indicators b                                                      |
|**Where** |(quotes.date = b.date AND quotes.symb = b.symb AND quotes.exch = b.exch) and (volume > 0 and mapr\_50 > 0) and close < 20|
|**Order by**|b.mapr\_50                                                                |
|**Limit** |10                                                                        |
|**Chart Period**|1 year                                                                    |
    * This should show you shares less than 20 that are trending up ordered by the amount they've increased in the last 50 days.
  * To save this query, click on the 'queries' tab, name it and save it.
    * You can now use this query with any portfolio by loading it after you've selected a portfolio.