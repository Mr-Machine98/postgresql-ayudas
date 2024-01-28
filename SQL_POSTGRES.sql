/*
	POSTGREST SQL
*/

/*
CASTEO varchar
*/
select cast(200 as varchar) as numero_entero;
select '200'::integer as numero_entero;
select 200::double precision as numero_entero;
select cast('1999-01-18' as date) as fecha;
select '1 day'::interval;

/*
	Funciones Fecha tiempo en Postgres
*/
select CURRENT_DATE;
select CURRENT_TIMESTAMP;
select CURRENT_TIME;
select extract(MONTH from CURRENT_DATE;
select extract(YEAR from '2019-02-12'::date);
select extract(HOUR from CURRENT_TIMESTAMP);
select extract(MINUTE from CURRENT_TIMESTAMP);
select extract(CENTURY from CURRENT_TIMESTAMP);
select extract(DOY from CURRENT_TIMESTAMP);
select NOW();
			   
/*INTERVAL*/
select now() - '1 day'::INTERVAL;
select age(now(), date('1998-10-01'));
select now() - '24 hour'::INTERVAL;
select 'YESTERDAY'::DATE;
select 'TODAY'::date;

/*EXAMPLES*/
select *
	from alumnos a
		where extract(MONTH from a.fechanacimiento) = extract(month from current_date)
		and extract(DAY from a.fechanacimiento) = extract(DAY from current_date); /*SABER QUE PERSONAS CUMPLEN HOY*/
select count(*) 
	from alumnos a
		where extract(YEAR from a.fechaingreso) = '2003'; /*SABER CUANTAS PERSONAS INGRESARON EN EL 2003*/
		
select date_trunc('month', current_date); /*retorna el primer dia del mes de la fecha actual*/
select date_part('day', current_date); /*retorna el dia presente*/
select extract(
	day from (select date_trunc('month',current_date) + '1 month'::interval ) - '1 sec'::interval 
); /*mostrar el ultimo dia del mes*/
select * from alumnos where fechaingreso=CURRENT_DATE-1; /*retorna los alumnos que ingresaron ayer*/


/* FUNCIONES UTILES */

/* num aleatorio*/
select cast(random()*10000 as int);
/*redondear*/
select round(828.1234, 1);
select round(828.1234, 2);
/*mostrar cierta cantidad*/
select cast(123456 as char(4));
select cast('Juan Camilo' as char(4));
/*Quitar acentos*/
select translate('Canción', 'ó', 'oO');
/*recortar cadenas*/
select rtrim('POSTGRESQL', 'SQL');
/*retorna palabra al reves*/
select reverse('zorra');
/*retorna un substring*/
select substring('Juan Camilo Mamian Ruiz', length('Juan Camilo Mamian Ruiz') - 10, 6);
select substr(123456789::varchar, length(123456789::varchar) - 5 , 3);
/*quitar espacios*/
select trim('     milomilion ');
/*quitar caracteres especificos*/
select trim(trailing '*' from 'milomilion***');
/*quitar caracteres especificos izq, drch*/
select ltrim('****milomilion', '*');
select rtrim('milomilion****', '*');
/*saber la longitud*/
select char_length('postgresql') as longitud;
/*devuelva la fecha de acuerdo al formato*/
select to_char(CURRENT_DATE, 'YYYY|mm|dd');
/*repetir una cadena*/
select repeat('camilo ', 3);
/*comparar cadenas*/
select bpcharcmp('Oracion', 'Oracion'); /*0 igual true, -1 igual a false*/
/*concatenar varias columnas*/
select concat(a.nombre ,' ', a.apellidopaterno,' ', a.apellidomaterno) as nombre
	from alumnos a;
/*ver en que posicion esta la cadena*/
select position('camilo' in 'juan camilo');
/*devolver una cadena con comilllas*/
select quote_ident('Juan');
/*devolver con comilla simplre*/
select quote_literal(00000);
/*partir la cadena con - y devolver el 1 elemento*/
select split_part('2024-01-12', '-', 1);
/*example*/
select 
	a.nombre || 'nacio en: ' || 
	split_part(a.fechanacimiento::varchar, '-', 1) ||
	' Buena esa chav@' as mensaje
	from alumnos a;


/*Funciones propias como crearlas

	- Las funciones en POSTGRESQL se les conoce como Stored Procedures
	exmaple:
	
	especificamos que recibimos y que entregamos
	
	create function miFuncion()
	returns text
	
	as $$ 
	begin 
	
	end
	$$ language plgpsql;
	
	- los $$ declara el cuerpo de la funcion, el begin end va ser la parte funcional,
	y el lenguaje es lo que vamos a utilizar en este caso pl
	
	example
	
*/
create function miFuncion() returns text as $$
	begin
		return 'Bienvenido a mi funcion que hice con PostgreSQL';
	end;
$$ language plpgsql;

/*Para sobreescribir la funcion usamos replace*/
create or replace function miFuncion() returns text as $$
	begin
		return 'Bienvenido Juan Camilo';
	end;
$$ language plpgsql;

/*Funciones con argumentos*/
create or replace function miFuncion(num1 int) returns int as $$
	begin
		return num1 * 2;
	end;
$$ language plpgsql;

create or replace function miFuncion1(num1 int) returns double precision as $$
	begin
		return num1 / 2 ::double precision;
	end;
$$ language plpgsql;

/*
	Crear una tabla desde una funcion
*/
create or replace function creartabla() returns text as $$
	begin
	
		create table mitabla(
			nombre varchar(45),
			edad integer,
			pais varchar(45)
		);
		
		return 'creando tabla...';
	end;
$$ language plpgsql;
/*Creando tabla y condicionar para que no se presente conflicto al crearse mas de una vez*/
create or replace function creartabla() returns text as $$
	begin
		
		raise notice 'borrando tabla existente ~mitabla~';
		if exists( select tablename from pg_tables where tablename = 'mitabla') 
			then
				drop table mitabla;
		end if;
		raise notice 'creando tabla existente ~mitabla~';
		if not exists( select tablename from pg_tables where tablename = 'mitabla') 
			then 
					create table mitabla(
						nombre varchar(45),
						edad integer,
						pais varchar(45)
					);
		end if;
		
		return 'creando tabla...';
	end;
$$ language plpgsql;

/*Creando tabla y condicionar para que no se presente conflicto al crearse mas de una vez, final insertar un row*/
create or replace function creartabla() returns text as $$
	declare
		query text;
	begin
		raise notice 'borrando tabla existente ~mitabla~';
		if exists( select tablename from pg_tables where tablename = 'mitabla') 
			then
				query:= 'drop table mitabla;'; 
				execute query;
		end if;
		raise notice 'creando tabla existente ~mitabla~';
		if not exists( select tablename from pg_tables where tablename = 'mitabla') 
			then 
					query:='create table mitabla(
						nombre varchar(45),
						edad integer,
						pais varchar(45)
					);';
					execute query;
		end if;
		
		insert into mitabla(nombre, edad, pais)
			values('Jose', 45, 'cali');
			
		raise notice 'insertando datos en ~mitabla~';
		
		alter table mitabla add column telefono varchar(12);
		raise notice 'agregando nueva columna telefono en ~mitabla~';
		
		return 'creando tabla...';
	end;
