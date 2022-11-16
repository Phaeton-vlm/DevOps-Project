FROM phpmyadmin:5.2.0

COPY myapache2.conf /etc/apache2/sites-available/
RUN a2ensite myapache2.conf && a2dissite 000-default.conf