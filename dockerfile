FROM postgres
COPY scripts/* /docker-entrypoint-initdb.d/
COPY sql/* /sql/




    
