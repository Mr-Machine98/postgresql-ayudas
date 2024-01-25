## Ayudas para construir funciones en PLpgSQL

Este repositorio alberga codigo `PLpgSQL` de PostGreSQL, por lo que podras ver ejemplos de construccion de funciones.

:+1: COn el objetivo de recordar la sintaxis - ahora es tiempo de trabajar, las ayudas estan en el archivo SQL_POSTGRES.sql :page_facing_up:! :shipit:

Ejemplo de codigo:

``` PLpgSQL
-- funcion que crea un backup de una tabla
create or replace function backup() returns boolean as $$
	declare
		begin
			copy (select * from productos) to 'D:\programacion\postgresql_ayudas\postgresql-ayudas\respaldo_productos.csv' delimiter ',' csv header;
			return true;
		end;
$$ language plpgsql;
select backup();
```


[link](https://www.todopostgresql.com/wp-content/uploads/2018/09/cursoPlpgsql.png)