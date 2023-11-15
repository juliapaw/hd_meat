if not exists (select name from sys.databases
where name=N'hd_meat')
BEGIN
  CREATE DATABASE [hd_meat]
  COLLATE Polish_100_CI_AS
END

IF EXISTS (SELECT 1 FROM information_schema.tables WHERE TABLE_NAME LIKE 'tfakt')
DROP TABLE tfakt

IF EXISTS (SELECT 1 FROM information_schema.tables WHERE TABLE_NAME LIKE 'jednostka_miary')
DROP TABLE jednostka_miary

IF EXISTS (SELECT 1 FROM information_schema.tables WHERE TABLE_NAME LIKE 'produkt')
DROP TABLE produkt

IF EXISTS (SELECT 1 FROM information_schema.tables WHERE TABLE_NAME LIKE 'lokalizacja')
DROP TABLE lokalizacja

IF EXISTS (SELECT 1 FROM information_schema.tables WHERE TABLE_NAME LIKE 'CZAS')
DROP TABLE CZAS

CREATE TABLE CZAS
(
    id_czas varchar(14) PRIMARY KEY,
    rok varchar(4),
);

CREATE TABLE lokalizacja
(
    id_lokalizacja int PRIMARY KEY,
    wojewodztwo varchar(19)
);

CREATE TABLE produkt
(
    id_produkt int PRIMARY KEY,
    nazwa_produktu varchar(50),
);

CREATE TABLE jednostka_miary
(
    id_jednostka_miary int PRIMARY KEY,
    symbol varchar(10),
    nazwa varchar(20)
);

CREATE TABLE tfakt (
    id_czas varchar(14) FOREIGN KEY (id_czas)
        REFERENCES czas(id_czas),
    id_lokalizacja int FOREIGN KEY (id_lokalizacja)
        REFERENCES lokalizacja(id_lokalizacja),
    id_produkt int FOREIGN KEY (id_produkt)
        REFERENCES produkt(id_produkt),
    id_jednostka_miary int FOREIGN KEY (id_jednostka_miary)
        REFERENCES jednostka_miary(id_jednostka_miary),
    wartosc numeric(10,2)
);

INSERT INTO [dbo].[lokalizacja]
SELECT
    ROW_NUMBER() OVER (ORDER BY [zmienna]) as id,
    [zmienna] as wojewodztwo
FROM 
    (SELECT DISTINCT [zmienna] FROM reformatted_data) as unique_data;

INSERT INTO [dbo].[CZAS]
SELECT
    ROW_NUMBER() OVER (ORDER BY [data]) as id,
    [data] as rok
FROM 
    (SELECT DISTINCT [data] FROM reformatted_data) as unique_data;

INSERT INTO [dbo].[jednostka_miary] VALUES
 (1,'kg','kilogramy')

INSERT INTO [dbo].[PRODUKT] 
SELECT
    ROW_NUMBER() OVER (ORDER BY [produkt]) as id,
    [produkt] as nazwa_produktu
FROM 
    (SELECT DISTINCT [produkt] FROM reformatted_data) as unique_data;

INSERT INTO tfakt (id_czas, id_lokalizacja, id_produkt, id_jednostka_miary, wartosc)
SELECT
    c.id_czas,
    l.id_lokalizacja,
    p.id_produkt,
    jm.id_jednostka_miary,
    rd.cena
FROM
    dbo.reformatted_data rd
JOIN
    dbo.CZAS c ON rd.data = c.rok
JOIN
    dbo.lokalizacja l ON rd.zmienna = l.wojewodztwo
JOIN
    dbo.produkt p ON rd.produkt = p.nazwa_produktu
JOIN
    dbo.jednostka_miary jm ON jm.symbol = 'kg'