$$ language plpgsql;

/* example final */
create or replace function creartabla() returns text as $$
	declare
		query text;
	begin
		raise notice 'borrando tabla existente ~mitabla~';
		if exists( select tablename from pg_tables where tablename = 'mitabla') 
			then
				query:= 'drop table mitabla;'; 
				execute query;
		end if;
		raise notice 'creando tabla existente ~mitabla~';
		if not exists( select tablename from pg_tables where tablename = 'mitabla') 
			then 
					query:='create table mitabla(
						nombre varchar(45),
						edad integer,
						pais varchar(45)
					);';
					execute query;
		end if;
		
		insert into mitabla(nombre, edad, pais)
			values('Jose', 45, 'cali');
			
		raise notice 'insertando datos en ~mitabla~';
		
		alter table mitabla add column telefono varchar(12);
		raise notice 'agregando nueva columna telefono en ~mitabla~';
		
		query:='update mitabla set telefono = ''3172780054'' where nombre = ''Jose'';';
		execute query;
		raise notice 'actualizando datos en ~mitabla~';
		
		return 'creando tabla...';
	end;
$$ language plpgsql;

/* mas ejemplos */

/* funcion que saca el iva de un productoid
	el $1 significa el primer argumento que llega de la funcion
*/
create or replace function total_a_pagar(integer) returns numeric as $$
	declare
		precio_producto numeric := (select p.precio from productos p where p.productoid = $1);
																		
		iva_producto numeric := precio_producto*0.16;
		
		total numeric := iva_producto + precio_producto;
		begin
			return total;
		end;
