

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

CALL FTL_CREATE_INDEX('PUBLIC', 'DESCRITTORE', 'NOMENORM');
-- CALL FTL_DROP_INDEX('PUBLIC', 'DESCRITTORE');

-- CALL FT_CREATE_INDEX('PUBLIC', 'DESCRITTORE', 'NOMENORM');
-- CALL FT_DROP_INDEX('PUBLIC', 'DESCRITTORE');
