

-- initialize the Native Fulltext Search implementation
-- CREATE ALIAS IF NOT EXISTS FT_INIT FOR "org.h2.fulltext.FullText.init";
-- CALL FT_INIT();

-- initialize the Lucene's Fulltext Search implementation
CREATE ALIAS IF NOT EXISTS FTL_INIT FOR "org.h2.fulltext.FullTextLucene.init";
CALL FTL_INIT();

/*
CREATE DATABASE opac2
  DEFAULT CHARACTER SET utf8
  DEFAULT COLLATE utf8_general_ci;
*/