$$ language plpgsql;

/* funcion que retorna multiples registros */
create or replace function datos_producto(integer) returns varchar as $$
	declare
		/*
			marcador de tipo record
			Sirve para retornar un conjunto de datos 'registros'
		*/
		r record;
		begin
		
			select * into r from productos p
				where p.productoid = $1;
				
			return r.descripcion;
		end;
$$ language plpgsql;

/* Funcion que retorna varias filas */
create or replace function devuelve_filas() returns setof record as $$
	declare
		/*
			funcion que devuelve en si' varias filas
		*/
		rec record;
		begin
		
			/*Ciclo*/
			for rec in execute 'select * from productos' loop
				return next rec;
			end loop;
			return;
			
		end;
$$ language plpgsql;
/* invocar a la funcion */
select * from devuelve_filas() as (productoid integer , descipcion varchar, precio double precision);

/* la misma funcion de arriba pero con argumentos */
/*La palabra clave "setof" en este fragmento
de código de PostgreSQL indica que la función
devuelve un conjunto de registros.
En términos más simples, la función devuelve
una serie de registros en lugar de un solo valor.*/
create or replace function devuelve_filas(INTEGER) returns setof record as $$
	declare
		/*
			funcion que devuelve en si' varias filas
		*/
		rec record;
		begin
		
			/*Ciclo*/
			for rec in select * from productos p where p.productoid = $1 loop
				return next rec;
			end loop;
			return; /*indica el fin de la funcion*/
			
		end;
$$ language plpgsql;
/* invocar a la funcion */
select * from devuelve_filas(100) as (productoid integer , descipcion varchar, precio double precision);

/* Funcion que compara el tamanio de dos palabras estructura if else */
create or replace function longitud_mayor_palabra(palabra1 text, palabra2 text) returns record as $$
	declare
		rec record;
		begin
		
			if length(palabra1) < length(palabra2) then
				select true, palabra1 || ' - ' ||  palabra2, 'palabra1 tiene menor longitud que la palabra2.'
					into rec;
			else
				select false, palabra2 || ' - ' || palabra1, 'palabra2 tiene mayor longitud que la palabra1.'
					into rec;
			end if;
			
			return rec; 
		end;
$$ language plpgsql;
select longitud_mayor_palabra('sushi', 'pozole');

/* funcion que lee un csv y pega los datos en una tabla temporal devuelve un mensaje 
	los parametros 'out resultado text' sirven para saber el resultado de ejecucion
	si para saber si la ejecucion fue exitosa
	no se necesita declarar nada para esta variable en la seccion de declare
*/
create or replace function copiar_archivo(out resultado text) returns text as $$
	declare
	
		begin
		
			if exists(select tablename from pg_tables where tablename='tmp_productos') then
				drop table tmp_productos;
			end if;
			raise notice 'se elimino la tabla tmp_productos';
			
			create table tmp_productos(
				productoid integer,
				descripcion varchar(100),
				precio double precision
			);
			
			copy tmp_productos from 'D:\programacion\postgresql_ayudas\postgresql-ayudas\datosproductos.csv' delimiter ',' csv header;
			
			resultado:='Copiado realizado con exito.';
	
			return;
		end;
$$ language plpgsql;
select copiar_archivo();
select * from tmp_productos;

/* la misma funcion de arriba solo que ahora si inserta nuevos productos a la tabla productos*/
create or replace function copiar_archivo(out resultado text) returns text as $$
	declare
	
		begin
		
			if exists(select tablename from pg_tables where tablename='tmp_productos') then
				drop table tmp_productos;
			end if;
			raise notice 'se elimino la tabla tmp_productos';
			
			create table tmp_productos(
				productoid integer,
				descripcion varchar(100),
				precio double precision
			);
			
			copy tmp_productos from 'D:\programacion\postgresql_ayudas\postgresql-ayudas\datosproductos.csv' delimiter ',' csv header;
			
			insert into productos select * from tmp_productos;
			
			raise notice 'Insertando productos nuevos a la tabla productos...';
			
			resultado:='Copiado realizado con exito.';
	
			return;
		end;
