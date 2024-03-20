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
    idLetiste int primary key,
    nazev nvarchar2(255) not null,
    mesto nvarchar2(255) not null,
    stat nvarchar2(255) not null
);

create table LeteckaSpolecnost (
    idSpolecnosti int primary key,
    nazev nvarchar2(255) not null,
    zemePusobeni nvarchar2(255) not null,
    reditel nvarchar2(255) not null
);

create table Let (
    idLetu int primary key,
    typLetadla nvarchar2(255) not null,
    pocetMist int not null,

    idSpolecnosti int,
    idLetiste_prilet int,
    idLetiste_odlet int,
    CONSTRAINT fk_idSpolecnosti FOREIGN KEY (idSpolecnosti) REFERENCES LeteckaSpolecnost(idSpolecnosti)  ON DELETE CASCADE,
    CONSTRAINT fk_idLetiste_prilet FOREIGN KEY (idLetiste_prilet) REFERENCES Letiste(idLetiste)  ON DELETE CASCADE,
    CONSTRAINT fk_idLetiste_odlet FOREIGN KEY (idLetiste_odlet) REFERENCES Letiste(idLetiste)  ON DELETE CASCADE
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

INSERT INTO Ucet (idUctu, jmeno, prijmeni, rokNarozeni) VALUES
(1, 'Jan', 'Novák', 1985);

INSERT INTO PremiovyUcet (idUctu, sleva) VALUES
(1, 10);

INSERT INTO Letiste (idLetiste, nazev, mesto, stat) VALUES
(1, 'Letiště Václava Havla Praha', 'Praha', 'Česká republika');

INSERT INTO Letiste (idLetiste, nazev, mesto, stat) VALUES
(2, 'Letiště Václava Havla Praha', 'Brno', 'Česká republika');

INSERT INTO LeteckaSpolecnost (idSpolecnosti, nazev, zemePusobeni, reditel) VALUES
(1, 'Czech Airlines', 'Česká republika', 'Petr Nový');

INSERT INTO Let (idLetu, typLetadla, pocetMist, idSpolecnosti, idLetiste_prilet, idLetiste_odlet) VALUES
(1, 'Airbus A320', 180, 1, 1, 2);

INSERT INTO Letenka (idLetenky, cena, trida, sedadlo, jmeno, prijmeni, idUctu, idLetu) VALUES
(1, 1000, 'Economy', 1, 'Jan', 'Novák', 1, 1);
