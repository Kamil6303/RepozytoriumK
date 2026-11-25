#Zadanie1
show databases;

use infs_gasinskik;
show tables;

create table pracownik (
id_pracownika int auto_increment primary key,
imie varchar(40) not null,
nazwisko varchar (60) not null,
data_urodzenia date not null
);

insert into pracownik (imie,nazwisko,data_urodzenia)
values ('Bartosz','Szczerba','2000-10-10');
 
update pracownik set data_urodzenia='2019-10-19' where 
 id_pracownika=3;
 
 select * from pracownik;
#Zadanie2
create table zadanie(
id_zadania int auto_increment primary key,
nazwa_zadania varchar(150) not null,
piorytet ENUM('normalny', 'wysoki', 'niski'),
opis text,
pracownik INT REFERENCES pracownik(id_pracownika) ON DELETE SET NULL
);

alter table zadanie alter column piorytet set default 'normalny';
insert into zadanie (nazwa_zadania,piorytet,opis,pracownik)
values ('Obcinanie','wysoki','Nic',1),
('Fajrant','normalny','sd',2),
('Sadzenie','niski','Bambarylo',3);

 select * from zadanie;
 #Zadanie3
 create table projekt(
id_projektu int auto_increment primary key,
nazwa_projektu varchar(150) ,
data_rozpoczecia date,
data_zakonczenia date null
);
ALTER TABLE projekt
ADD menadzer_projektu INT REFERENCES pracownik(id_pracownika);

select * from projekt;

INSERT INTO projekt (nazwa_projektu, data_rozpoczecia, data_zakonczenia, menadzer_projektu)
VALUES 
('System CRM', '2026-01-15', NULL, 1),
('Aplikacja Mobilna', '2026-02-01', '2026-06-30', 2);

ALTER TABLE zadanie
ADD projekt INT REFERENCES projekt(id_projektu) ON DELETE CASCADE;


UPDATE zadanie 
SET projekt = 1 
WHERE id_zadania IN (1, 2);


UPDATE zadanie 
SET projekt = 2 
WHERE id_zadania = 3;
#Zadanie4
create table sprint(
id_sprintu int primary key auto_increment,
numer_sprintu int unsigned,
data_rozpoczecia date,
data_zakonczenia date
);

alter table zadanie add sprint int null, add foreign key(sprint) 
references sprint(id_sprintu) on delete set null;

INSERT INTO sprint (numer_sprintu, data_rozpoczecia, data_zakonczenia)
VALUES (1, '2026-11-01', '2026-11-14');

UPDATE zadanie
SET sprint = 1
WHERE id_zadania IN (1, 2);

#Zadanie5

create table status (
id_statusu int primary key auto_increment,
nazwa_statusu varchar(20)
);

INSERT INTO status (nazwa_statusu)
VALUES ('Zajęty'),
('Szybki'),
('Wolny');
select * from zadanie;

create table zadanie_has_status (
id_zdarzenia int primary key auto_increment,
id_zadania int,
id_statusu int,
data_zdarzenia timestamp default current_timestamp,
foreign key (id_zadania) references zadanie(id_zadania),
foreign key (id_statusu) references status(id_statusu)
);

INSERT INTO zadanie_has_status (id_zadania, id_statusu)
VALUES 
(10, 1),
(11, 2),
(12, 3);

DELETE FROM projekt 
WHERE id_projektu = 1;

drop table sprint;
-- ALTER TABLE zadanie DROP FOREIGN KEY zadanie_ibfk_1;pracownikpracownik


-- LAB04 --
-- Zad.1
select * from projekt;
SHOW CREATE TABLE zadanie;
alter table pracownik drop PRIMARY KEY;
ALTER TABLE pracownik
MODIFY id_pracownika INT NOT NULL;

SHOW CREATE TABLE zadanie;
SHOW CREATE TABLE projekt;
SHOW CREATE TABLE pracownik;

ALTER TABLE projekt
DROP FOREIGN KEY fk_menadzer_projektu;

ALTER TABLE pracownik
MODIFY id_pracownika INT NOT NULL;

ALTER TABLE pracownik
DROP PRIMARY KEY;

ALTER TABLE pracownik
ADD PRIMARY KEY (id_pracownika);

