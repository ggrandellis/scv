## SCV Excersise

## Start docker_compose: create the postgres database and pgadmin
```
docker-compose up -d
```

## Stop docker compose
```
docker-compose stop
```

## Kill docker compose
```
docker ps
```

## Ejercicio 1

Solved uploading both CSV using the COPY command in the init.sql file to be executed when Postgre database is started.

## Ejercicio 2

Solved in view ejercicio2.sql. Maximum threshold to consider a "good day" taken from:

https://www.buenosaires.gob.ar/areas/med_ambiente/apra/calidad_amb/red_monitoreo/index.php?contaminante=1&estacion=1&fecha_dia=23&fecha_mes=01&fecha_anio=2023&menu_id=34234&buscar=Buscar

## Ejercicio 3

Solved in view ejercicio3.sql. As there is no a standar criteria to combinate the 3 factores involved in measures, I just adjust the scale for CO measure and adds it with other 2 to get a kind of index. This criteria is very simple and can be optimized but is needed more technical information related to the weight of measures.

## Ejercicio 4

## Ejercicio 5

## Ejercicio 6

Solved using docker-compose to start an image with Postgre database and PgAdmin (IDE) to run the querys that answer questiones in previous items.