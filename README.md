# guacamole-initial-sql
Initial SQL Databases for Apache Guacamole

You can find the latest Apache Guacamole "InitDB.SQL" files here.

This saves generating them each time for your project. The output is under license from the Apache Foundation; I claim no owernship of the output SQL files. They are provided as a service to the Internet to ease Guacamole deployments.

The PowerShell script used to generate these files is included. You will need docker available.

## Quick Links

**MySQL**

https://raw.githubusercontent.com/daemonchild/guacamole-initial-sql/main/mysql/guacamole-initdb-mysql-latest.sql

**PostGres**

https://raw.githubusercontent.com/daemonchild/guacamole-initial-sql/main/postgres/guacamole-initdb-postgres-latest.sql

Assuming you set up your postgres container like this:

```
docker run -d --restart=always --name postgres -p 5432:5432 \
     -v postgres-data:/var/lib/postgresql/data \
     -e POSTGRES_DB="guacamole_db" -e POSTGRES_PASSWORD="blahblahblah" \
     postgres:latest
```

You could use it like this:

```
curl [Latest URL] | docker exec -i postgres psql --username=postgres guacamole_db
```

Note: I've used this technique to inject prebuilt data into Guacamole for automated deployments. For reference, this is the SQL needed to set up the remote Guacamole user.

```
CREATE USER guac_user WITH PASSWORD 'guac_password';
GRANT SELECT,INSERT,UPDATE,DELETE ON ALL TABLES IN SCHEMA public TO guac_user;
GRANT SELECT,USAGE ON ALL SEQUENCES IN SCHEMA public TO guac_user;
```

This can be updated using string replacement (search strings: guac_user and guac_password).