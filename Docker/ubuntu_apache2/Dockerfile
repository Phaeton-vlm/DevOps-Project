FROM ubuntu:20.04


ENV TZ=Europe/Minsk

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone; \
apt-get update && apt-get install -y apache2; \
mkdir -p /opt/apache2/www.test.com && mkdir -p /opt/apache2/logs

COPY ./configs/apache2.conf /etc/apache2/
COPY ./configs/test.com.conf /etc/apache2/sites-available/

RUN a2ensite test.com.conf && a2dissite 000-default.conf

EXPOSE 80

CMD ["apachectl", "-D", "FOREGROUND"]