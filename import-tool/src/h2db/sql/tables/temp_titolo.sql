
-- --------------------------------------------------
--	Table structure for table  TEMP_TITOLO
-- --------------------------------------------------

-- DROP TABLE IF EXISTS TEMP_TITOLO;

CREATE TABLE TEMP_TITOLO
(
  ID		IDENTITY PRIMARY KEY NOT NULL,
  OCCORENZE	INT DEFAULT 0 NOT NULL,
  NOME		VARCHAR(1200) NOT NULL,
  NOMENORM	VARCHAR(200) NOT NULL
)

