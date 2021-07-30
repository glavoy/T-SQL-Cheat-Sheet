-- This script can be used to delete exact duplicates in a table
-- Replace 'tablename' with the name of the table where you want to delete the duplicates

select distinct *
into #holding
from tablename

truncate table tablename

insert tablename
select *
from #holding

drop table #holding