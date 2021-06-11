--CREATE DATABASE NegozioDischi

CREATE TABLE Band(
	ID INT IDENTITY(1, 1),
	Nome VARCHAR(50) NOT NULL,
	NumComponenti INT NOT NULL,
	PRIMARY KEY (ID)
)

CREATE TABLE Album(
	ID INT IDENTITY(1, 1),
	Titolo VARCHAR(50) NOT NULL,
	AnnoUscita INT NOT NULL,
	CasaDiscografica VARCHAR(50) NOT NULL,
	Genere VARCHAR(20) NOT NULL,
	SuppDistribuzione VARCHAR(20) NOT NULL,
	BandID INT NOT NULL
	PRIMARY KEY (ID)
	FOREIGN KEY (BandID) REFERENCES Band(ID),
	UNIQUE(Titolo, AnnoUscita, CasaDiscografica, Genere),
	CHECK(Genere IN ('Classico', 'Jazz', 'Pop', 'Rock', 'Metal')),
	CHECK(SuppDistribuzione IN ('CD', 'Vinile', 'Streaming'))
)

CREATE TABLE Brano(
	ID INT IDENTITY(1, 1),
	Titolo VARCHAR(50) NOT NULL,
	Durata INT NOT NULL,
	PRIMARY KEY (ID)
)

CREATE TABLE AlbumBrano(
	AlbumID int NOT NULL,
	BranoID int NOT NULL,
	FOREIGN KEY (AlbumID) REFERENCES Album(ID),
	FOREIGN KEY (BranoID) REFERENCES Brano(ID),
)

------------------------------------------------
--INSERT INTO BAND VALUES('883', 3)

--INSERT INTO ALBUM VALUES('hanno ucciso l uomo ragno', 1992, 'ita1', 'pop', 'cd', 1), 
--('nord sud est ovest', 1993, 'ita1', 'pop', 'cd', 1)

--INSERT INTO BRANO VALUES('hanno ucciso l uomo ragno', 4), ('jolly blue', 4), ('sei un mito', 3)

--INSERT INTO ALBUMBRANO VALUES(1, 1), (1, 2), (2, 3)

--INSERT INTO BAND VALUES('Green Day', 3)
--INSERT INTO ALBUM VALUES('american idiot', 2005, 'aaa', 'rock', 'cd', 2) 
--INSERT INTO BRANO VALUES('holiday', 240)
--INSERT INTO ALBUMBRANO VALUES(3, 4)

--INSERT INTO BAND VALUES('APC', 4)
--INSERT INTO ALBUM VALUES('imagine', 2004, 'bbb', 'rock', 'cd', 3) 
--INSERT INTO BRANO VALUES('imagine', 240)
--INSERT INTO ALBUMBRANO VALUES(4, 5)
--INSERT INTO BRANO VALUES('week and powerless', 300)
--INSERT INTO ALBUMBRANO VALUES(4, 6)

--INSERT INTO BAND VALUES('jhon lennon', 2)
--INSERT INTO ALBUM VALUES('imagine_jhon_lennon', 1970, 'ccc', 'rock', 'vinile', 4) 
--INSERT INTO ALBUMBRANO VALUES(5, 5)

--INSERT INTO BAND VALUES('1direction', 4)
--INSERT INTO ALBUM VALUES('boo', 2019, 'ddd', 'pop', 'streaming', 4) 
--INSERT INTO BRANO VALUES('boo2', 300)
--INSERT INTO ALBUMBRANO VALUES(6, 7)

--INSERT INTO BAND VALUES('maneskin', 4)
--INSERT INTO ALBUM VALUES('non so 2018', 2018, 'ita2', 'rock', 'cd', 5) 
--INSERT INTO ALBUM VALUES('non so 2019', 2019, 'ita2', 'rock', 'cd', 5) 
--INSERT INTO BRANO VALUES('non lo so 2018', 300)
--INSERT INTO BRANO VALUES('non lo so 2019', 300)
--INSERT INTO BRANO VALUES('non lo so 2019 bis', 300)
--INSERT INTO ALBUM VALUES('album1 2018', 2018, 'ita2', 'rock', 'cd', 6) 
--INSERT INTO ALBUM VALUES('album2 2019', 2019, 'ita2', 'rock', 'cd', 6) 
--INSERT INTO BRANO VALUES('non lo so 2018 bis', 300)
--INSERT INTO BRANO VALUES('non lo so 2019 bis', 300)
--INSERT INTO ALBUMBRANO VALUES(11, 11)
--INSERT INTO ALBUMBRANO VALUES(12, 12)

