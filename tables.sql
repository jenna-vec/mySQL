
USE first_sql;

/*
WARNING! for PRIMARY IDS
If your id will be referenced as a foreign key, you need to make it the same type.
The table below will not work if the id needs to be referenced as an identifying integer.
*/

CREATE TABLE users (
	id SERIAL PRIMARY KEY,
	first_name VARCHAR(255),
	last_name VARCHAR(255),
	email VARCHAR(255),
	username VARCHAR(255),
  balance INT DEFAULT 100,
	password VARCHAR(255)
);

INSERT INTO users (first_name, last_name, email, username, password) VALUES ("Jared", "Thomas", "jjtho87@yahoo.com", "jjtho87", "whatever");

INSERT INTO users (first_name, last_name, email, username, password) VALUES ("Bob", "Saget", "bobsaget@yahoo.com", "bobsaget", "bobsaget");

SELECT * FROM users

UPDATE users SET first_name='Jared' where first_name='Jimmy'

DELETE FROM users WHERE first_name='Jimmy'

DROP TABLE table_name;



/* MOVIES ---------------------------------------------- */
SELECT * FROM movies;

SELECT * FROM movies WHERE title='casino';

SELECT * FROM movies WHERE usGross > 1000000;

SELECT * FROM movies WHERE releaseDate LIKE '%1994';

SELECT * FROM movies WHERE distributor = 'Sony Pictures';

SELECT * FROM movies WHERE mpaaRating='R' AND source='Based on Book/Short Story';

SELECT * FROM movies WHERE majorGenre='Drama' OR majorGenre='Comedy';

SELECT * FROM movies WHERE imdbRating >= 8 AND rottenTomatoesRating >= 90;

SELECT * FROM movies WHERE productionBudget < 6500000;



/* One to Many ------------------------------------------*/
CREATE TABLE people (
  id INT PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(255),
  age INT,
  gender VARCHAR(255)
);

INSERT INTO people (name, age, gender) VALUES ('BOB', 22, 'Male');
INSERT INTO people (name, age, gender) VALUES ('JOAN', 21, 'Female');
INSERT INTO people (name, age, gender) VALUES ('JANE', 25, 'Female');

CREATE TABLE family (
  last_name VARCHAR(255),
  people_id INT NOT NULL UNIQUE,
  FOREIGN KEY (people_id) REFERENCES people(id)
);

INSERT INTO family (last_name, people_id) VALUES ('Saget', 1);
INSERT INTO family (last_name, people_id) VALUES ('Saget', 2);
INSERT INTO family (last_name, people_id) VALUES ('Miller', 3);



/* Many to Many ------------------------------------------*/
CREATE TABLE customers (
  id INT PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(255),
  address VARCHAR(255),
  email VARCHAR(255)
);

CREATE TABLE products (
  name VARCHAR(255),
  category VARCHAR(255),
  price DOUBLE,
  CustomerId INT NOT NULL,
  FOREIGN KEY (CustomerId) REFERENCES customers(id)
);

/* Getting all of the products that Bob has bought */
SELECT customers.name, products.name
FROM customers
INNER JOIN products
ON customers.id=products.CustomerId
WHERE customers.name='Bob';

/* Getting all of the customers that have bought dumbbells */
SELECT customers.name, products.name
FROM customers
INNER JOIN products
ON customers.id=products.CustomerId
WHERE products.name='dumbbells';



/* Joined with Constraints ------------------------------------------*/
CREATE TABLE performers (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(255) UNIQUE NOT NULL,
  age INT
);

CREATE TABLE moviesTwo (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  PerformerId INT NOT NULL,
  FOREIGN KEY (PerformerId) REFERENCES performers(id)
);

INSERT INTO performers (name, age) VALUES ('Nicolas Cage', 55);
INSERT INTO performers (name, age) VALUES ('John Malkovich', 60);

INSERT INTO moviesTwo (name, PerformerId) VALUES ('Con Air', 1);
INSERT INTO moviesTwo (name, PerformerId) VALUES ('Con Air', 2);
INSERT INTO moviesTwo (name, PerformerId) VALUES ('Leaving Las Vegas', 1);
INSERT INTO moviesTwo (name, PerformerId) VALUES ('Rounders', 2);

SELECT * FROM moviesTwo WHERE name = 'Con Air';



/* Pivot Table ------------------------------------------*/
CREATE TABLE performers (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(255) UNIQUE
);

CREATE TABLE performances (
  id INT AUTO_INCREMENT PRIMARY KEY,
  title VARCHAR(255) UNIQUE,
  type VARCHAR(255)
);

INSERT INTO performers (name) VALUES ('Nicolas Cage');
INSERT INTO performers (name) VALUES ('Elizabeth Shue');

INSERT INTO performances (title, type) VALUES ('Leaving Las Vegas', 'Movie');
INSERT INTO performances (title, type) VALUES ('Con Air', 'Movie');
INSERT INTO performances (title, type) VALUES ('Karate Kid', 'Movie');

CREATE TABLE performers_performances (
  performer_id INT NOT NULL,
  performance_id INT NOT NULL,
  FOREIGN KEY performer_id REFERENCES performers(id),
  FOREIGN KEY performance_id REFERENCES performances(id)
);

INSERT INTO performers_performances (performer_id, performance_id) VALUES (1,1);
INSERT INTO performers_performances (performer_id, performance_id) VALUES (2,1);
INSERT INTO performers_performances (performer_id, performance_id) VALUES (1,2);
INSERT INTO performers_performances (performer_id, performance_id) VALUES (2,3);

/* To get all of the performance id's of the Nicolas Cage Moves */
SELECT performance_id FROM performers_performances
INNER JOIN performers
ON performers_performances.performer_id=performers.id
WHERE performers.id=1;

/* To get all of the performance names of Nicolas Cage Movies */
SELECT performances.title FROM performers_performances
INNER JOIN performers_two
INNER JOIN performances
ON performers_performances.performer_id=performers_two.id
AND performers_performances.performance_id=performances.id
WHERE performers_two.name='Nicolas Cage';

/* To get all of the performance names of Elizabeth Shue Movies */
SELECT performances.title FROM performers_performances
INNER JOIN performers_two
INNER JOIN performances
ON performers_performances.performer_id=performers_two.id
AND performers_performances.performance_id=performances.id
WHERE performers_two.name='Elizabeth Shue';

/* To get all of the performers id's in Con Air */
SELECT performer_id FROM performers_performances
INNER JOIN performances
ON performers_performances.performance_id=performances.id
WHERE performances.id=1;

/* To get all of the performers names in Con Air */
SELECT performers.name FROM performers_performances
INNER JOIN performances
INNER JOIN performers
ON performers_performances.performance_id=performances.id
AND performers_performances.performer_id=performers.id
WHERE performances.title='Con Air';
