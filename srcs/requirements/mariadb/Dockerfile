FROM debian:bullseye

RUN apt update && apt install -y mariadb-server \
    && mkdir -p /var/run/mysqld \
    && chown -R mysql:mysql /var/run/mysqld

COPY tools/init_db.sh /init_db.sh
COPY tools/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf
RUN chmod +x /init_db.sh

EXPOSE 3306

ENTRYPOINT ["/init_db.sh"]