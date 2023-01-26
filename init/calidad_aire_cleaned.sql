drop view calidad_aire_cleaned

create view calidad_aire_cleaned as 
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
where length("FECHA") = 18 -- exclude 1 row with data with incorrect format


