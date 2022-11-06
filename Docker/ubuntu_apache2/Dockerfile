FROM ubuntu:20.04


ENV TZ=Europe/Minsk

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone; \
apt-get update && apt-get install -y apache2; \
mkdir -p /opt/apache2/www.test.com /opt/apache2/logs /opt/cert; \
chown -R www-data:www-data /opt/cert; \
a2enmod ssl

COPY ./cert /opt/cert/
COPY ./configs/apache2.conf /etc/apache2/
COPY ./configs/test.com.conf /etc/apache2/sites-available/

RUN a2ensite test.com.conf && a2dissite 000-default.conf

EXPOSE 80
EXPOSE 443

CMD ["apachectl", "-D", "FOREGROUND"]