#!/bin/bash
set -e

# MariaDB 대기 로직 (기존 유지)
until mysqladmin ping -h"mariadb" --silent; do
    echo "Waiting for MariaDB to be ready..."
    sleep 2
done

# WordPress가 설치될 경로로 이동
cd /var/www/html

# 1. 파일이 하나도 없다면 다운로드
if [ ! -f index.php ]; then
    echo "Downloading WordPress..."
    wp core download --allow-root
fi

# 2. wp-config.php가 없다면 생성
if [ ! -f wp-config.php ]; then
    echo "Creating wp-config.php..."
    wp config create --allow-root \
        --dbname=$MYSQL_DATABASE \
        --dbuser=$MYSQL_USER \
        --dbpass=$MYSQL_PASSWORD \
        --dbhost=mariadb:3306
fi

# 3. 데이터베이스에 테이블이 없다면(설치가 안 됐다면) 설치 진행
if ! wp core is-installed --allow-root; then
    echo "Installing WordPress core..."
    wp core install --allow-root \
        --url=$DOMAIN_NAME \
        --title=$WP_TITLE \
        --admin_user=$WP_ADMIN_USER \
        --admin_password=$WP_ADMIN_PASSWORD \
        --admin_email=$WP_ADMIN_EMAIL

    echo "Creating extra user..."
    wp user create $WP_USER $WP_EMAIL \
        --user_pass=$WP_PASSWORD \
        --role=author \
        --allow-root
fi

echo "WordPress is ready!"
exec /usr/sbin/php-fpm7.4 -F