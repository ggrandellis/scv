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

\copy public.calidad_aire FROM '/var/lib/csv/calidad-aire.csv' DELIMITER ',' CSV;


DROP TABLE IF EXISTS public.viajes_sube CASCADE;
CREATE TABLE IF NOT EXISTS public.viajes_sube
(
    "TIPO_TRANSPORTE" character varying(20) COLLATE pg_catalog."default",
    "DIA" character varying(20) COLLATE pg_catalog."default",
    "PARCIAL" character varying(20) COLLATE pg_catalog."default",
    "CANTIDAD" character varying(20) COLLATE pg_catalog."default"
);

\copy public.viajes_sube FROM '/var/lib/csv/dataset_viajes_sube.csv' DELIMITER ',' CSV;

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


