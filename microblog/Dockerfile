FROM python:3.10-alpine3.21

WORKDIR /microblog

COPY requirements.txt .

RUN apk update && \
  apk upgrade --no-cache && \
  pip install -r requirements.txt && \
  pip install gunicorn pymysql cryptography

COPY app app
COPY migrations migrations
COPY microblog.py config.py boot.sh ./

ENV FLASK_APP microblog.py
RUN flask translate compile

EXPOSE 5000

ENTRYPOINT ["./boot.sh"]
