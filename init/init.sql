DROP TABLE IF EXISTS public.calidad_aire CASCADE;
CREATE TABLE IF NOT EXISTS public.calidad_aire
(
    "FECHA" character varying(20) COLLATE pg_catalog."default",
    "HORA" smallint,
    "CO_CENTENARIO" character varying(6) COLLATE pg_catalog."default",
    "NO2_CENTENARIO" character varying(6) COLLATE pg_catalog."default",
    "PM10_CENTENARIO" character varying(6) COLLATE pg_catalog."default",
    "CO_CORDOBA" character varying(6) COLLATE pg_catalog."default",
    "NO2_CORDOBA" character varying(6) COLLATE pg_catalog."default",
    "PM10_CORDOBA" character varying(6) COLLATE pg_catalog."default",
    "CO_LA_BOCA" character varying(6) COLLATE pg_catalog."default",
    "NO2_LA_BOCA" character varying(6) COLLATE pg_catalog."default",
    "PM10_LA_BOCA" character varying(6) COLLATE pg_catalog."default",
    "CO_PALERMO" character varying(6) COLLATE pg_catalog."default",
    "NO2_PALERMO" character varying(6) COLLATE pg_catalog."default",
    "PM10_PALERMO" character varying(6) COLLATE pg_catalog."default"
);

-- upload dataset

\copy public.calidad_aire FROM '/var/lib/csv/calidad-aire.csv' DELIMITER ',' CSV;


DROP TABLE IF EXISTS public.viajes_sube CASCADE;
CREATE TABLE IF NOT EXISTS public.viajes_sube
(
    "TIPO_TRANSPORTE" character varying(20) COLLATE pg_catalog."default",
    "DIA" character varying(20) COLLATE pg_catalog."default",
    "PARCIAL" character varying(20) COLLATE pg_catalog."default",
    "CANTIDAD" character varying(20) COLLATE pg_catalog."default"
);


-- upload dataset

\copy public.viajes_sube FROM '/var/lib/csv/dataset_viajes_sube.csv' DELIMITER ',' CSV;

-- create views

CREATE VIEW calidad_aire_cleaned as 
select 
TO_DATE(SUBSTRING("FECHA",1,9), 'DDMONYYYY') as FECHA_DATE, 
-- CO cleaned
CAST ( CASE WHEN lower("CO_CENTENARIO") = 's/d' THEN NULL 
            WHEN "CO_CENTENARIO" = '#REF!' THEN NULL
            ELSE REPLACE("CO_CENTENARIO",'<','') 
       END  
AS DECIMAL ) as CO_CENTENARIO, 
CAST ( CASE WHEN lower("CO_CORDOBA") = 's/d' THEN NULL 
            WHEN "CO_CORDOBA" = '#REF!' THEN NULL
            ELSE REPLACE("CO_CORDOBA",'<','') 
       END  
AS DECIMAL ) as CO_CORDOBA,
CAST ( CASE WHEN lower("CO_LA_BOCA") = 's/d' THEN NULL 
            WHEN "CO_LA_BOCA" = '#REF!' THEN NULL
            ELSE REPLACE("CO_LA_BOCA",'<','') 
       END  
AS DECIMAL ) as CO_LA_BOCA,
CAST ( CASE WHEN lower("CO_PALERMO") = 's/d' THEN NULL 
            WHEN "CO_PALERMO" = '#REF!' THEN NULL
            ELSE REPLACE("CO_PALERMO",'<','') 
       END  
AS DECIMAL ) as CO_PALERMO,
-- NO2 cleaned
CAST ( CASE WHEN lower("NO2_CENTENARIO") = 's/d' THEN NULL 
            WHEN "NO2_CENTENARIO" = '#REF!' THEN NULL
            ELSE REPLACE("NO2_CENTENARIO",'<','') 
       END  
AS DECIMAL ) as NO2_CENTENARIO, 
CAST ( CASE WHEN lower("NO2_CORDOBA") = 's/d' THEN NULL 
            WHEN "NO2_CORDOBA" = '#REF!' THEN NULL
            ELSE REPLACE("NO2_CORDOBA",'<','') 
       END  
AS DECIMAL ) as NO2_CORDOBA,
CAST ( CASE WHEN lower("NO2_LA_BOCA") = 's/d' THEN NULL 
            WHEN "NO2_LA_BOCA" = '#REF!' THEN NULL
            ELSE REPLACE("NO2_LA_BOCA",'<','') 
       END  
AS DECIMAL ) as NO2_LA_BOCA,
CAST ( CASE WHEN lower("NO2_PALERMO") = 's/d' THEN NULL 
            WHEN "NO2_PALERMO" = '#REF!' THEN NULL
            ELSE REPLACE("NO2_PALERMO",'<','') 
       END  
AS DECIMAL ) as NO2_PALERMO,
-- PM10 cleaned
CAST ( CASE WHEN lower("PM10_CENTENARIO") = 's/d' THEN NULL 
            WHEN "PM10_CENTENARIO" = '#REF!' THEN NULL
            ELSE REPLACE("PM10_CENTENARIO",'<','') 
       END  
AS DECIMAL ) as PM10_CENTENARIO, 
CAST ( CASE WHEN lower("PM10_CORDOBA") = 's/d' THEN NULL 
            WHEN "PM10_CORDOBA" = '#REF!' THEN NULL
            ELSE REPLACE("PM10_CORDOBA",'<','') 
       END  
AS DECIMAL ) as PM10_CORDOBA,
CAST ( CASE WHEN lower("PM10_LA_BOCA") = 's/d' THEN NULL 
            WHEN "PM10_LA_BOCA" = '#REF!' THEN NULL
            ELSE REPLACE("PM10_LA_BOCA",'<','') 
       END  
AS DECIMAL ) as PM10_LA_BOCA,
CAST ( CASE WHEN lower("PM10_PALERMO") = 's/d' THEN NULL 
            WHEN "PM10_PALERMO" = '#REF!' THEN NULL
            ELSE REPLACE("PM10_PALERMO",'<','') 
       END  
AS DECIMAL ) as PM10_PALERMO
from calidad_aire
where length("FECHA") = 18;  -- exclude 1 row with data with incorrect format


create view viajes_sube_cleaned as 
select TO_DATE(SUBSTRING("DIA",1,9), 'DDMONYYYY') as fecha_date, 
       sum(CAST("CANTIDAD" as numeric)) as pasajeros
from viajes_sube
where length("DIA") = 18 -- exclude 1 row with data with incorrect format
group by 1 ;


create view ejercicio2 as
select fecha_date,
       avg_co,
       avg_no2,
       avg_pm10,
       case when avg_co < 4.5 and avg_no2 < 100 and avg_pm10 < 54 then 'Buen día'
       ELSE 'Mal día'
       END
from 
(
select fecha_date,
       CASE WHEN sum(places_with_data_co) = 0 then 0 else 
       sum(day_co_medition) / sum(places_with_data_co)
       END as avg_co,
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
) agregada
order by 1 desc;

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
limit 10;

-- drop view ejercicio4;

create view ejercicio4 as
select TO_CHAR(fecha_date,'YYYYMM') as month,
       fecha_date,
       ranking_position
from 
(
select fecha_date, 
       rank() over (partition by TO_CHAR(fecha_date,'YYYYMM') order by idx_compuesto asc ) as ranking_position
from       
(
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
) ranking
) top3
where ranking_position <= 3;

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
) b;

