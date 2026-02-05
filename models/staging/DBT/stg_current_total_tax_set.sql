select orders.id , presentment_money.currency_code as presentment_currency_code,
 presentment_money.amount as presentment_amount,
 shop_money.currency_code as shop_currency_code,
 shop_money.amount as shop_amount from {{ref("Main")}} as orders
left join unnest(orders.current_total_tax_set) as current_total_tax_set
left join unnest(current_total_tax_set.presentment_money) as presentment_money
left join unnest(current_total_tax_set.shop_money) as shop_money
