#!/bin/bash
set -e

# /run/mysqld 폴더가 없으면 생성 (Dockerfile에 있지만 한번 더 확인)
mkdir -p /run/mysqld
chown -R mysql:mysql /run/mysqld

if [ ! -d "/var/lib/mysql/${MYSQL_DATABASE}" ]; then
    echo "Initializing MariaDB database..."
    
    mysql_install_db --user=mysql --datadir=/var/lib/mysql

    # 임시 파일 생성 (히어독 방식보다 안정적일 수 있음)
    tfile=`mktemp`
    if [ ! -f "$tfile" ]; then
        return 1
    fi

    cat << EOF > $tfile
-- tfile 내부 SQL 수정 제안
USE mysql;
FLUSH PRIVILEGES;

-- 1. root 계정 보안 설정
ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';

-- 2. 원격 root 접속 차단
DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');

-- 3. 익명 사용자 및 테스트 DB 제거
DELETE FROM mysql.user WHERE User='';
DROP DATABASE IF EXISTS test;

-- 4. ★필수★ 과제용 일반 유저 및 DB 생성 (이게 빠지면 502 에러 납니다)
CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE};
CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'%';

FLUSH PRIVILEGES;
EOF

    # 부트스트랩 실행
    mysqld --user=mysql --bootstrap < $tfile
    rm -f $tfile
    echo "MariaDB initialization completed."
fi

# AS-IS
# exec mysqld_safe --bind-address=0.0.0.0

exec mysqld --user=mysql --bind-address=0.0.0.0