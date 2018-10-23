
truncate Inventory.unit2;

insert into Inventory.unit2 select (product_issued * product_price) as product_Unit,product_id,product_issued from Inventory.issued  ;

truncate Inventory.result;

insert into Inventory.result 
    select product_id,sum(product_issued) as unit ,sum(product_Unit) as annual_cost from Inventory.unit2 group by product_id;

truncate Inventory.annual_data_usage;
insert into Inventory.annual_data_usage select product_id,format((annual_cost/unit),2),annual_cost from Inventory.result;

truncate Inventory.annual_spend;
insert into Inventory.annual_spend select *,(unit_cost * annual_unit_demand) from Inventory.annual_data_usage ;

truncate Inventory.annual_spend1;
insert into Inventory.annual_spend1  select * from Inventory.annual_spend order by annual_spend desc;

truncate Inventory.Cumulative_Running_Total;
insert into Inventory.Cumulative_Running_Total select  *,
(select sum(annual_spend) from Inventory.annual_spend1 where annual_spend>=t1.annual_spend )
from Inventory.annual_spend1 t1 ;

truncate Inventory.Class_A_Items;
insert into Inventory.Class_A_Items select *,(select case when 
	Cumulative_annual_spend <  ( select CAST(sum(annual_spend)*(80/100) as char) from Inventory.Cumulative_Running_Total) then 'A' 
when Cumulative_annual_spend < (select CAST(sum(annual_spend)*(95/100) as char) from Inventory.Cumulative_Running_Total) then 'B'
when Cumulative_annual_spend <= (select CAST(sum(annual_spend) as char) from Inventory.Cumulative_Running_Total) then 'C'
end )from Inventory.Cumulative_Running_Total ;


select * from Inventory.issued;

select * from Inventory.annual_data_usage;


select * from Inventory.annual_spend1;


select * from Inventory.Cumulative_Running_Total;

select * from Inventory.Class_A_Items;

