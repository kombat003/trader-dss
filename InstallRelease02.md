# Introduction #

This is a rough guide to installing the Trader DSS on a Unix like operating system. I'm using Centos 5 on X86\_64

**Note: This is against trunk because the Release 0.2 branch hasn't been created**

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
install HTML::TableContentParser
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
  * edit ~postgres/data/pg\_hba.conf to allow access to the database. This is what I use, but it might be too open for your environment. Take care! **My internal subnet is 10.0.0.0/24, this needs to only allow systems _you_ want to trust**
```
# "local" is for Unix domain socket connections only
local   all         all                               trust
# IPv4 local connections:
host    all         all         127.0.0.1/32          trust
host    all         all         10.0.0.0/24           trust
# IPv6 local connections:
host    all         all         ::1/128               trust
```
  * Tune postgres for a big database. I don't know how to do this, so you're on your own. Your mileage may vary. ~postgres/data/postgresql.conf
```
# turn on network connections (only if you need them)
listen_addresses = '*'
port = 5432
# not sure if this one is good or not
shared_buffers = 131072
# turn off forced sync, faster but risky!
fsync = off
# similarly, faster but risky
full_page_writes = off
# not sure about this one either
effective_cache_size = 131072
# needed by vacuum analyze
max_fsm_pages = 1024000
```
  * Restart postgresql
```
sudo /sbin/service postgresql restart
```

## Create the database ##
  * as postgres
```
export PGDATA=/var/lib/pgsql/data
# create the trader database
createdb trader
# enable plpgsql on the trader database
createlang plpgsql trader # turn on pgsql for triggers
# add a role for the application
createuser -P -E -D -S -R -l trader
```

## Grab a copy of the 0.2 release ##
  * As the postgres user
```
svn checkout http://trader-dss.googlecode.com/svn/trunk/ trader-dss-read-only
```

## Create the tables etc ##
  * Still as the postgres user
```
cd trader-dss-read-only/postgres
psql trader -U postgres

trader=# \i tables/create_tables.sql

trader=# \i constraints/create_constraints.sql

trader=# \i functions/create_functions.sql

trader=# \i triggers/update_derived_tables.sql

trader=# \i views/view_table_details.sql
```

## Populate with data ##
  * If your data's coming from the LSE then
```
insert into exchange (exch, name, curr_desc, curr_char) values ('L', 'London Stock Exchange', 'GBP', '£');
```
  * Load all the share names with (**NOTE:** It looks like yahoo finance have changed their pages, so this doesn't work at the moment)
```
bin/update-share_names.pl
```
  * Load the quotes from Yahoo finance with the following. Beware, this may take days!
```
bin/update-quotes.pl
```
  * Create a user for the web interface
```
insert into users (name, passwd) values ('username of your choice', md5('password of your choice'));
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
  * update the scripts in `~/bin` with the same server, database, account and password details
  * install [chart director](http://www.advsofteng.com/) into `/var/www/ChartDirector` if you're going to use that to chart your results. The current code depends on it for graphs and charts and it has a generous license for open source / free use.

## Setting up an apache virtual host on Centos 5 ##
  * Add `NameVirtualHost *:80` to `/etc/httpd/conf/httpd.conf`
  * Add a `/etc/httpd/conf.d/trader.conf` with
```
<VirtualHost *:80>
    ServerName trader.domain.ltd
    DocumentRoot /var/www/html
    Options Indexes
</VirtualHost>
```
  * Restart apache `service httpd restart`
  * **Note** the `*:80` bits need to match between NameVirtualHost and VirtualHost