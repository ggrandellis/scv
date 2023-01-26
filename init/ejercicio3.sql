create view ejercicio3 as 
select fecha_date,
	   sum(avg_co+avg_no2+avg_pm10) as idx_compuesto
from 
(
select fecha_date,
	   CASE WHEN sum(places_with_data_co) = 0 then 0 else 
       sum(day_co_medition) / sum(places_with_data_co)
	   END * 100 as avg_co,
	   CASE WHEN sum(places_with_data_no2) = 0 then 0 else 
       sum(day_no2_medition) / sum(places_with_data_no2)
	   END as avg_no2,
	   CASE WHEN sum(places_with_data_pm10) = 0 then 0 else 
       sum(day_pm10_medition) / sum(places_with_data_pm10)
	   END as avg_pm10	   
from 
(
select 
fecha_date,
-- calculate real avg co
sum(coalesce(avg_co_centanario,0)+
	coalesce(avg_co_cordoba,0)+
	coalesce(avg_co_la_boca,0)+
	coalesce(avg_co_palermo,0)
	) as day_co_medition,
sum(CASE WHEN avg_co_centanario is null then 0 else 1 end +
	CASE WHEN avg_co_cordoba is null then 0 else 1 end +
	CASE WHEN avg_co_la_boca is null then 0 else 1 end +
	CASE WHEN avg_co_palermo is null then 0 else 1 end 
	) as places_with_data_co,
-- calculate real avg no2	
sum(coalesce(avg_no2_centanario,0)+
	coalesce(avg_no2_cordoba,0)+
	coalesce(avg_no2_la_boca,0)+
	coalesce(avg_no2_palermo,0)
	) as day_no2_medition,
sum(CASE WHEN avg_no2_centanario is null then 0 else 1 end +
	CASE WHEN avg_no2_cordoba is null then 0 else 1 end +
	CASE WHEN avg_no2_la_boca is null then 0 else 1 end +
	CASE WHEN avg_no2_palermo is null then 0 else 1 end 
	) as places_with_data_no2,
-- calculate real avg pm10	
sum(coalesce(avg_pm10_centanario,0)+
	coalesce(avg_pm10_cordoba,0)+
	coalesce(avg_pm10_la_boca,0)+
	coalesce(avg_pm10_palermo,0)
	) as day_pm10_medition,
sum(CASE WHEN avg_pm10_centanario is null then 0 else 1 end +
	CASE WHEN avg_pm10_cordoba is null then 0 else 1 end +
	CASE WHEN avg_pm10_la_boca is null then 0 else 1 end +
	CASE WHEN avg_pm10_palermo is null then 0 else 1 end 
	) as places_with_data_pm10	
from
	(
	select fecha_date, 
	avg(co_centenario) as avg_co_centanario,
	avg(co_cordoba) as avg_co_cordoba,
	avg(co_la_boca) as avg_co_la_boca,
	avg(co_palermo) as avg_co_palermo,
	avg(no2_centenario) as avg_no2_centanario,
	avg(no2_cordoba) as avg_no2_cordoba,
	avg(no2_la_boca) as avg_no2_la_boca,
	avg(no2_palermo) as avg_no2_palermo,
	avg(pm10_centenario) as avg_pm10_centanario,
	avg(pm10_cordoba) as avg_pm10_cordoba,
	avg(pm10_la_boca) as avg_pm10_la_boca,
	avg(pm10_palermo) as avg_pm10_palermo
	from calidad_aire_cleaned
	group by 1
	) parciales
group by 1
) totales
group by 1
) sumados group by 1
having sum(avg_co+avg_no2+avg_pm10) > 0
order by 2 asc 
limit 10