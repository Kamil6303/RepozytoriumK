-- -----------------------------------------------------
-- Tworzenie bazy danych i przełączenie kontekstu
-- -----------------------------------------------------
CREATE DATABASE IF NOT EXISTS mundial_db 
CHARACTER SET utf8mb4 
COLLATE utf8mb4_unicode_ci;

USE mundial_db;

-- -----------------------------------------------------
-- 1. Tabela: Druzyny
-- -----------------------------------------------------
CREATE TABLE Druzyny (
    id_druzyny INT AUTO_INCREMENT PRIMARY KEY,
    nazwa_kraju VARCHAR(50) NOT NULL UNIQUE,
    grupa CHAR(1) NOT NULL -- Przechowuje np. 'A', 'B', 'C' (wymóg fazy grupowej)
);

-- -----------------------------------------------------
-- 2. Tabela: Pilkarze
-- -----------------------------------------------------
CREATE TABLE Pilkarze (
    id_pilkarza INT AUTO_INCREMENT PRIMARY KEY,
    id_druzyny INT NOT NULL,
    imie VARCHAR(50) NOT NULL,
    nazwisko VARCHAR(50) NOT NULL,
    numer_koszulki INT NULL,
    pozycja VARCHAR(30) NULL,
    FOREIGN KEY (id_druzyny) REFERENCES Druzyny(id_druzyny) 
        ON DELETE RESTRICT ON UPDATE CASCADE
);

-- -----------------------------------------------------
-- 3. Tabela: Sztab (Sztab medyczno-techniczny)
-- -----------------------------------------------------
CREATE TABLE Sztab (
    id_czlonka INT AUTO_INCREMENT PRIMARY KEY,
    id_druzyny INT NOT NULL,
    imie VARCHAR(50) NOT NULL,
    nazwisko VARCHAR(50) NOT NULL,
    rola ENUM('Trener', 'Asystent', 'Lekarz', 'Fizjoterapeuta', 'Inna') NOT NULL,
    FOREIGN KEY (id_druzyny) REFERENCES Druzyny(id_druzyny) 
        ON DELETE RESTRICT ON UPDATE CASCADE
);

-- -----------------------------------------------------
-- 4. Tabela: Stadiony
-- -----------------------------------------------------
CREATE TABLE Stadiony (
    id_stadionu INT AUTO_INCREMENT PRIMARY KEY,
    nazwa_stadionu VARCHAR(100) NOT NULL UNIQUE,
    miasto VARCHAR(50) NOT NULL,
    pojemnosc INT NOT NULL
);

-- -----------------------------------------------------
-- 5. Tabela: Sedziowie
-- -----------------------------------------------------
CREATE TABLE Sedziowie (
    id_sedziego INT AUTO_INCREMENT PRIMARY KEY,
    imie VARCHAR(50) NOT NULL,
    nazwisko VARCHAR(50) NOT NULL,
    kraj_pochodzenia VARCHAR(50) NOT NULL
);

-- -----------------------------------------------------
-- 6. Tabela: Mecze
-- -----------------------------------------------------
CREATE TABLE Mecze (
    id_meczu INT AUTO_INCREMENT PRIMARY KEY,
    id_gospodarza INT NOT NULL,
    id_goscia INT NOT NULL,
    id_stadionu INT NOT NULL,
    data_meczu DATETIME NOT NULL,
    -- Podział na fazę grupową oraz play-off zgodnie z wymaganiami scenariusza
    faza_rozgrywek ENUM('Grupowa', '1/8 finalu', 'Cwiercfinal', 'Polfinal', 'Mecz o 3 miejsce', 'Final') NOT NULL,
    bramki_gospodarza INT DEFAULT 0,
    bramki_goscia INT DEFAULT 0,
    FOREIGN KEY (id_gospodarza) REFERENCES Druzyny(id_druzyny),
    FOREIGN KEY (id_goscia) REFERENCES Druzyny(id_druzyny),
    FOREIGN KEY (id_stadionu) REFERENCES Stadiony(id_stadionu)
);

-- -----------------------------------------------------
-- 7. Tabela pośrednia: Obsada_Sedziowska (Relacja M:N)
-- -----------------------------------------------------
CREATE TABLE Obsada_Sedziowska (
    id_meczu INT NOT NULL,
    id_sedziego INT NOT NULL,
    rola_w_meczu ENUM('Glowny', 'Liniowy', 'Techniczny', 'VAR') NOT NULL,
    PRIMARY KEY (id_meczu, id_sedziego),
    FOREIGN KEY (id_meczu) REFERENCES Mecze(id_meczu) ON DELETE CASCADE,
    FOREIGN KEY (id_sedziego) REFERENCES Sedziowie(id_sedziego) ON DELETE RESTRICT
);

-- -----------------------------------------------------
-- 8. Tabela: Bramki (Umożliwia zliczanie goli zawodników)
-- -----------------------------------------------------
CREATE TABLE Bramki (
    id_bramki INT AUTO_INCREMENT PRIMARY KEY,
    id_meczu INT NOT NULL,
    id_pilkarza INT NOT NULL,
    minuta INT NOT NULL,
    FOREIGN KEY (id_meczu) REFERENCES Mecze(id_meczu) ON DELETE CASCADE,
    FOREIGN KEY (id_pilkarza) REFERENCES Pilkarze(id_pilkarza) ON DELETE RESTRICT
);
