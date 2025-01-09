# simple_tracking

## config

- copy `config.sample` to `config` and edit file

## setup DB

- Create user and database
  - Enable postgis
- Execute the create_db.sql

```bash
psql -c "CREATE USER simple_tracking LOGIN;"
psql -c "CREATE DATABASE simple_tracking OWNER = simple_tracking;"

export PGDATABASE=simple_tracking
psql -c "CREATE EXTENSION postgis;"
psql -f create_db.sql
```

## prepare app

- Download css and javascript
- Update and compile translations

```bash
cd webapp
./download_js.sh
./translate.sh
```

## start app

### start using flask
- this is for development
```bash
cd webapp
./start.sh
```

- Call webbrowser: http://127.0.0.1:5000

### In Production using docker
- Build image:
```bash
docker build --tag simple_tracking .
```
- Test image using the config
```bash
docker run --rm --name tracking_test -ti --env-file=config -p5000:5000 simple_tracking
```
- webbrowser: http://127.0.0.1:5000
- Deploy docker image with management you like or run it in deamon mode
