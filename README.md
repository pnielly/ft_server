To build the image :

docker build -t pn .

To run the container :

docker run -p 80:80 -p 443:443 pn

To disable the autoindex, go to srcs/nginx/nginx.conf and comment out the "autoindex on;" line.
