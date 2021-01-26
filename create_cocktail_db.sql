-- =============================================================================
-- Author:      Michael Wettstein
-- Create date: 23.12.2020
-- Description: Create database, tables, trigger and view for scripting project
--              >>COCKTAIL-API<<
-- =============================================================================

CREATE DATABASE cocktail_db
GO

USE cocktail_db
GO

CREATE TABLE [dbo].[stagging](
	[idDrink] [NVARCHAR](100) NULL,
	[strDrink] [NVARCHAR](100) NULL,
	[strDrinkAlternate] [NVARCHAR](100) NULL,
	[strDrinkES] [NVARCHAR](100) NULL,
	[strDrinkDE] [NVARCHAR](100) NULL,
	[strDrinkFR] [NVARCHAR](100) NULL,
	[strDrinkZH-HANS] [NVARCHAR](100) NULL,
	[strDrinkZH-HANT] [NVARCHAR](100) NULL,
	[strTags] [NVARCHAR](100) NULL,
	[strVideo] [NVARCHAR](100) NULL,
	[strCategory] [NVARCHAR](100) NULL,
	[strIBA] [NVARCHAR](100) NULL,
	[strAlcoholic] [NVARCHAR](100) NULL,
	[strGlass] [NVARCHAR](100) NULL,
	[strInstructions] [NVARCHAR](4000) NULL,
	[strInstructionsES] [NVARCHAR](1000) NULL,
	[strInstructionsDE] [NVARCHAR](1000) NULL,
	[strInstructionsFR] [NVARCHAR](1000) NULL,
	[strInstructionsZH-HANS] [NVARCHAR](1000) NULL,
	[strInstructionsZH-HANT] [NVARCHAR](1000) NULL,
	[strDrinkThumb] [NVARCHAR](100) NULL,
	[strIngredient1] [NVARCHAR](100) NULL,
	[strIngredient2] [NVARCHAR](100) NULL,
	[strIngredient3] [NVARCHAR](100) NULL,
	[strIngredient4] [NVARCHAR](100) NULL,
	[strIngredient5] [NVARCHAR](100) NULL,
	[strIngredient6] [NVARCHAR](100) NULL,
	[strIngredient7] [NVARCHAR](100) NULL,
	[strIngredient8] [NVARCHAR](100) NULL,
	[strIngredient9] [NVARCHAR](100) NULL,
	[strIngredient10] [NVARCHAR](100) NULL,
	[strIngredient11] [NVARCHAR](100) NULL,
	[strIngredient12] [NVARCHAR](100) NULL,
	[strIngredient13] [NVARCHAR](100) NULL,
	[strIngredient14] [NVARCHAR](100) NULL,
	[strIngredient15] [NVARCHAR](100) NULL,
	[strMeasure1] [NVARCHAR](100) NULL,
	[strMeasure2] [NVARCHAR](100) NULL,
	[strMeasure3] [NVARCHAR](100) NULL,
	[strMeasure4] [NVARCHAR](100) NULL,
	[strMeasure5] [NVARCHAR](100) NULL,
	[strMeasure6] [NVARCHAR](100) NULL,
	[strMeasure7] [NVARCHAR](100) NULL,
	[strMeasure8] [NVARCHAR](100) NULL,
	[strMeasure9] [NVARCHAR](100) NULL,
	[strMeasure10] [NVARCHAR](100) NULL,
	[strMeasure11] [NVARCHAR](100) NULL,
	[strMeasure12] [NVARCHAR](100) NULL,
	[strMeasure13] [NVARCHAR](100) NULL,
	[strMeasure14] [NVARCHAR](100) NULL,
	[strMeasure15] [NVARCHAR](100) NULL,
	[strCreativeCommonsConfirmed] [NVARCHAR](100) NULL,
	[dateModified] [NVARCHAR](100) NULL
) ON [PRIMARY]

GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--drinks table
CREATE TABLE [dbo].[drinks](
	[idDrink] [nvarchar](100) NOT NULL PRIMARY KEY,
	[strDrink] [nvarchar](100) NULL,
	[idGlass] [nvarchar](100) NULL,
	[strInstructions] [nvarchar](4000) NULL,
	[idIngredient1] [int] NULL,
	[idIngredient2] [int] NULL,
	[idIngredient3] [int] NULL,
	[idIngredient4] [int] NULL,
	[idIngredient5] [int] NULL,
	[idIngredient6] [int] NULL,
	[idIngredient7] [int] NULL,
	[idIngredient8] [int] NULL,
	[idIngredient9] [int] NULL,
	[idIngredient10] [int] NULL,
	[idIngredient11] [int] NULL,
	[idIngredient12] [int] NULL,
	[idIngredient13] [int] NULL,
	[idIngredient14] [int] NULL,
	[idIngredient15] [int] NULL,
	[idMeasureIngredient1] [int] NULL,
	[idMeasureIngredient2] [int] NULL,
	[idMeasureIngredient3] [int] NULL,
	[idMeasureIngredient4] [int] NULL,
	[idMeasureIngredient5] [int] NULL,
	[idMeasureIngredient6] [int] NULL,
	[idMeasureIngredient7] [int] NULL,
	[idMeasureIngredient8] [int] NULL,
	[idMeasureIngredient9] [int] NULL,
	[idMeasureIngredient10] [int] NULL,
	[idMeasureIngredient11] [int] NULL,
	[idMeasureIngredient12] [int] NULL,
	[idMeasureIngredient13] [int] NULL,
	[idMeasureIngredient14] [int] NULL,
	[idMeasureIngredient15] [int] NULL
) ON [PRIMARY]
GO

--ingredients master
CREATE TABLE ingredients
(idIngredient INT IDENTITY,
strIngredient NVARCHAR(100) PRIMARY KEY)
GO

--measures master
CREATE TABLE measures
(idMeasure INT IDENTITY,
strMeasure NVARCHAR(100) PRIMARY KEY)
GO

--glasses table
CREATE TABLE glasses
(idGlass INT IDENTITY,
strGlass NVARCHAR(100) PRIMARY KEY)
GO

--trigger on stagging table to split the table to normalize form 
CREATE TRIGGER trgStagging ON stagging AFTER INSERT
AS
INSERT INTO drinks (idDrink, strDrink,strInstructions)
SELECT idDrink, strDrink,strInstructions FROM inserted WHERE inserted.idDrink NOT IN (SELECT idDrink FROM drinks)

INSERT INTO glasses 
SELECT DISTINCT strGlass FROM stagging WHERE strGlass NOT IN (SELECT strGlass FROM glasses) 

UPDATE drinks 
SET idGlass=glasses.idGlass
FROM drinks,glasses,inserted i
WHERE i.strGlass=glasses.strGlass AND i.idDrink=drinks.idDrink

UPDATE drinks 
SET idIngredient1=ingredients.idIngredient
FROM drinks,ingredients,inserted i
WHERE i.strIngredient1=ingredients.strIngredient AND i.idDrink=drinks.idDrink

INSERT INTO ingredients 
SELECT DISTINCT strIngredient1 FROM stagging WHERE strIngredient1 NOT IN (SELECT strIngredient FROM ingredients) 

UPDATE drinks 
SET idIngredient1=ingredients.idIngredient
FROM drinks,ingredients,inserted i
WHERE i.strIngredient1=ingredients.strIngredient AND i.idDrink=drinks.idDrink

INSERT INTO ingredients 
SELECT DISTINCT strIngredient2 FROM stagging WHERE strIngredient2 NOT IN (SELECT strIngredient FROM ingredients)  

UPDATE drinks 
SET idIngredient2=ingredients.idIngredient
FROM drinks,ingredients,inserted i
WHERE i.strIngredient2=ingredients.strIngredient AND i.idDrink=drinks.idDrink

INSERT INTO ingredients 
SELECT DISTINCT strIngredient3 FROM stagging WHERE strIngredient3 NOT IN (SELECT strIngredient FROM ingredients)  
UPDATE drinks 
SET idIngredient3=ingredients.idIngredient
FROM drinks,ingredients,inserted i
WHERE i.strIngredient3=ingredients.strIngredient AND i.idDrink=drinks.idDrink

INSERT INTO ingredients 
SELECT DISTINCT strIngredient4 FROM stagging WHERE strIngredient4 NOT IN (SELECT strIngredient FROM ingredients)  

