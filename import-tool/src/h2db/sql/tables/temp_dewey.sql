

-- --------------------------------------------------
--	Table structure for table  TEMP_DEWEY
-- --------------------------------------------------

-- DROP TABLE IF EXISTS TEMP_DEWEY;

CREATE TABLE TEMP_DEWEY
(
  ID		IDENTITY PRIMARY KEY NOT NULL,
  OCCORENZE	INT DEFAULT 0 NOT NULL,
  NOME		VARCHAR(350) NOT NULL,
  NOMENORM	VARCHAR(350) NOT NULL
);

