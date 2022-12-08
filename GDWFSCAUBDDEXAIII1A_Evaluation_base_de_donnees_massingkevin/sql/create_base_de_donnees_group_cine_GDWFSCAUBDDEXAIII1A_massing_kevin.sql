DROP USER IF EXISTS "martinmichel"@"localhost";
DROP USER IF EXISTS "duponderic"@"localhost"; 
DROP USER IF EXISTS "doejohn"@"localhost"; 
DROP USER IF EXISTS "paulhenry"@"localhost"; 
DROP USER IF EXISTS "administration"@"localhost"; 
DROP DATABASE IF EXISTS group_cine;
CREATE DATABASE IF NOT EXISTS group_cine CHARACTER SET utf8 COLLATE utf8_general_ci;
-- Creation d'un compte administrateur
CREATE USER "administration"@"localhost" IDENTIFIED BY "67bDq8VtV4Se";
GRANT ALL ON group_cine.* TO "administration"@"localhost";
USE group_cine;

-- CREATION DES DIFFERENTES TABLES 

CREATE TABLE managers(
    id_manager INT(5) AUTO_INCREMENT PRIMARY KEY NOT NULL,
    last_name VARCHAR(30) NOT NULL,
    first_name VARCHAR(30) NOT NULL,
    mail VARCHAR(50) NOT NULL,
    password VARCHAR(64) NOT NULL,
    cinema INT(4) NOT NULL -- FOREIGN KEY a definir apres creation de la table cinemas 
) ENGINE=INNODB;

CREATE TABLE cinemas(
id_cinema INT(4) AUTO_INCREMENT PRIMARY KEY NOT NULL,
name_cinema VARCHAR(30) NOT NULL, 
address VARCHAR(80) NOT NULL,
city VARCHAR(50) NOT NULL,
total_halls INT(2) DEFAULT 0,
manager INT(5),
FOREIGN KEY (manager) REFERENCES managers(id_manager)
) ENGINE=INNODB;

-- Creation d'une cle externe sur la colonne cinema de la table managers 
ALTER TABLE managers ADD CONSTRAINT cinema FOREIGN KEY (cinema) REFERENCES cinemas(id_cinema);

/* Table halls
    S'assurer qu'un cinema ne peut pas avoir le meme numero de salle en double ,combinaison numero salle + id cinema unique 
*/
CREATE TABLE halls(
    id_hall INT(5) AUTO_INCREMENT PRIMARY KEY NOT NULL,
    number_hall INT(2) NOT NULL,
    total_places INT(3) NOT NULL, 
    id_cinema INT(4) NOT NULL,    
    FOREIGN KEY (id_cinema) REFERENCES cinemas(id_cinema),
    UNIQUE (number_hall, id_cinema)
) ENGINE=INNODB;

CREATE TABLE movies(
    id_film INT(5) PRIMARY KEY AUTO_INCREMENT NOT NULL,
    title VARCHAR(40) NOT NULL,
    genre VARCHAR(30) NOT NULL
) ENGINE=INNODB;

CREATE TABLE prices(
    id_price INT(1) PRIMARY KEY AUTO_INCREMENT NOT NULL,
    cost REAL NOT NULL,
    description VARCHAR(30) NOT NULL
) ENGINE=INNODB;

/* Table seance 
    S'assurer qu'il ne peut y avoir qu'une seance par salle sur un creneau horaire combinaison date et salle unique 
*/
CREATE TABLE seances(
    id_seance INT(5) PRIMARY KEY AUTO_INCREMENT  NOT NULL,  
    date_seance DATETIME NOT NULL, 
    cinema INT(4) NOT NULL,    
    FOREIGN KEY (cinema) REFERENCES cinemas(id_cinema),
    hall INT(2) NOT NULL,  
    FOREIGN KEY (hall) REFERENCES halls(id_hall),
    movie INT(5) NOT NULL,
    FOREIGN KEY (movie) REFERENCES movies(id_film),    
    available_place INT(3) DEFAULT 0,
    UNIQUE (hall, date_seance)    
) ENGINE=INNODB;

CREATE TABLE reservations(
    id_reservation INT(10) PRIMARY KEY AUTO_INCREMENT NOT NULL,
    seance INT(5),
    FOREIGN KEY (seance) REFERENCES seances(id_seance),
    method_reservation VARCHAR(20),
    price INT(1),
    FOREIGN KEY (price) REFERENCES prices(id_price)
) ENGINE=INNODB;

