#use this file for external DB
docker run --add-host=docker_host:db_ip_addr_host -it -v /docker/web/local_www_folder:/var/www/web -p 100:80 -d php7
