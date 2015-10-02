## Overview ##

_A Trader without a computer is like a man traveling on a bicycle. His legs grow strong and he sees a lot of scenery, but his progress is slow._
Dr. Alexander Elder in 'Trading for a living' 1992.

The **Trader Decision Support System** is designed to facilitate good, tested decisions when stock trading. The emphasis is on trading with historic data to allow testing of methods and technical indicators, and the opportunity to learn without risk.

The system works with multiple exchanges and large portfolios although the testing has only been with two exchanges so far.

A simple web interface with shopping cart and watch list is now at a minimally functional state and is included in the 0.1 release.

The Trader DSS an end of day data warehouse of technical indicators to assist in finding stocks that meet certain technical criteria. While no data is provided, scripts for using [Finance::QuoteHist](http://search.cpan.org/dist/Finance-Quote/) from [CPAN](http://search.cpan.org/) are provided as examples to load historical data from the [LSE](http://www.londonstockexchange.com/) and from the [ASX](http://www.asx.com.au/).

All technical indicators are calculated and stored in advance so querying the database will provide pre-calculated information on any indicator implemented.

The database is queried in plain [SQL](http://www.postgresql.org/docs/8.1/interactive/sql.html) which allows automated scripts to be prepared in any language that can connect to [Postgresql](http://www.postgresql.org/). Some example scripts in Perl are provided in the `bin` directory.


---


## The finer print ##

  * The decisions you make and money you spend/lose are your own responsibility.
  * None of this code has any warranty of any kind at all.
  * You need to run this system yourself, no server is provided. If the idea of setting up a server running Apache, PHP and Postgres is too daunting, then this project is not for you.
  * The authors may or may not have ever traded a single share in their lives. This project isn't about getting rich, but about enjoying playing with the data.


---


## Releases ##
  * Trader-DSS Release 0.1 is here! This has a minimal function set but is usable to simulate historic trades. It's not pretty, but it mostly works.
  * Trader-DSS Release 0.2 is close now. Anyone wanting to try the code should get a copy of [trunk](https://code.google.com/p/trader-dss/source/checkout) from subversion and follow the wiki document InstallRelease02
  * Since I'm only kidding myself thinking that anyone else is reading this, I'm taking the time to re-work the php front end to use [CodeIgniter](http://codeigniter.com/) and AJAX via [jQuery](http://jquery.com/) and [jQuery UI](http://jqueryui.com/) and having a great time. It's almost as much work as the initial implementation but the back end code is nicer, being all objects and the interface is nicer (meaning it actually works)


---


## Requirements/Prerequisites ##
  * A reasonably current, reliable, powerful server. 3G RAM and a couple of fairly modern CPU's seem to do the job well enough. Fast disk seems to be the most important single factor.
  * [RHEL 5](http://www.redhat.com/rhel/) or a similar Linux. I use [Centos](http://www.centos.org/).
  * [Postgresql](http://www.postgresql.org/), I don't use MySQL or any other database. My postgresql skill are thin enough, but I don't know any other well enough to try to make this system work.
  * 20-30G of storage per exchange you want to use if you want to cary 10 years of historical EOD data.
  * An EOD data source. I use Yahoo Finance.


---


## Contact ##

  * If you're interested or want to suggest things send me an email at ps258@hotmail.com.


---


## Screen Shots ##
  * These are screen shots of the current trunk version. They are close to what will become Release 0.2
  * Login ![http://sites.google.com/site/traderdssproject/home/Login.png](http://sites.google.com/site/traderdssproject/home/Login.png)
  * Create, Delete or Choose a portfolio ![http://sites.google.com/site/traderdssproject/home/Portfolios.png](http://sites.google.com/site/traderdssproject/home/Portfolios.png)
  * The Portfolio management and performance report ![http://sites.google.com/site/traderdssproject/home/Booty.png](http://sites.google.com/site/traderdssproject/home/Booty.png)
  * Selecting new stocks to add to the portfolio or watch list![http://sites.google.com/site/traderdssproject/home/Select.png](http://sites.google.com/site/traderdssproject/home/Select.png)
  * Buy stocks from the shopping cart ![http://sites.google.com/site/traderdssproject/home/Trade.png](http://sites.google.com/site/traderdssproject/home/Trade.png)
  * List stocks on the watch list ![http://sites.google.com/site/traderdssproject/home/Watch.png](http://sites.google.com/site/traderdssproject/home/Watch.png)
  * Create, delete or choose a query ![http://sites.google.com/site/traderdssproject/home/Queries.png](http://sites.google.com/site/traderdssproject/home/Queries.png)
  * Chart any active security in the selected exchange ![http://sites.google.com/site/traderdssproject/home/Inspector.png](http://sites.google.com/site/traderdssproject/home/Inspector.png)
  * Documentation of indicators ![http://sites.google.com/site/traderdssproject/home/Docs.png](http://sites.google.com/site/traderdssproject/home/Docs.png)