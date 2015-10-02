Not in any particular order and not a commitment to implement!

## Issues to resolve ##

  * [Issue 22](http://code.google.com/p/trader-dss/issues/detail?id=22) Move DB login details from trader-functions.php into a config file which is also used by the scripts in ~/bin
  * [Issue 32](http://code.google.com/p/trader-dss/issues/detail?id=32) Before things get out of hand we need to get the documentation under control
  * [Issue 40](http://code.google.com/p/trader-dss/issues/detail?id=40) and [Issue 36](http://code.google.com/p/trader-dss/issues/detail?id=36) **(done)** should be implemented as a general warnings ability that would do routine checks on a selected stock and report things. This could be expanded into a comprehensive set of checks.
  * [Issue 39](http://code.google.com/p/trader-dss/issues/detail?id=39) **(done)** The current portfolio summary doesn't work with shorts, they just get treated as negative trades and do strange things to the graph and portfolio balance.

## Features to add ##

  * notes fields for trades need to be of type text **(done)** and the interface needs to allow more editing (larger field window) **(not going to bother, safari allows resizing which is good enough for me)**
  * Documentation of selectable indicators and how to query them **(done)**
  * Lots more technical indicators (**done MCAD**, might do OBV, RSI and CCI. Williams %R being improved with [Issue 9](http://code.google.com/p/trader-dss/issues/detail?id=9))
    * chart integration for indicators
  * utility scripts for another exchange (loading share names and historic prices) **(Done for the ASX)**
  * Test with a second exchange **(done)**
  * Some support for sectors **(would be nice, the ASX data is the All Ords, so will try that)**
    * Better table support
    * Trigger updates?
    * utility script to update sector indicators?
    * Integration into the web interface and charts
  * A Charts page where you can define and use charts in a similar way to the current queries page **(it looks like the stock inspector has replaced this)**
  * Ability to make deposits and withdrawals to a portfolio **(not worth the effort)**
  * Need to be able to edit portfolio details **(probably needs to be done, but I'm using psql for it now)**

## Things that have been added ##
  * The stock inspector, charts all of the information available for a scurity. Well, it will, but it charts lots now.
  * Trying to create a set of classes for securities. Not going well at the moment, but I'm trying. If I can get it to work, it will simplify the code enormously.
  * Auto stop loss has been implemented. If you say to sell after it falls 10% from the highest after you bought it, it will.
  * Warnings tell you if you're going long on a falling moving average or if you've disabled auto stop loss, that you've reached your stop loss
  * Breadth indicators for the exchange have been added in the inspector. Advance/Decline ratio, spread and line
  * A charts tab that allows any security to be selected and charted. A bit rough yet, but a start
