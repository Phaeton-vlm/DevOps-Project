FROM ubuntu:22.04

RUN apt-get update && apt-get install -y mysql-server;
COPY example.sql /
EXPOSE 3306

CMD ["mysqld","--user","mysql"]