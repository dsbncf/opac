

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


