drop table PREMIOVYUCET
/

drop table LETENKA
/

drop table UCET
/

drop table LET
/

drop table LETISTE
/

drop table LETECKASPOLECNOST
/

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

INSERT INTO Ucet (jmeno, prijmeni, rokNarozeni) VALUES
('Richard', 'Novotný', 2001);

INSERT INTO Ucet (jmeno, prijmeni, rokNarozeni) VALUES
('Jiří', 'Z Poděbrad', 1999);

INSERT INTO PremiovyUcet (idUctu, sleva) VALUES
(2, 10);

INSERT INTO PremiovyUcet (idUctu, sleva) VALUES
(4, 15);

INSERT INTO Letiste (kodLetiste, nazev, mesto, stat) VALUES
('PRG', 'Letiště Václava Havla Praha', 'Praha', 'Česká republika');

INSERT INTO Letiste (kodLetiste, nazev, mesto, stat) VALUES
('BRQ', 'Letiště Tuřany', 'Brno', 'Česká republika');

INSERT INTO Letiste (kodLetiste, nazev, mesto, stat) VALUES
('LON', 'London Airport', 'London', 'UK');

INSERT INTO Letiste (kodLetiste, nazev, mesto, stat) VALUES
('KTW', 'Katowice Airport', 'Katowice', 'PL');

INSERT INTO Letiste (kodLetiste, nazev, mesto, stat) VALUES
('OSR', 'Ostrava Airport', 'Ostrava', 'CZ');

INSERT INTO LeteckaSpolecnost (ICO, nazev, zemePusobeni, reditel) VALUES
(12345678, 'Czech Airlines', 'Česká republika', 'Petr Nový');

INSERT INTO LeteckaSpolecnost (ICO, nazev, zemePusobeni, reditel) VALUES
(89765432, 'Ryanair', 'Anglie', 'John Black');

INSERT INTO Let (idLetu, typLetadla, pocetMist, ICO, kodLetiste_prilet, kodLetiste_odlet) VALUES
(1, 'Airbus A320', 180, 12345678, 'PRG', 'BRQ');

INSERT INTO Let (idLetu, typLetadla, pocetMist, ICO, kodLetiste_prilet, kodLetiste_odlet) VALUES
(2, 'Boeing 737', 220, 89765432, 'PRG', 'LON');

INSERT INTO Let (idLetu, typLetadla, pocetMist, ICO, kodLetiste_prilet, kodLetiste_odlet) VALUES
(3, 'Boeing 737', 220, 89765432, 'KTW', 'OSR');

INSERT INTO Letenka (idLetenky, cena, trida, sedadlo, jmeno, prijmeni, idLetu, idUctu) VALUES
(1, 1000, 'Economy', 1, 'Jakub', 'Horuba', 1, 3);

INSERT INTO Letenka (idLetenky, cena, trida, sedadlo, jmeno, prijmeni, idLetu, idUctu) VALUES
(2, 1200, 'Economy', 115, 'Jan', 'Prkenný', 2, 1);

INSERT INTO Letenka (idLetenky, cena, trida, sedadlo, jmeno, prijmeni, idLetu, idUctu) VALUES
(3, 1200, 'Economy', 154, 'Richard', 'Blue', 2, 4);

INSERT INTO Letenka (idLetenky, cena, trida, sedadlo, jmeno, prijmeni, idLetu, idUctu) VALUES
(4, 899, 'Economy', 199, 'Richard', 'Novotny', 3, 3);
-- konec plneni databaze testovacimy daty

-- Dotaz 1: Vypisuje jmeno a prijmeni zakaznika, ktery ma premiovy ucet a jeho slevu.
SELECT U.jmeno, U.prijmeni, PU.sleva
FROM Ucet U
JOIN PremiovyUcet PU ON U.idUctu = PU.idUctu;

-- Dotaz 2: Vypisuje ceny letenek koupenych ucty lidi narozenych ve 21. stoleti
SELECT U.jmeno, U.prijmeni, U.rokNarozeni, L.cena AS cenaLetenky
FROM Letenka L
JOIN Ucet U on L.idUctu = U.idUctu
WHERE U.rokNarozeni > 1999;

-- Dotaz 3: Vypisuje celkovy pocet mist v jednotlivych letech pro kazdou letadlo-spolecnost.
SELECT LS.nazev, L.typLetadla, SUM(L.pocetmist) AS celkovyPocetMist
FROM Let L
JOIN LeteckaSpolecnost LS ON L.ICO = LS.ICO
GROUP BY LS.nazev, L.typLetadla;

-- Dotaz 4: Vypisuje vsechny lety, ktere maji nejake volna mista, které lze zakoupit
SELECT *
FROM Let L
WHERE EXISTS(
    SELECT 1
    FROM Letenka LE
    WHERE L.idLetu = LE.idLetu
);

-- Dotaz 5: vypisuje vsechny cestujici kteri leti s leteckeckou společností Ryanair
SELECT L.jmeno , L.prijmeni, LE.typLetadla
FROM Letenka L
JOIN Let LE ON L.idLetu = LE.idLetu
JOIN LeteckaSpolecnost LS on LE.ICO = LS.ICO
WHERE LS.nazev = 'Ryanair';

-- Dotaz 6: Vypočítá průměrnou cenu letenky pro každou třídu.
SELECT trida, AVG(cena) AS prumer_ceny
FROM Letenka
GROUP BY trida;

-- Dotaz 7: vypisuje vsechny spolecnosti ktere provozuji lety s letadly Boeing (Boeing 737, 747...)
SELECT Distinct LS.nazev
FROM LeteckaSpolecnost LS
JOIN Let L on LS.ICO = L.ICO
Where L.typLetadla IN ('Boeing 737', 'Boeing 737 MAX', 'Boeing 747', 'Boeing 757');
