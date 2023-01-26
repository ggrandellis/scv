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

\copy public.viajes_subte FROM '/var/lib/csv/dataset_viajes_sube.csv' DELIMITER ',' CSV;