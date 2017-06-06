

-- --------------------------------------------------
--	Table structure for table  TEMP_AUTORE
-- --------------------------------------------------

-- DROP TABLE IF EXISTS TEMP_AUTORE;

CREATE TABLE TEMP_AUTORE
(
  ID		IDENTITY PRIMARY KEY NOT NULL,
  OCCORENZE	INT DEFAULT 0 NOT NULL,
  NOME		VARCHAR(300) NOT NULL,
  NOMENORM	VARCHAR(200) NOT NULL
);

