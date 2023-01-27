create view viajes_sube_cleaned as 
select TO_DATE(SUBSTRING("DIA",1,9), 'DDMONYYYY') as fecha_date, 
       sum(CAST("CANTIDAD" as numeric)) as pasajeros
from viajes_sube
where length("DIA") = 18 -- exclude 1 row with data with incorrect format
group by 1 