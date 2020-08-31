#! /bin/bash

#LAUNCHING
/etc/init.d/nginx start && \
        /etc/init.d/mysql start && \
        /etc/init.d/php7.3-fpm start && \
	echo "\n\e[1;32m Container running \e[0m\n"
