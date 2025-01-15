-- Ejercicio 2
-- Utilizando JOIN realizarás las siguientes consultas:
-- Listado de los países que están haciendo compras.

SELECT DISTINCT country 
FROM transaction
LEFT JOIN company
ON company_id = company.id
;


-- Desde cuántos países se realizan las compras.
SELECT COUNT(distinct country) as NUMERO_DE_PAISES
FROM transaction
LEFT JOIN company
ON company_id = company.id
;

-- Identifica la compañía con la mayor media de ventas.

SELECT company_name, avg(amount) 
FROM transaction
JOIN company
ON company_id = company.id
WHERE declined = 0
GROUP BY company_name
ORDER BY avg(amount) desc
LIMIT 1;

-- Ejercicio 3
-- Utilizando sólo subconsultas (sin utilizar JOIN):
-- Muestra todas las transacciones realizadas por empresas de Alemania.
 
 SELECT * 
 FROM transaction
 WHERE company_id in 
 (SELECT id
 FROM company
 WHERE country = "Germany"
);
 
-- Lista las empresas que han realizado transacciones por un amount superior a la media de todas las transacciones.

SELECT company_name
FROM company
WHERE id IN (SELECT DISTINCT company_id
FROM transaction
WHERE amount > (SELECT avg(amount) FROM transaction WHERE declined = 0));

-- Eliminarán del sistema las empresas que no tienen transacciones registradas, entrega el listado de estas empresas.
-- LA respuesta: parece que no hay empresas sin transaciones registrades. Hay transaciones con el estatus "DEclines", pero no es lo mismo desde mi punto de vista.

SET SQL_SAFE_UPDATES = 0;
DELETE FROM company
WHERE id NOT IN (
  SELECT company_id 
  FROM transaction
);

-- Nivell 2
-- Exercici 1 Identifica els cinc dies que es va generar la quantitat més gran d'ingressos a l'empresa per vendes. Mostra la data de cada transacció juntament amb el total de les vendes.

SELECT DATE(timestamp), sum(AMOUNT)
FROM TRANSACTION
WHERE declined = 0
GROUP BY DATE(timestamp), COMPANY_ID
ORDER BY sum(AMOUNT) DESC
LIMIT 5
;

-- Ejercicio 2 ¿Cuál es el promedio de ventas por país? Presenta los resultados ordenados de mayor a menor medio.

SELECT COUNTRY, AVG(AMOUNT)
FROM company
JOIN transaction
ON COMPANY.ID = company_id
WHERE declined = 0
GROUP BY COUNTRY
ORDER BY AVG(AMOUNT) DESC;

-- Ejercicio 3
/* En tu empresa, se plantea un nuevo proyecto para lanzar algunas campañas publicitarias para hacer competencia a la compañía "Non Institute". 
Para ello, te piden la lista de todas las transacciones realizadas por empresas que están situadas en el mismo país que esta compañía.
Muestra el listado aplicando JOIN y subconsultas. */

SELECT *
FROM TRANSACTION
JOIN COMPANY 
ON COMPANY_ID = COMPANY.ID
WHERE COUNTRY IN (SELECT COUNTRY
FROM COMPANY
WHERE COMPANY_NAME = "Non Institute")
ORDER BY AMOUNT;

-- Muestra el listado aplicando solamente subconsultas.

SELECT * 
FROM TRANSACTION
WHERE COMPANY_ID IN (
SELECT ID
FROM COMPANY
WHERE COUNTRY IN (SELECT COUNTRY
FROM COMPANY
WHERE COMPANY_NAME = "Non Institute"))
ORDER BY AMOUNT;



/* Ejercicio 1
Presenta el nombre, teléfono, país, fecha y amount, de aquellas empresas que realizaron transacciones con un valor comprendido entre 100 y 200 euros
 y en alguna de estas fechas: 29 de abril de 2021, 20 de julio de 2021 y 13 de marzo de 2022. Ordena los resultados de mayor a menor cantidad.*/ 
 
 SELECT COMPANY_NAME, PHONE, COUNTRY, DATE(timestamp), AMOUNT
 FROM COMPANY
 JOIN TRANSACTION
 ON COMPANY.ID = COMPANY_ID
 WHERE AMOUNT BETWEEN 100 AND 200
 AND DATE(timestamp) IN ("2021-04-29", "2021-07-20", "2022-03-13")
 AND declined = 0;
 
 /*Ejercicio 2
Necesitamos optimizar la asignación de los recursos y dependerá de la capacidad operativa que se requiera, por lo que te piden la información sobre 
la cantidad de transacciones que realizan las empresas, pero el departamento de recursos humanos es exigente y quiere un listado de las empresas donde 
especifiques si tienen más de 4 transacciones o menos.*/

SELECT COMPANY_NAME, COUNT(transaction.ID),
CASE
  WHEN COUNT(transaction.ID) >=4 THEN "MAS DE 4"
  ELSE "4 O MENOS"
END AS QUANTITY
FROM TRANSACTION
JOIN COMPANY
ON COMPANY_ID = COMPANY.ID
WHERE declined = 0
GROUP BY COMPANY_ID
ORDER BY QUANTITY;
