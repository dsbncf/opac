
-- --------------------------------------------------
--	Table structure for table  TEMP_DESCRITTORE
-- --------------------------------------------------

-- DROP TABLE IF EXISTS TEMP_DESCRITTORE;

CREATE TABLE TEMP_DESCRITTORE
(
  ID		IDENTITY PRIMARY KEY NOT NULL,
  OCCORENZE	INT DEFAULT 0 NOT NULL,
  NOME		VARCHAR(200) NOT NULL,
  NOMENORM	VARCHAR(200) NOT NULL
);


