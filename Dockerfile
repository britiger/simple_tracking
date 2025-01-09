FROM debian:bookworm-slim

WORKDIR /webapp

RUN apt update && apt install -y python3 python3-pip libpq-dev uwsgi uwsgi-plugin-python3

COPY webapp/requirements.txt requirements.txt
RUN pip3 install --break-system-packages -r requirements.txt

COPY webapp /webapp

EXPOSE 5000
# CMD [ "python3", "-m" , "flask", "run", "--host=0.0.0.0"]
CMD [ "uwsgi", "--ini", "app.ini" ]
