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