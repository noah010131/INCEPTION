all : up

up : 
	@mkdir -p /home/chanypar/data/mariadb
	@mkdir -p /home/chanypar/data/wordpress
	docker compose -f ./srcs/docker-compose.yml up -d --build

down : 
	docker compose -f ./srcs/docker-compose.yml down

fclean : down
	docker compose -f ./srcs/docker-compose.yml down --rmi all --volumes
	docker system prune -a --force
	sudo rm -rf /home/chanypar/data/mariadb/*
	sudo rm -rf /home/chanypar/data/wordpress/*

clean :
	docker compose -f ./srcs/docker-compose.yml down

re : fclean all

stop : 
	docker compose -f ./srcs/docker-compose.yml stop

start : 
	docker compose -f ./srcs/docker-compose.yml start

status : 
	docker ps

.PHONY : all up down stop start status fclean clean re