--INSERT INTO ALBUMBRANO VALUES(7, 8)
--INSERT INTO ALBUMBRANO VALUES(8, 9)
--INSERT INTO ALBUMBRANO VALUES(8, 10)

SELECT * FROM ALBUM
SELECT * FROM BRANO

select * from band

--------------------------------------------------------------
-- Scrivere una query che restituisca i titoli degli album degli “883”
SELECT a.Titolo
FROM Album a
JOIN Band b
ON a.BandID = b.ID
WHERE b.Nome = '883'

-- Selezionare tutti gli album editi dalla casa editrice nell’anno specificato
SELECT a.Titolo,a.CasaDiscografica,  a.AnnoUscita
FROM Album a
where a.CasaDiscografica = 'ita1' AND a.AnnoUscita =1992

--Scrivere una query che restituisca tutti i titoli delle canzoni dei “Maneskin” 
--appartenenti ad album pubblicati prima del 2019
SELECT b.Titolo
FROM Brano b
JOIN AlbumBrano ab
ON b.ID = ab.BranoID
JOIN Album a
ON a.ID = ab.AlbumID
JOIN Band ban
on ban.ID = a.BandID
WHERE a.AnnoUscita < 2019 AND ban.Nome ='maneskin'


-- Individuare tutti gli album in cui è contenuta la canzone “Imagine”;

SELECT distinct a.*
FROM Album a
JOIN AlbumBrano ab
ON a.id = ab.AlbumID
JOIN Brano b
ON b.ID = ab.BranoID
WHERE b.id = any (select bra.id
			 from brano bra
			 join albumbrano ab
			 on ab.BranoID = bra.ID
			 join album a
			 on a.ID = ab.AlbumID
			 where bra.Titolo ='imagine')



-- restituire il numero totale di canzoni eseguite dalla band “The Giornalisti"
SELECT table1.nome as 'nome band', count(*) as 'numero brani'
from
(SELECT distinct b.nome, bra.Titolo
FROM Band b
JOIN Album a
ON b.ID = a.BandID
JOIN AlbumBrano ab
ON a.ID = ab.AlbumID
JOIN Brano bra
on bra.ID = ab.BranoID) table1
group by table1.nome
having table1.nome = 'The Giornalisti'

--Contare per ogni album, la somma dei minuti dei brani contenuti.
select table2.titolo, sum(table2.durata) as 'durata album'
from (select a.Titolo, b.Durata
from album a
join AlbumBrano ab
on ab.AlbumID = a.id
join brano b
on b.ID = ab.BranoID) table2
group by table2.titolo


--Creare una view che mostri i dati completi dell’album, dell’artista e dei brani contenuti in essa
CREATE VIEW [DatiCompletiAlbum] AS(
SELECT a.Titolo, a.Genere, a.AnnoUscita, a.CasaDiscografica, a.SuppDistribuzione,
b.Nome, b.NumComponenti, bra.Titolo as 'brano'
FROM album a
JOIN band b
ON a.bandID = b.id
JOIN AlbumBrano ab
ON a.id = ab.AlbumID
JOIN Brano bra
on bra.id = ab.BranoID
);

SELECT * FROM [DatiCompletiAlbum]

--Scrivere una funzione utente che calcoli per ogni genere musicale quanti album sono inseriti in catalogo;
--FUNZIONE2

CREATE FUNCTION ufnFunzione6 (@genere VARCHAR(20))
RETURNS INT
AS
BEGIN
	RETURN (SELECT COUNT(*)
	FROM album a
	WHERE a.genere = @genere
	GROUP BY a.genere)
END

SELECT distinct a.genere, dbo.ufnFunzione6(a.genere)
FROM album a







