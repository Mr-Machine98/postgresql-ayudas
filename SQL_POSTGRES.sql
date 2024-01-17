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