UPDATE drinks 
SET idIngredient4=ingredients.idIngredient
FROM drinks,ingredients,inserted i
WHERE i.strIngredient4=ingredients.strIngredient AND i.idDrink=drinks.idDrink

INSERT INTO ingredients 
SELECT DISTINCT strIngredient5 FROM stagging WHERE strIngredient5 NOT IN (SELECT strIngredient FROM ingredients)  

UPDATE drinks 
SET idIngredient5=ingredients.idIngredient
FROM drinks,ingredients,inserted i
WHERE i.strIngredient5=ingredients.strIngredient AND i.idDrink=drinks.idDrink

--Measure
INSERT INTO measures 
SELECT DISTINCT strMeasure1 FROM stagging WHERE strMeasure1 NOT IN (SELECT strMeasure FROM measures)  

UPDATE drinks 
SET idMeasureIngredient1=measures.idMeasure
FROM drinks,measures,inserted i
WHERE i.strMeasure1=measures.strMeasure AND i.idDrink=drinks.idDrink

INSERT INTO measures 
SELECT DISTINCT strMeasure2 FROM stagging WHERE strMeasure2 NOT IN (SELECT strMeasure FROM measures) 

UPDATE drinks 
SET idMeasureIngredient2=measures.idMeasure
FROM drinks,measures,inserted i
WHERE i.strMeasure2=measures.strMeasure AND i.idDrink=drinks.idDrink

INSERT INTO measures 
SELECT DISTINCT strMeasure3 FROM stagging WHERE strMeasure3 NOT IN (SELECT strMeasure FROM measures) 

UPDATE drinks 
SET idMeasureIngredient3=measures.idMeasure
FROM drinks,measures,inserted i
WHERE i.strMeasure3=measures.strMeasure AND i.idDrink=drinks.idDrink

INSERT INTO measures 
SELECT DISTINCT strMeasure4 FROM stagging WHERE strMeasure4 NOT IN (SELECT strMeasure FROM measures) 

UPDATE drinks 
SET idMeasureIngredient4=measures.idMeasure
FROM drinks,measures,inserted i
WHERE i.strMeasure4=measures.strMeasure AND i.idDrink=drinks.idDrink

INSERT INTO measures 
SELECT DISTINCT strMeasure5 FROM stagging WHERE strMeasure5 NOT IN (SELECT strMeasure FROM measures) 

UPDATE drinks 
SET idMeasureIngredient5=measures.idMeasure
FROM drinks,measures,inserted i
WHERE i.strMeasure5=measures.strMeasure AND i.idDrink=drinks.idDrink

GO

--View to join all tables for html report
create VIEW vwDrinks
AS
SELECT d.idDrink,d.strDrink,d.strInstructions,
i1.strIngredient AS strIngredient1,
i2.strIngredient AS strIngredient2,
i3.strIngredient AS strIngredient3,
i4.strIngredient AS strIngredient4,
i5.strIngredient AS strIngredient5,
m1.strMeasure AS strMeasure1,
m2.strMeasure AS strMeasure2,
m3.strMeasure AS strMeasure3,
m4.strMeasure AS strMeasure4,
m5.strMeasure AS strMeasure5,
strGlass
FROM drinks d
LEFT JOIN glasses g ON d.idGlass=g.idGlass
LEFT JOIN ingredients i1 ON i1.idIngredient=d.idIngredient1 
LEFT JOIN ingredients i2 ON i2.idIngredient=d.idIngredient2
LEFT JOIN ingredients i3 ON i3.idIngredient=d.idIngredient3
LEFT JOIN ingredients i4 ON i4.idIngredient=d.idIngredient4
LEFT JOIN ingredients i5 ON i5.idIngredient=d.idIngredient5
LEFT JOIN measures m1 ON m1.idMeasure=d.idMeasureIngredient1
LEFT JOIN measures m2 ON m2.idMeasure=d.idMeasureIngredient2
LEFT JOIN measures m3 ON m3.idMeasure=d.idMeasureIngredient3
LEFT JOIN measures m4 ON m4.idMeasure=d.idMeasureIngredient4
LEFT JOIN measures m5 ON m5.idMeasure=d.idMeasureIngredient5
GO