-- CREATION DE VUE pour faciliter gestion des seances par les managers

CREATE OR REPLACE VIEW seance_cinema_1
AS SELECT s.cinema, s.id_seance, s.date_seance, s.hall, s.movie, s.available_place, h.number_hall 
FROM seances s 
INNER JOIN halls h ON s.hall = h.id_hall 
WHERE s.cinema=1;

CREATE OR REPLACE VIEW seance_cinema_2
AS SELECT s.cinema, s.id_seance, s.date_seance, s.hall, s.movie, s.available_place, h.number_hall 
FROM seances s 
INNER JOIN halls h ON s.hall = h.id_hall 
WHERE s.cinema=2;

CREATE OR REPLACE VIEW seance_cinema_3
AS SELECT s.cinema, s.id_seance, s.date_seance, s.hall, s.movie, s.available_place, h.number_hall 
FROM seances s 
INNER JOIN halls h ON s.hall = h.id_hall 
WHERE s.cinema=3;

CREATE OR REPLACE VIEW seance_cinema_4
AS SELECT s.cinema, s.id_seance, s.date_seance, s.hall, s.movie, s.available_place, h.number_hall 
FROM seances s 
INNER JOIN halls h ON s.hall = h.id_hall 
WHERE s.cinema=4;

-- DEFINITION DES TRIGGERS

/*
TRIGGER tr_before_insert_seance : venir inserer automatiquement le nombre de places disponible et l'identifiant du cinema pour une seance en fonction de la salle selectionnée
*/
delimiter |
CREATE OR REPLACE TRIGGER tr_before_insert_seance BEFORE INSERT ON seances
  FOR EACH ROW
  BEGIN
  	DECLARE av_p INT;
    DECLARE id_c INT;
    SELECT total_places INTO av_p FROM halls WHERE id_hall = NEW.hall; 
    SELECT id_cinema INTO id_c FROM halls WHERE id_hall = NEW.hall;     
    SET 
    NEW.available_place= av_p, 
    NEW.cinema = id_c;        
  END;
|
delimiter ; -- Fin trigger

/*TRIGGER add_manager_cinema : insert l'id manager dans la table cinema lors d'un ajout dans la table managers*/
CREATE TRIGGER tr_after_insert_manager_udapte_manager_cinema
AFTER INSERT ON managers 
FOR EACH ROW
UPDATE cinemas 
SET manager = NEW.id_manager 
WHERE id_cinema = NEW.cinema; -- Fin trigger

/* trigger add_hall_on_cinema, incremente total_halls de la table cinema lors d'une insertion dans la table halls */
CREATE TRIGGER tr_after_add_hall_on_cinema 
AFTER INSERT ON halls 
FOR EACH ROW 
UPDATE cinemas 
SET total_halls = total_halls + 1 
WHERE id_cinema = NEW.id_cinema; -- Fin trigger
 
/* trigger before_insert : Verifie qu'il reste des places disponible sur la seance avant d'ajouter une reservation sur cette derniere et de modifier le nombre de place restantes
    Si available_place = 0 renvoi un message d'erreur 
*/
delimiter | 
CREATE OR REPLACE TRIGGER tr_before_insert_reservation BEFORE INSERT ON reservations
  FOR EACH ROW
  BEGIN
  	DECLARE available INT;
    SELECT available_place INTO available FROM seances WHERE id_seance = NEW.seance;
        IF(available > 0)THEN 
        UPDATE seances
        SET available_place = available_place -1
        WHERE id_seance = NEW.seance;
    ELSE 
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Seance complete, plus de place disponible';
    END IF;    
  END;
|
delimiter ; -- Fin trigger

-- INSERER DES DONNEES TEST DANS LES TABLES 

/* Insertion dans table cinemas */
INSERT INTO cinemas (name_cinema, address, city)
VALUES
("Megapolis","1 rue principale", "Paris"),
("Gigapolis","57, route principale", "Metz"),
("Cinepolis","23, rue de la culture ", "Lille"),
("Lecine","1, rue nationale ", "Lyon");

