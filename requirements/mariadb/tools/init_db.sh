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
USE mysql;
FLUSH PRIVILEGES;
-- root 인증 방식을 비밀번호 기반으로 고정
ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
-- 일반 유저 생성 및 권한 부여
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

# 반드시 외부 접속 허용 옵션 추가
exec mysqld_safe --bind-address=0.0.0.0