# Introduction #

This is a rough guide to installing the Trader DSS on a Unix like operating system

# Details #

## Perl Setup ##
  * Install the following. The example here uses the CPAN module to do the work. _Note:_ Date::Manip 6+ requires Perl 5.10+ which isn't the default on most systems yet. If you don't have Perl 5.10 then download Date::Manip 5.x from [CPAN](http://ftp.esat.net/pub/languages/perl/CPAN/authors/id/S/SB/SBECK/) and install it by hand.
```
perl -MCPAN -e shell
o conf prerequisites_policy follow
o conf commit
install Compress::Zlib
install Text::CSV_PP
install Text::CSV_XS
install Date::Manip
install HTML::PullParser
install HTML::Entities
install HTML::Parser
install HTML::TokeParser
install HTML::LinkExtor
install HTML::HeadParser
install HTML::Filter
install HTML::Tagset
install HTML::TreeBuilder
install HTML::TableExtract
install LWP
install Regexp::Common
install Finance::Quote
install Finance::QuoteHist
install DBI
install DBD::Pg
install Proc::Queue
```

## Postgresql setup ##
  * install postgres, the primary development platform is Centos 5 with the postgres (8.1.18) that's shipped with it.

## Create the database ##
  * as postgres
```
export PGDATA=/postgres/db
export PGDATABASE=trader
echo export PGDATA=$PGDATA >> ~/.profile
echo export PGDATABASE=$PGDATABASE >> ~/.profile
mkdir $PGDATA
initdb -E UTF8 $PGDATA
pg_ctl -l logfile start  # ignore the warnings about the ports
# create the trader database
createdb trader # created the database
createlang plpgsql trader # turn on pgsql for triggers
```

## Grab a copy of the 0.1 release ##
  * As the postgres user
```
svn co http://trader-dss.googlecode.com/svn/tags/trader-release-0.1
```

## Create the tables etc ##
  * Still as the postgres user
```
cd trader-release-0.1
psql trader -U postgres

trader=# \i tables/cart.sql
trader=# \i tables/deposits.sql
trader=# \i tables/exchange.sql
trader=# \i tables/gains.sql
trader=# \i tables/holdings.sql
trader=# \i tables/indicators.sql
trader=# \i tables/pf_summary.sql
trader=# \i tables/portfolios.sql
trader=# \i tables/queries.sql
trader=# \i tables/quotes.sql
trader=# \i tables/sector_quotes.sql
trader=# \i tables/sectors.sql
trader=# \i tables/simple_moving_averages.sql
trader=# \i tables/standard_deviations_from_mean.sql
trader=# \i tables/stock_sector.sql
trader=# \i tables/stocks.sql
trader=# \i tables/trade_dates.sql
trader=# \i tables/trades.sql
trader=# \i tables/users.sql
trader=# \i tables/watch.sql

trader=# \i constraints/cart.sql
trader=# \i constraints/deposits.sql
trader=# \i constraints/holdings.sql
trader=# \i constraints/indicators.sql
trader=# \i constraints/pf_summary.sql
trader=# \i constraints/portfolios.sql
trader=# \i constraints/queries.sql
trader=# \i constraints/quotes.sql
trader=# \i constraints/sector_quotes.sql
trader=# \i constraints/sectors.sql
trader=# \i constraints/stock_sector.sql
trader=# \i constraints/stocks.sql
trader=# \i constraints/trades.sql
trader=# \i constraints/watch.sql

trader=# \i functions/deviation.sql
trader=# \i functions/tidy_quotes.sql
trader=# \i functions/update_derived_tables.sql
trader=# \i functions/update_gains.sql
trader=# \i functions/update_moving_averages.sql
trader=# \i functions/update_stock_dates.sql
trader=# \i functions/update_trade_dates.sql
trader=# \i functions/update_williams_pcr.sql

trader=# \i triggers/update_derived_tables.sql

```

## Populate with data ##
  * If your data's coming from the LSE then
```
insert into exchange (exch, name, curr_desc, curr_char) values ('L', 'London Stock Exchange', 'GBP', '£');
```
  * Load all the share names with
```
bin/update-share_names.pl
```
  * Load the quotes from with. Beware, this may take days!
```
bin/update-quotes.pl
```
  * Create a user for the web interface
```
insert into users (name, passwd) values ('username of your choice', md5('password of your choice');
```

  * setup the web interface
    * install and configure apache
    * install PHP
    * install Pear
```
sudo pear install HTML_QuickForm
```
    * enable cgi-bin for cgi scripts in apache

## install the web pages and scripts ##
  * copy the html/ directory into `/var/www/html` or the root of your web server.
  * copy the cgi-bin/ directory into `/var/www/cgi-bin` or your cgi-bin directory
  * copy the bin/ directory to your home directory.
  * update `/var/www/html/trader-functions.php` with your server, database, account name and password. _We really should have a config file for those things_.
  * update the scripts in ~/bin with the same server, database, account and password details
  * install [chart director](http://www.advsofteng.com/) into `/var/www/ChartDirector` if you're going to use that to chart your results. The current code depends on it for graphs and charts and it has a generous license for open source / free use.