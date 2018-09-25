CREATE DATABASE test;

USE test;

CREATE TABLE `name` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `firstname` varchar(40) DEFAULT NULL,
  `lastname` varchar(40) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=latin1;

 CREATE TABLE `address` (
  `id` int(11) NOT NULL,
  `street` varchar(40) DEFAULT NULL,
  `city` varchar(30) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

INSERT INTO name(firstname, lastname)
VALUES ('Billy', 'Bob');

INSERT INTO name(firstname, lastname)
VALUES ('Willy', 'Nilly');

INSERT INTO address(id, street, city) 
VALUES (8, 'Billy Bob Ave', 'Hickeryville');

INSERT INTO address(id, street, city) 
VALUES (9, 'Willy Nilly Lane', 'Hickeryville');

SELECT n.firstname, n.lastname, a.street, a.city
FROM name n
JOIN address a ON n.id = a.id;

