create view ejercicio5 as
select *
from 
(
	select 'Dias mayor impacto' as description, idb.fecha_date, trunc(idb.idx_compuesto * pasajeros) as coeficiente_impacto
	from idx_by_day idb
	left join viajes_sube_cleaned vsc on vsc.fecha_date = idb.fecha_date
	where idx_compuesto is not null and pasajeros is not null
	order by 2 desc
	limit 10
) a 	
union
select *
from 
(
select 'Dias menor impacto' as description , idb.fecha_date, trunc(idb.idx_compuesto * pasajeros) as coeficiente_impacto
from idx_by_day idb
left join viajes_sube_cleaned vsc on vsc.fecha_date = idb.fecha_date
where idx_compuesto is not null and pasajeros is not null
order by 2 asc
limit 10
) b