/* Insertion dans table managers */
INSERT INTO managers(last_name, first_name, mail, password, cinema)
VALUES
("Martin", "Michel", "martinmichel@localhost", "$2y$10$r5V1Ahx3ZsGhWKZ4DqwHweBkdC6tQELugMOCFxRW5KUQWbYi3evmy", 1),
("Dupond", "Eric", "duponderic@localhost", "$2y$10$MYwWat22dBf2szchDQyT/.dROce8ywZzNOZfUnvkk/Aba8F7otrsu", 2),
("paul", "henry", "paulhenry@localhost", "$2y$10$.IYO.jFq1bQs2Qh5aoexqe667km845jAFdxBohAbs3prlhcofcZyC",3),
("Doe", "John", "doejohn@localhost", "$2y$10$4ndVad6pzwMYfmwe6cNKQ.6B4RID9ieGznVm4LwBSfPZCFx3IOZq.", 4)
;

/* Insertion dans la table halls */
INSERT INTO halls (number_hall, total_places, id_cinema) 
VALUES
(1, 200, 1 ),
(2, 300, 1 ),
(3, 500, 1 ),
(1, 100, 2 ),
(2, 150, 2 ),
(3, 200, 2 ),
(1, 100, 3 ),
(2, 500, 3 ),
(3, 200, 3 ),
(1, 200, 4 ),
(2, 100, 4 ),
(3, 500, 4),
(4, 3, 4)
;


/* Insertion dans table movie */
INSERT INTO movies(title, genre)
VALUES
("theMovie", "science-fiction"),
("La tour infernale", "comedie"),
("CodeGame", "science-fiction"),
("La tour infernale", "comedie")
;

/* Insertion dans la table prices */
INSERT INTO prices (description, cost) 
VALUES
('Plein tarif', 9.20),
('Etudiant', 7.60),
('Moins de 14 ans', 5.90)
;

/* Insertion dans la table seances */
INSERT INTO seances (date_seance, hall, movie) 
VALUES
("2022/11/24 15:00:00", 1, 1),
("2022/11/24 15:00:00", 2, 3),
("2022/11/24 17:00:00", 3, 3),
("2022/11/24 21:00:00", 5, 2),
("2022/11/24 22:00:00", 7, 2)
;

/* Insertion dans la table reservations */
INSERT INTO reservations (seance, method_reservation, price) 
VALUES
(1, "Sur place", 1),
(2, "Sur place", 2),
(1, "Sur place", 3),
(3, "Sur place", 2)
;

-- CREATION UTILISATEUR ET CONFIGURATION DES PERMISSIONS

-- Creation d'user pour chaque manager 
CREATE USER "martinmichel"@"localhost" IDENTIFIED BY "gkW8U9Dud6L6";
CREATE USER "duponderic"@"localhost" IDENTIFIED BY "qk8RFJ4ma96T";
CREATE USER "paulhenry"@"localhost" IDENTIFIED BY "s5tSV3Euy7F2";
CREATE USER "doejohn"@"localhost" IDENTIFIED BY "6Xx6H6Mc6rtY";

GRANT SELECT ON movies TO "martinmichel"@"localhost","duponderic"@"localhost","doejohn"@"localhost","paulhenry"@"localhost";
GRANT SELECT ON halls TO "martinmichel"@"localhost","duponderic"@"localhost","doejohn"@"localhost","paulhenry"@"localhost";
GRANT SELECT, INSERT ON seance_cinema_1 TO "martinmichel"@"localhost";
GRANT SELECT, INSERT ON seance_cinema_2 TO "duponderic"@"localhost"; 
GRANT SELECT, INSERT ON seance_cinema_3 TO "doejohn"@"localhost"; 
GRANT SELECT, INSERT ON seance_cinema_4 TO "paulhenry"@"localhost"; 

/* TEST D'INSERTION DANS LES DIFFERENTES VUES 

INSERT INTO seance_cinema_3 (date_seance, hall, movie) VALUES("2022-11-26 15:00:00", 8, 3);
INSERT INTO seance_cinema_4 (date_seance, hall, movie) VALUES("2022-11-25 13:00:00", 13, 2);
INSERT INTO seance_cinema_3 (date_seance, hall, movie) VALUES("2022-11-29 22:00:00", 2, 1);
INSERT INTO seance_cinema_4 (date_seance, hall, movie) VALUES("2022-11-27 17:00:00", 4, 2);
*/
-- commande mysql dump pour sauvegarde base donnnees
-- # mysqldump -u root --databases group_cine > C:\...
