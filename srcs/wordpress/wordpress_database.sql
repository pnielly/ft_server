CREATE DATABASE wordpress;
CREATE USER 'admin'@'localhost' IDENTIFIED BY 'admin';
GRANT ALL ON wordpress.* TO 'admin'@'localhost' ;
FLUSH PRIVILEGES;
