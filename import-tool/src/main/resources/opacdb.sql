

CREATE ALIAS IF NOT EXISTS FT_INIT FOR "org.h2.fulltext.FullText.init";

CALL FT_INIT();


-- --------------------------------------------------
--	TEMP tables
-- --------------------------------------------------

-- DROP TABLE IF EXISTS TEMP_AUTORE;

CREATE TABLE TEMP_AUTORE
(
  ID		IDENTITY PRIMARY KEY NOT NULL,
  OCCORENZE	INT DEFAULT 0 NOT NULL,
  NOME		VARCHAR(300) NOT NULL,
  NOMENORM	VARCHAR(200) NOT NULL
);

-- DROP TABLE IF EXISTS TEMP_DESCRITTORE;

CREATE TABLE TEMP_DESCRITTORE
(
  ID		IDENTITY PRIMARY KEY NOT NULL,
  OCCORENZE	INT DEFAULT 0 NOT NULL,
  NOME		VARCHAR(200) NOT NULL,
  NOMENORM	VARCHAR(200) NOT NULL
);

-- DROP TABLE IF EXISTS TEMP_SOGGETTO;

CREATE TABLE TEMP_SOGGETTO
(
  ID		IDENTITY PRIMARY KEY NOT NULL,
  OCCORENZE	INT DEFAULT 0 NOT NULL,
  NOME		VARCHAR(300) NOT NULL,
  NOMENORM	VARCHAR(200) NOT NULL
);

-- DROP TABLE IF EXISTS TEMP_TITOLO;

CREATE TABLE TEMP_TITOLO
(
  ID		IDENTITY PRIMARY KEY NOT NULL,
  OCCORENZE	INT DEFAULT 0 NOT NULL,
  NOME		VARCHAR(1200) NOT NULL,
  NOMENORM	VARCHAR(200) NOT NULL
);


-- DROP TABLE IF EXISTS TEMP_DEWEY;

CREATE TABLE TEMP_DEWEY
(
  ID		IDENTITY PRIMARY KEY NOT NULL,
  OCCORENZE	INT DEFAULT 0 NOT NULL,
  NOME		VARCHAR(350) NOT NULL,
  NOMENORM	VARCHAR(350) NOT NULL
);



-- --------------------------------------------------
--	Table structure for table  AUTORE
-- --------------------------------------------------

-- DROP TABLE IF EXISTS AUTORE;

CREATE TABLE AUTORE
(
  ID		IDENTITY PRIMARY KEY NOT NULL,
  OCCORENZE	INT DEFAULT 0 NOT NULL,
  NOME		VARCHAR(300) NOT NULL,
  NOMENORM	VARCHAR(200) NOT NULL
);


-- CALL FT_CREATE_INDEX('PUBLIC', 'AUTORE', 'NOMENORM');
-- CALL FT_DROP_INDEX('PUBLIC', 'AUTORE');


-- --------------------------------------------------
--	Table structure for table  DESCRITTORE
-- --------------------------------------------------

-- DROP TABLE IF EXISTS DESCRITTORE;

CREATE TABLE DESCRITTORE
(
  ID		IDENTITY PRIMARY KEY NOT NULL,
  OCCORENZE	INT DEFAULT 0 NOT NULL,
  NOME		VARCHAR(200) NOT NULL,
  NOMENORM	VARCHAR(200) NOT NULL
);


-- CALL FT_CREATE_INDEX('PUBLIC', 'DESCRITTORE', 'NOMENORM');
-- CALL FT_DROP_INDEX('PUBLIC', 'DESCRITTORE');



-- --------------------------------------------------
--	Table structure for table  SOGGETTO
-- --------------------------------------------------

-- DROP TABLE IF EXISTS SOGGETTO;


CREATE TABLE SOGGETTO
(
  ID		IDENTITY PRIMARY KEY NOT NULL,
  OCCORENZE	INT DEFAULT 0 NOT NULL,
  NOME		VARCHAR(300) NOT NULL,
  NOMENORM	VARCHAR(200) NOT NULL
);


CALL FT_CREATE_INDEX('PUBLIC', 'SOGGETTO', 'NOMENORM');

-- CALL FT_DROP_INDEX('PUBLIC', 'SOGGETTO');


-- --------------------------------------------------
--	Table structure for table  TITOLO
-- --------------------------------------------------

-- DROP TABLE IF EXISTS TITOLO;

CREATE TABLE TITOLO
(
  ID		IDENTITY PRIMARY KEY NOT NULL,
  OCCORENZE	INT DEFAULT 0 NOT NULL,
  NOME		VARCHAR(1200) NOT NULL,
  NOMENORM	VARCHAR(200) NOT NULL
);

-- CALL FT_CREATE_INDEX('PUBLIC', 'TITOLO', 'NOMENORM');
-- CALL FT_DROP_INDEX('PUBLIC', 'TITOLO');


-- --------------------------------------------------
--	Table structure for table  DEWEY
-- --------------------------------------------------

-- DROP TABLE IF EXISTS DEWEY;

CREATE TABLE DEWEY
(
  ID		IDENTITY PRIMARY KEY NOT NULL,
  OCCORENZE	INT DEFAULT 0 NOT NULL,
  NOME		VARCHAR(300) NOT NULL,
  NOMENORM	VARCHAR(300) NOT NULL,
  FULLNORM	VARCHAR(350) NOT NULL,
  CDD		VARCHAR(30) NOT NULL,
  CDDNORM	VARCHAR(30) NOT NULL,
  COD3		VARCHAR(3) NOT NULL
);


-- CALL FT_CREATE_INDEX('PUBLIC', 'DEWEY', 'FULLNORM');
-- CALL FT_DROP_INDEX('PUBLIC', 'DEWEY');



-- --------------------------------------------------
--	Table structure for table  SEGNALAZIONE
-- --------------------------------------------------

-- DROP TABLE IF EXISTS SEGNALAZIONE;

CREATE TABLE SEGNALAZIONE
(
  ID		IDENTITY PRIMARY KEY NOT NULL,
  IDN		varchar(10) NOT NULL,
  TESTO		varchar(2000) NOT NULL,
  EMAIL		varchar(120) NOT NULL,
  IP		varchar(16) NOT NULL
);

