FROM debian:buster

#------------------UDPATES
RUN apt-get update && apt dist-upgrade -y

#------------------NGINX
COPY ./srcs/nginx/nginx.conf /etc/nginx/sites-available/nginx.conf
RUN apt-get install nginx -y
RUN ln -s /etc/nginx/sites-available/nginx.conf /etc/nginx/sites-enabled/;


#getting rights
RUN chown -R www-data:www-data /etc/nginx/sites-available/
RUN chmod -R 755 /etc/nginx/sites-available/

#------------------SSL
COPY ./srcs/nginx/mkcert-init .
RUN mkdir mkcert
RUN mv mkcert-init mkcert
WORKDIR mkcert
RUN chmod +x mkcert-init
RUN ./mkcert-init -install
RUN ./mkcert-init localhost
WORKDIR ..

#------------------MYSQL
RUN apt-get install -y mariadb-server

#------------------WORDPRESS
#copying files
COPY srcs/wordpress/wordpress_database.sql /root/wordpress_database.sql
COPY srcs/wordpress/wordpress_tables.sql /root/wordpress_tables.sql
COPY srcs/wordpress/source_code /var/www/html/wordpress
COPY ./srcs/wordpress/wp-config.php /var/www/html/wordpress

#installing required packages
RUN apt-get install -y php-fpm php-mysql php-mbstring

#database creation
RUN /etc/init.d/mysql start && mysql < /root/wordpress_database.sql
RUN rm -f /root/wordpress_database.sql

#content uploading
RUN /etc/init.d/mysql start && mysql < /root/wordpress_tables.sql
RUN rm -f /root/wordpress_tables.sql

#getting rights
RUN chown -R www-data:www-data /var/www/html/wordpress/
RUN chmod -R 755 /var/www/html/wordpress/

#------------------PHPMYADMIN
COPY ./srcs/phpmyadmin/config.inc.php .
COPY srcs/phpmyadmin/phpmyadmin_database.sql /root/phpmyadmin_database.sql

#creating tmp file to rm php warning
RUN mkdir -p /var/lib/phpmyadmin/tmp
RUN chown -R www-data:www-data /var/lib/phpmyadmin

#uploading php files
RUN apt-get install -y wget
RUN wget https://files.phpmyadmin.net/phpMyAdmin/4.9.0.1/phpMyAdmin-4.9.0.1-english.tar.gz
RUN tar -xvf phpMyAdmin-4.9.0.1-english.tar.gz
RUN mv phpMyAdmin-4.9.0.1-english /var/www/html/phpmyadmin
RUN mv config.inc.php /var/www/html/phpmyadmin
RUN rm phpMyAdmin-4.9.0.1-english.tar.gz

#create php database
RUN /etc/init.d/mysql start && mysql < /root/phpmyadmin_database.sql
RUN rm -f /root/phpmyadmin_database.sql

#-------------------------LAUNCH
COPY srcs/launch.sh .
CMD sh launch.sh && tail -f /dev/null
