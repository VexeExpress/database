FROM postgres:16-alpine

# Install additional tools (e.g., pg_ctl) using apk
RUN apk update && \
    apk add --no-cache postgresql-client go graphviz openjdk8

# Documentation schemaspy
WORKDIR /app/schemaspy
COPY schemaspy/postgresql-42.7.3.jar schemaspy/schemaspy-6.2.4.jar ./

# Copy SQL files for setup database 
COPY src /docker-entrypoint-initdb.d/src/
COPY setup-database.sql /docker-entrypoint-initdb.d/
