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

-- 1. root 계정 보안 설정 (localhost 접속만 허용 및 비번 설정)
ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';

-- 2. 원격 root 접속 가능성 완전 차단 (Host가 localhost가 아닌 root 삭제)
DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');

-- 3. 익명 사용자(Anonymous User) 제거 (보안 필수)
DELETE FROM mysql.user WHERE User='';

-- 4. 테스트 데이터베이스 제거
DROP DATABASE IF EXISTS test;
DELETE FROM mysql.db WHERE Db='test' OR Db='test\_%';

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