
-- --------------------------------------------------
--	Table structure for table  TEMP_SOGGETTO
-- --------------------------------------------------

-- DROP TABLE IF EXISTS TEMP_SOGGETTO;


CREATE TABLE TEMP_SOGGETTO
(
  ID		IDENTITY PRIMARY KEY NOT NULL,
  OCCORENZE	INT DEFAULT 0 NOT NULL,
  NOME		VARCHAR(300) NOT NULL,
  NOMENORM	VARCHAR(200) NOT NULL
);


