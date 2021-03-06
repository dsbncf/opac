

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

CALL FTL_CREATE_INDEX('PUBLIC', 'SOGGETTO', 'NOMENORM');
-- CALL FTL_DROP_INDEX('PUBLIC', 'SOGGETTO');


-- CALL FT_CREATE_INDEX('PUBLIC', 'SOGGETTO', 'NOMENORM');
-- CALL FT_DROP_INDEX('PUBLIC', 'SOGGETTO');