$$ language plpgsql;
select copiar_archivo();
select * from tmp_productos;
select * from productos;

-- drop function eliminar producto
create or replace function eliminar_producto(integer, out mensaje text) returns text as $$
	declare
		begin
			delete from productos p where p.productoid = $1;
			raise notice 'delete row with id= % ... ' , $1;
			
			mensaje:='delete row id = ' || $1 || ' ...';
			return;
		end;
$$ language plpgsql;
select * from productos;
select eliminar_producto(9);

-- funcion que actualiza precio y devuelve dato
create or replace function actualizar_precio(integer, double precision) returns text as $$
	declare
		cod_prod integer;
		nombre_producto varchar;
		begin
			update productos p set precio = $2 where p.productoid = $1;
			-- para agregar dato a una variable con un select utilizamos into
			select p.descripcion into nombre_producto from productos p where p.productoid = $1;
			return nombre_producto;
		end;
$$ language plpgsql;
select actualizar_precio(12, 100.15);
select * from productos;

-- funcion que crea un backup de una tabla
create or replace function backup() returns boolean as $$
	declare
		begin
			copy (select * from productos) to 'D:\programacion\postgresql_ayudas\postgresql-ayudas\respaldo_productos.csv' delimiter ',' csv header;
			return true;
		end;
$$ language plpgsql;
select backup();


-- funcion que incrementa los precios de los productos
create or replace function incrementar_precio() returns void as $$
	declare
		begin
			update productos set precio = (precio * 0.10) + precio;
			raise notice 'Se actualizaron los precios de productos.';
			return;
		end;
$$ language plpgsql;

select incrementar_precio();
select * from productos;

-- funcion que visualizamos un producto con con datos compuestos
create or replace function see_prod(integer) returns productos as $$
	declare
		prod productos; -- este es un dato compuesto de tipo producto
		begin
			select * from productos where productoid = $1 into prod;
			return prod;
		end;
$$ language plpgsql;
select see_prod(100);
select * from productos;

-- funcion que retorna datos (muchos) compuestos
create or replace function see_all_prod() returns setof productos as $$
	declare
		resultado record;
		begin
		
			for resultado in select * from productos loop
				return next resultado;
			end loop;
			
			return;
		end;
$$ language plpgsql;
select see_all_prod();

-- funcion que retorna dato pero lanza una excepcion
create or replace function see_prod2(integer) returns varchar as $$
	declare
		prod varchar;
		begin
		
			select descripcion into prod from productos where productoid = $1;
			
			if not found then
				raise exception 'El producto % NO ha sido encontrado', $1; 
			end if;
			
			return prod;
		end;
$$ language plpgsql;
select see_prod2(1);

-- seccion nueva para el sql postgresql
/*
Seleccione de la tabla alumnos
la columna carrera, cuente los alumnos en la otra columna
agrupe por carreara para que se pueda contar
de ese resultado excluya las carreras Bionica y artes
*/
select
	a.carrera,
	count(*) as cuantos_alumnos
		from alumnos a
		group by a.carrera
			having 
				a.carrera <> 'Bionica'
					and
				a.carrera <> 'Artes';

/* seleccione la tabla alumnos agrupe sus datos por carrera y mire 
	de esas carreras el mayor promedio pero solamente de Fisico Matematico
*/
select a.carrera, max(a.promedio) as mayor_promedio
	from alumnos a
		group by a.carrera
		having a.carrera = 'Fisico Matematico';
		
/*  
	Mas ejemplos
*/
select 
	c.nombre, 
	max(c.temperatura_maxima) as temperatura_max 
		from ciudades c
		group by c.nombre
		having max(c.temperatura_maxima) <= 30;
select 
	c.nombre, 
	max(c.temperatura_maxima) as temperatura_max 
		from ciudades c
		where c.nombre like '%C%'
		group by c.nombre
		having max(c.temperatura_maxima) <= 30;
		
		
/* 

	`VISTAS` se crean a partir de una consulta
	por lo cual no esta almacenada fisicamente.
	
	
	ejemplo

 */
 create view consulta_libros_editorial as select * 
	from libros l
		inner join editorial e
			on l.codigoeditorial = e.codigo_editorial;

-- delete view
drop view consulta_libros_editorial