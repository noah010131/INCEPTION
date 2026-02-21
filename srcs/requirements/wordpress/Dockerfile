FROM debian:bullseye

# 1. 필수 패키지 설치 (PHP-FPM, MariaDB 클라이언트, curl 등)
RUN apt-get update && apt-get install -y \
    php7.4-fpm \
    php7.4-mysql \
    mariadb-client \
    curl \
    && rm -rf /var/lib/apt/lists/*

# 2. PHP-FPM 설정 변경 (Nginx와 통신하기 위해 소켓 대신 9000 포트 개방)
RUN sed -i 's|listen = /run/php/php7.4-fpm.sock|listen = 9000|g' /etc/php/7.4/fpm/pool.d/www.conf

# 3. wp-cli 설치 (워드프레스 명령줄 인터페이스 - 자동 설치용)
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x wp-cli.phar \
    && mv wp-cli.phar /usr/local/bin/wp

# 4. PHP-FPM 실행을 위한 디렉토리 생성
RUN mkdir -p /run/php

# 5. 소스 코드가 들어갈 작업 디렉토리 설정
WORKDIR /var/www/html

# 6. 설정 스크립트 복사 및 실행 권한 부여
COPY tools/setup.sh /usr/local/bin/setup.sh
RUN chmod +x /usr/local/bin/setup.sh

# 7. 컨테이너 시작 시 실행될 명령어
ENTRYPOINT ["/usr/local/bin/setup.sh"]