ALTER TABLE pracownik
MODIFY id_pracownika INT NOT NULL AUTO_INCREMENT;

ALTER TABLE zadanie
ADD CONSTRAINT fk_zadanie_pracownik
FOREIGN KEY (pracownik)
REFERENCES pracownik(id_pracownika)
ON DELETE SET NULL;

ALTER TABLE projekt
ADD CONSTRAINT fk_menadzer_projektu
FOREIGN KEY (menadzer_projektu)
REFERENCES pracownik(id_pracownika);
-- Zad.2
-- 1. 
ALTER TABLE zadanie
ADD godziny_szacowane INT DEFAULT 8;

-- 2.
UPDATE zadanie SET godziny_szacowane = 4 WHERE id_zadania = 1;
UPDATE zadanie SET godziny_szacowane = 12 WHERE id_zadania = 2;
UPDATE zadanie SET godziny_szacowane = 16 WHERE id_zadania = 3;

-- 3.
ALTER TABLE zadanie
ALTER COLUMN godziny_szacowane SET DEFAULT 6;

-- 4.
INSERT INTO zadanie (nazwa_zadania, piorytet, opis)
VALUES ('Nowe zadanie', 'normalny', 'Test wartości domyślnej');


SELECT * FROM zadanie;


DELETE FROM zadanie
WHERE nazwa_zadania = 'Nowe zadanie';

-- Zad.3
-- 1. 
ALTER TABLE projekt
ADD opis_kratki VARCHAR(50) NULL;

-- 2. 
ALTER TABLE projekt
MODIFY opis_kratki VARCHAR(200) NULL;

-- 3. 
UPDATE projekt
SET opis_kratki = 'MVP'
WHERE id_projektu = 1;

UPDATE projekt
SET opis_kratki = 'Pilne wdrożenie'
WHERE id_projektu = 2;


SELECT * FROM projekt;

-- 4. 
ALTER TABLE projekt
DROP COLUMN opis_kratki;

-- Zad.4
-- 1. 
ALTER TABLE zadanie
DROP FOREIGN KEY fk_zadanie_projekt;

-- 2. 
ALTER TABLE zadanie
ADD CONSTRAINT fk_zadanie_projekt
FOREIGN KEY (projekt)
REFERENCES projekt(id_projektu)
ON DELETE SET NULL;

-- 3. 
DELETE FROM projekt
WHERE id_projektu = 2;

-- 4. 
SELECT * FROM zadanie;


-- LAB 05 --
-- Zad.1
create table CLIENT as select * from company_2025.CLIENT;
create table `ORDER` as select * from company_2025.ORDER;
create table EMPLOYEE as select * from company_2025.EMPLOYEE;

select * from `ORDER`;
select * from `ORDER` where order_status=5;
select * from `ORDER` where order_id in (1,3,5) and order_status in(1,3,5);

-- Zad.2
select * from EMPLOYEE where FIRST_NAME='Agnieszka' and pensja=3900;
select * from EMPLOYEE where pensja between 5000 and 7000;
select * from CLIENT where SHORT_NAME like '%eco%' and IS_COMPANY=1;

-- Zad.3
select * from `ORDER` where MONTH(ORDER_DATE)=6 or MONTH(ORDER_DATE)=7;
select * from CLIENT where TAX_IDENTIFIER is not NULL order by SHORT_NAME ASC;
select * from EMPLOYEE order by BIRTH_DATE ASC LIMIT 5;

-- Zad.4
select distinct FIRST_NAME from EMPLOYEE;
select CONCAT(FIRST_NAME," - ",LAST_NAME) as bla from EMPLOYEE where LAST_NAME like "Ko%";
select LAST_NAME,pensja from EMPLOYEE where YEAR(DATE_OF_EMPLOYMENT) between 2010 and 2014;
select * from EMPLOYEE;

-- Zad.5
select pensja,round(pensja*0.75,2) as pensja_netto, round(pensja*0.25,2) as kwota_podatku from EMPLOYEE;
select * from CLIENT where TAX_IDENTIFIER is NULL;
select SHORT_NAME from CLIENT where SHORT_NAME like "K%" or "%ski" order by SHORT_NAME DESC;
