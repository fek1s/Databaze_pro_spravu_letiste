create table Ucet (
    idUctu int primary key,
    jmeno nvarchar2(255) not null,
    prijmeni nvarchar2(255) not null,
    rokNarozeni int not null
);

create table PremiovyUcet (
    idUctu int primary key REFERENCES Ucet(idUctu) ON DELETE CASCADE,
    sleva int not null
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

    ICO int,
    kodLetiste_prilet nvarchar2(3),
    kodLetiste_odlet nvarchar2(3),
    CONSTRAINT fk_ICO FOREIGN KEY (ICO) REFERENCES LeteckaSpolecnost(ICO)  ON DELETE CASCADE,
    CONSTRAINT fk_kodLetiste_prilet FOREIGN KEY (kodLetiste_prilet) REFERENCES Letiste(kodLetiste)  ON DELETE CASCADE,
    CONSTRAINT fk_kodLetiste_odlet FOREIGN KEY (kodLetiste_odlet) REFERENCES Letiste(kodLetiste)  ON DELETE CASCADE
);

create table Letenka (
    idLetenky int primary key,
    cena int not null,
    trida nvarchar2(255) not null,
    sedadlo int not null,
    jmeno nvarchar2(255),
    prijmeni nvarchar2(255),

    idUctu int,
    idLetu int not null ,
    CONSTRAINT fk_idUctu FOREIGN KEY (idUctu) REFERENCES Ucet(idUctu) ON DELETE CASCADE,
    CONSTRAINT fk_idLetu FOREIGN KEY (idLetu) REFERENCES let(idLetu) ON DELETE CASCADE
);

-- testovaci naplneni databaze
INSERT INTO Ucet (idUctu, jmeno, prijmeni, rokNarozeni) VALUES
(1, 'Jan', 'Novák', 1985);

INSERT INTO PremiovyUcet (idUctu, sleva) VALUES
(1, 10);

INSERT INTO Letiste (kodLetiste, nazev, mesto, stat) VALUES
('PRG', 'Letiště Václava Havla Praha', 'Praha', 'Česká republika');

INSERT INTO Letiste (kodLetiste, nazev, mesto, stat) VALUES
('BRQ', 'Letiště Turany', 'Brno', 'Česká republika');

INSERT INTO LeteckaSpolecnost (ICO, nazev, zemePusobeni, reditel) VALUES
(12345678, 'Czech Airlines', 'Česká republika', 'Petr Nový');

INSERT INTO Let (idLetu, typLetadla, pocetMist, ICO, kodLetiste_prilet, kodLetiste_odlet) VALUES
(1, 'Airbus A320', 180, 12345678, 'PRG', 'BRQ');

INSERT INTO Letenka (idLetenky, cena, trida, sedadlo, jmeno, prijmeni, idUctu, idLetu) VALUES
(1, 1000, 'Economy', 1, 'Jan', 'Novák', 1, 1);



