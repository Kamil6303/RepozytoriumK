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
ALTER TABLE zadanie DROP FOREIGN KEY zadanie_ibfk_1;