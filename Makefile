EXTENSION = pg_headerkit
DATA = pg_headerkit--1.0.sql
 
PG_CONFIG = pg_config
PGXS := $(shell $(PG_CONFIG) --pgxs)
include $(PGXS)