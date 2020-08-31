pn=$(docker images | awk '{print $1}' | awk 'NR==2')

docker exec $(docker ps --filter ancestor=$pn -q) sed -i 's/autoindex on/autoindex off/' /etc/nginx/sites-available/nginx.conf
docker exec $(docker ps --filter ancestor=$pn -q) service nginx reload
