 /* Nivell 1 Exercici 1
La teva tasca és dissenyar i crear una taula anomenada "credit_card" que emmagatzemi detalls crucials sobre les targetes de crèdit. 
La nova taula ha de ser capaç d'identificar de manera única cada targeta i establir una relació adequada amb les altres dues taules ("transaction" i 
"company"). Després de crear la taula serà necessari que ingressis la informació del document denominat "dades_introduir_credit". 
Recorda mostrar el diagrama i realitzar una breu descripció d'aquest. */

CREATE TABLE credit_card (
Id varchar(15) PRIMARY KEY,
Iban varchar(50),
pin varchar(4),
pan varchar(50),
cvv int,
expiring_date varchar(20)
); -- Estableci las relaciones de FK con transaciones via Navegador/Schemas.

SELECT *
FROM credit_card;

-- Nivell 1 Exercici 2

/* El departament de Recursos Humans ha identificat un error en el número de compte de l'usuari amb ID CcU-2938. 
La informació que ha de mostrar-se per a aquest registre és: R323456312213576817699999. 
Recorda mostrar que el canvi es va realitzar.*/

UPDATE credit_card
SET Iban = "R323456312213576817699999"
WHERE id = "CcU-2938";

SELECT * from credit_card
WHERE id = "CcU-2938";




/* Nivell 1 Exercici 3
En la taula "transaction" ingressa un nou usuari amb la següent informació:

Id	108B1D1D-5B23-A76C-55EF-C568E49A99DD
credit_card_id	CcU-9999
company_id	b-9999
user_id	9999
lat	829.999
longitude	-117.999
amount	111.11
declined	0
*/

INSERT INTO transaction (Id, credit_card_id, company_id,user_id, lat, longitude, amount, declined)
VALUES ("108B1D1D-5B23-A76C-55EF-C568E49A99DD", "CcU-9999", "b-9999", "9999", "829.999", "-117.999", "111.11", 0);

-- Asi no funciona, porque los foreign keys no estan en last parent tables. Vamos a anadirlos para que funcione bien. 

INSERT INTO company (id)
VALUES ("b-9999");

INSERT INTO credit_card (id)
VALUES ("CcU-9999");

SELECT * FROM transaction
WHERE id = "108B1D1D-5B23-A76C-55EF-C568E49A99DD";



/* Nivell 1 Exercici 4
Des de recursos humans et sol·liciten eliminar la columna "pan" de la taula credit_*card. Recorda mostrar el canvi realitzat. */

ALTER TABLE credit_card
DROP column pan;

SELECT * FROM credit_card;




/* Nivell 2 Exercici 1
Elimina de la taula transaction el registre amb ID 02C6201E-D90A-1859-B4EE-88D2986D3B02 de la base de dades. */


DELETE FROM transaction
WHERE id = "02C6201E-D90A-1859-B4EE-88D2986D3B02";

SELECT * FROM transaction
WHERE id = "02C6201E-D90A-1859-B4EE-88D2986D3B02";


/* Nivell 2 Exercici 2
La secció de màrqueting desitja tenir accés a informació específica per a realitzar anàlisi i estratègies efectives. S'ha sol·licitat crear una 
vista que proporcioni detalls clau sobre les companyies i les seves transaccions. Serà necessària que creïs una vista anomenada VistaMarketing que
 contingui la següent informació: Nom de la companyia. Telèfon de contacte. País de residència. Mitjana de compra realitzat per cada companyia. 
 Presenta la vista creada, ordenant les dades de major a menor mitjana de compra.
*/
CREATE VIEW VistaMarketing AS
SELECT company_name, phone, country, AVG(amount)
FROM company
JOIN transaction
ON company.id = company_id
WHERE declined = 0
GROUP BY company_name, phone, country
ORDER BY AVG(amount) desc;

SELECT * FROM VistaMArketing;


/* Nivell 2 Exercici 3
Filtra la vista VistaMarketing per a mostrar només les companyies que tenen el seu país de residència en "Germany"*/

SELECT * FROM VistaMarketing
WHERE country = "Germany";


/* */

/* Nivell 3 Exercici 1
La setmana vinent tindràs una nova reunió amb els gerents de màrqueting. Un company del teu equip va realitzar modificacions 
en la base de dades, però no recorda com les va realitzar. Et demana que l'ajudis a deixar els comandos executats per a obtenir
 el següent diagrama: */

-- 1 Descargo los arvhivos
-- 2 File --> Open SQL Script --> Estrcutura de dados User --> Ejecutar
-- 3 File --> Open SQL Script --> Datos Introducir User --> Ejecutar
-- 4 Actualizar en Schemas y comprobar que aparesca una nueva tabla User
-- 5 Database --> Reverse Inegneer
-- 6 Intento selecionar User.id como el FK para la table User, pero me da error. corro esta cosulta para ver cuales Id no existen en una nueva tabla:

SELECT DISTINCT user_id
FROM transactions.transaction
WHERE user_id NOT IN (SELECT id FROM transactions.user);

-- aparece el User_id que hemos anadido en el ejecricio Nivell 1 Exercici 3. .

INSERT INTO user (id)
VALUES ("9999");

-- ahora funciona y me deja establecer el FK.

-- 7 Comparo las columnas y veo algunas diferencias. con las proximas consultas las corrigo.

ALTER TABLE company
DROP column website;

ALTER TABLE user
RENAME column email to personal_email;

RENAME TABLE user to data_user;

ALTER TABLE credit_card
ADD column fecha_actual DATE;


/* Nivell 3 Exercici 2

La empresa también te solicita crear una vista llamada "InformeTecnico" que contenga la siguiente información:

ID de la transacción
Nombre del usuario/a
Apellido del usuario/a
IBAN de la tarjeta de crédito usada.
Nombre de la compañía de la transacción realizada.
Asegúrate de incluir información relevante de ambas tablas y utiliza alias para cambiar de nombre columnas según sea necesario.
Muestra los resultados de la vista, ordena los resultados de manera descendente en función de la variable ID de transaction.*/

CREATE VIEW InformeTecnico as 
SELECT transaction.id as ID_de_la_transacción,
name as "Nombre_del_usuario/a",
surname as "Apellido_del_usuario/a", 
iban as IBAN_de_la_tarjeta_de_crédito_usada, 
company_name as Nombre_de_la_compañía_de_la_transacción_realizada
FROM transaction
JOIN data_user
ON user_id = data_user.id
JOIN credit_card
ON credit_card_id = credit_card.id
JOIN company
ON company_id = company.id
ORDER BY transaction.id desc;

SELECT * FROM InformeTecnico;

