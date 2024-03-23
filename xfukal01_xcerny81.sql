create table Ucet (
    --id Uctu generovano automaticky
    idUctu number generated always as identity primary key,
    jmeno nvarchar2(255) not null,
    prijmeni nvarchar2(255) not null,
    rokNarozeni int not null
);

--Ucet je generalizaci entity PremiovyUcet obsahujici navic atribut sleva, pomoci konstrukce REFERENCES je atribut idUctu propojen
--PremiovyUcet tedy je tedy zavisly na Ucet a atribut sleva lze priradit pouze jiz existujicimu uctu
create table PremiovyUcet (
    idUctu int primary key REFERENCES Ucet(idUctu) ON DELETE CASCADE,
    sleva int not null,
    -- kontrola vstupu slevy
    CONSTRAINT CheckSale CHECK (sleva <= 100 and sleva >= 0)
);

create table Letiste (
    kodLetiste nvarchar2(3) primary key,
    nazev nvarchar2(255) not null,
    mesto nvarchar2(255) not null,
    stat nvarchar2(255) not null,
    -- kontrola vstupu (kod letiste musi mit prave 3 pismena)
    CONSTRAINT CheckCodeLength CHECK (length(kodLetiste) = 3)
);

create table LeteckaSpolecnost (
    ICO int primary key,
    nazev nvarchar2(255) not null,
    zemePusobeni nvarchar2(255) not null,
    reditel nvarchar2(255) not null,
    -- kontrola vstupu (ICO musi mit prave 8 cislic)
    CONSTRAINT CheckICOLength CHECK (length(ICO) = 8)
);

create table Let (
    idLetu int primary key,
    typLetadla nvarchar2(255) not null,
    pocetMist int not null,

    ICO int not null,
    kodLetiste_prilet nvarchar2(3) not null,
    kodLetiste_odlet nvarchar2(3) not null,
    CONSTRAINT fk_ICO FOREIGN KEY (ICO) REFERENCES LeteckaSpolecnost(ICO)  ON DELETE CASCADE,
    CONSTRAINT fk_kodLetiste_prilet FOREIGN KEY (kodLetiste_prilet) REFERENCES Letiste(kodLetiste)  ON DELETE CASCADE,
    CONSTRAINT fk_kodLetiste_odlet FOREIGN KEY (kodLetiste_odlet) REFERENCES Letiste(kodLetiste)  ON DELETE CASCADE
);

create table Letenka (
    idLetenky int primary key,
    cena int not null,
    trida nvarchar2(255) not null,
    CONSTRAINT EnumClass CHECK (trida in ('Economy', 'Business', 'First Class')),
    sedadlo int not null,
    jmeno nvarchar2(255),
    prijmeni nvarchar2(255),

    idUctu int,
    idLetu int not null,
    CONSTRAINT fk_idUctu FOREIGN KEY (idUctu) REFERENCES Ucet(idUctu) ON DELETE CASCADE,
    CONSTRAINT fk_idLetu FOREIGN KEY (idLetu) REFERENCES let(idLetu) ON DELETE CASCADE
);

-- testovaci naplneni databaze
INSERT INTO Ucet (jmeno, prijmeni, rokNarozeni) VALUES
('Jan', 'Novák', 1985);

INSERT INTO Ucet (jmeno, prijmeni, rokNarozeni) VALUES
('Bohuslav', 'Pavel', 1970);

INSERT INTO PremiovyUcet (idUctu, sleva) VALUES
(2, 10);

INSERT INTO Letiste (kodLetiste, nazev, mesto, stat) VALUES
('PRG', 'Letiště Václava Havla Praha', 'Praha', 'Česká republika');

INSERT INTO Letiste (kodLetiste, nazev, mesto, stat) VALUES
('BRQ', 'Letiště Tuřany', 'Brno', 'Česká republika');

INSERT INTO LeteckaSpolecnost (ICO, nazev, zemePusobeni, reditel) VALUES
(12345678, 'Czech Airlines', 'Česká republika', 'Petr Nový');

INSERT INTO Let (idLetu, typLetadla, pocetMist, ICO, kodLetiste_prilet, kodLetiste_odlet) VALUES
(1, 'Airbus A320', 180, 12345678, 'PRG', 'BRQ');

INSERT INTO Letenka (idLetenky, cena, trida, sedadlo, jmeno, prijmeni, idLetu) VALUES
(1, 1000, 'Economy', 1, 'Jakub', 'Horuba', 1);





