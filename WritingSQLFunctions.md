# These are just some conventions for writing sql triggers/functions #

  * Write the triggers so that they work when the table's already populated and when it's empty. This means that recalculating a table or adding a field and populating it won't require the table to be emptied first.
    * This example is for a table where the norm is that the record already exists. An update is performed and only if it doesn't update any records is an insert performed. Make sure that the insert includes all the required fields.
```
    update indicators set mapr_10 = v_ma_10_MAPR where date = new_date and symb = new_symb and exch = new_exch;
    if not found then
        insert into indicators 
        ( date, symb, exch, mapr_10 )
        values
        ( new_date, new_symb, new_exch, v_ma_10_MAPR );
    end if;
```
    * When the task is on a table where it is expected that the record won't already exist, this method should be used
```
    BEGIN
        insert into boll_band ( exch, date, bollinger_band ) VALUES ( new_exch, new_date, new_bollinger_band);
    EXCEPTION when unique_violation THEN
        update boll_band set bollinger_band = new_bollinger_band where date = new_date and symb = new_symb and exch = new_exch;
    END;
```
  * The function `tidy_quotes(symbol character varying, exchange character varying)` will remove all the records for a particular symbol. When adding a new indicator table, it must be updated to remove entries from that table when invoked. It is called using this syntax
```
select tidy_quotes('RBS', 'L');
```
  * Tie the variable types to their table fields if possible. That way changing the table definition will change the function without more work.
> Like this
```
v_ma_10_diff moving_averages.ma_10_diff%TYPE;
```
> rather than like this
```
v_ma_10_diff numeric(9,2);
```