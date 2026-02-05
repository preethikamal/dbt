select * from {{source("DBT","Main")}}
qualify row_number() over(partition by id order by updated_at DESC)=1