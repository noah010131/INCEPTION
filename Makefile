all : up

up : 
	# 데이터 폴더가 없으면 생성 (권한 에러 방지)
	@mkdir -p /home/chanypar/data/mariadb
	@mkdir -p /home/chanypar/data/wordpress
	docker compose -f ./srcs/docker-compose.yml up -d --build

down : 
	docker compose -f ./srcs/docker-compose.yml down

# 평가 시 "싹 다 지워봐라"라고 할 때 필요한 규칙
fclean : down
	docker system prune -a --force
	sudo rm -rf /home/chanypar/data/mariadb/*
	sudo rm -rf /home/chanypar/data/wordpress/*

re : fclean all

stop : 
	docker compose -f ./srcs/docker-compose.yml stop

start : 
	docker compose -f ./srcs/docker-compose.yml start

status : 
	docker ps

.PHONY : all up down stop start status fclean re