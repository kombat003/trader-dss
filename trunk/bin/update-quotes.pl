#!/usr/bin/perl -w

# fetch all the quotes, splits and dividends for all symbols listed in stocks.

use strict;
use Finance::QuoteHist;
use Date::Manip;
use DBI;
use strict;

$| = 1;
my $debug = 0;
my $sleep_time = 3;

Date_Init("DateFormat=non-US");

my $dbname   = 'trader';
my $username = 'postgres';
my $password = 'happy';
my $exchange = 'L';
my (@row, $dbh, $sth, $found_code, $last_quote, $last_quote_plus, $isth);
my ($a, $b, $c, $d, $e, $f);
my ($symbol, $date, $open, $high, $low, $close, $volume, $adjusted);
my ($q, $stock_code, $row, $first_quote);
my $total_inserts=0;
my $stopfile = 'stop';
my $pausefile = 'pause';

my $last_business_day = DateCalc("today","- 1 business day");
$last_business_day = Date_PrevWorkDay($last_business_day, -1);
print "[INFO]last business day is " . UnixDate($last_business_day, "%Y-%m-%d") . "\n" if ($debug);

$dbh = DBI->connect("dbi:Pg:dbname=$dbname", $username, $password) or die $DBI::errstr;

print "select symb,exch,first_quote,last_quote from stocks where exch = \"$exchange\" order by symb;\n" if ($debug);
$sth = $dbh->prepare("select symb,exch,first_quote,last_quote from stocks where exch = '$exchange' order by symb;") or die $dbh->errstr;
$sth->execute or die $dbh->errstr;
while ((@row) = $sth->fetchrow_array)
{
    $stock_code = $row[0];
    $exchange = $row[1];
    $first_quote = $row[2];
    $last_quote = $row[3];
    if ( ! $last_quote )
    {
        $last_quote = '2000-01-01';
        $last_quote_plus = '2000-01-01';
    }
    else
    {
        $last_quote_plus = DateCalc($row[3], "+ 1 day");
    }
    $last_quote_plus = UnixDate($last_quote_plus, "%Y-%m-%d");
    $first_quote = $last_quote_plus unless ($first_quote);
    if (Date_Cmp($last_business_day, $last_quote_plus) <= 0)
    {
        print "[INFO]Skipping $stock_code up to date\n" if ($debug);
        next;
    }
    sleep $sleep_time;
    print "[INFO][Updating]$stock_code.$exchange, have $first_quote to $last_quote. Retrieving $last_quote_plus to today\n";
    $q = new Finance::QuoteHist(
        symbols    => [qq($stock_code.$exchange)],
        start_date => $last_quote_plus,
        end_date   => 'today',
        verbose    => 0
    );
    #print "[INFO]$stock_code.$exchange from " . $q->quote_source($stock_code, "quote") . "\n";
    $q->adjusted(1);
    foreach $row ($q->quotes())
    {
        ($symbol, $date, $open, $high, $low, $close, $volume, $adjusted) = @$row;
        ($symbol, undef) = split(/\./, $symbol);
        $adjusted = $close if (not defined($adjusted));
        print "[INFO][inserting]$symbol, $date, $open, $high, $low, $close, $volume, $adjusted\n";
        print "insert into quotes (date, symb, exch, open, high, low, close, volume, adj_close) values ('$date', '$stock_code', '$exchange', $open, $high, $low, $close, $volume, $adjusted)\n" if ($debug);
        $isth = $dbh->prepare("insert into quotes (date, symb, exch, open, high, low, close, volume, adj_close) values ('$date', '$stock_code', '$exchange', $open, $high, $low, $close, $volume, $adjusted)") or die $dbh->errstr;
        $isth->execute or die $dbh->errstr;
        ++$total_inserts;
    }
    pause_or_stop();
}
print "[INFO]Total rows added $total_inserts\n";
$isth->finish;

sub pause_or_stop
{
# stop of the stopfile's been created in CWD
    if (-f $stopfile)
    {
        warn "[INFO]Exiting on stopfile\n";
        unlink($stopfile);
        exit 0;
    }
    wait_on_pause();
}

sub wait_on_pause
{
# sleep if the pausefile's in CWD
    my $pause_time = 60;
    while (-f $pausefile)
    {
        warn "[INFO]Pausing for $pause_time sec.\n";
        sleep $pause_time;
    }
}
