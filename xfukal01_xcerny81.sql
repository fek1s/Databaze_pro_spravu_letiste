
drop table Ucet;
drop table PremiovyUcet;
drop table Letentka;
drop table Let;
drop table Letiste;
drop table LeteckaSpolecnost;

create table Ucet (
    idUctu int primary key,
    jmeno nvarchar2(255) not null,
    prijmeni nvarchar2(255) not null,
    datumNarozeni date not null
);

create table PremiovyUcet (
    idUctu int primary key REFERENCES Ucet(idUctu) ON DELETE CASCADE,
    sleva int not null
);

create table Letentka (
    idLetentky int primary key,
    cena int not null,
    trida nvarchar2(255) not null,
    sedadlo int not null,
    jmeno nvarchar2(255),
    prijmeni nvarchar2(255)
);

create table Let (
    idLetu int primary key,
    typLetadla nvarchar2(255) not null,
    pocetMist int not null
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

