FROM debian:bullseye

# 1. 필수 패키지 설치 (nginx, openssl)
RUN apt-get update && apt-get install -y \
    nginx \
    openssl \
    && rm -rf /var/lib/apt/lists/*

# 2. SSL 인증서 생성 및 보관 디렉토리
RUN mkdir -p /etc/nginx/ssl

# 3. 자기 서명 인증서 생성 (Self-signed Certificate)
# -subj 옵션의 CN 부분은 본인의 42 로그인 아이디.42.fr로 맞춰주세요.
RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /etc/nginx/ssl/chanypar.key \
    -out /etc/nginx/ssl/chanypar.crt \
    -subj "/C=FR/ST=Paris/L=Paris/O=42/OU=42Paris/CN=chanypar.42.fr"

RUN apt-get update && apt-get install -y nginx openssl iputils-ping && rm -rf /var/lib/apt/lists/*
# ... 나머지 설정

# 4. 설정 파일 복사 (우리가 만들 nginx.conf를 컨테이너 안으로)
COPY conf/nginx.conf /etc/nginx/conf.d/default.conf

# 5. Nginx 실행 (포그라운드 모드)
# daemon off 설정이 있어야 컨테이너가 즉시 종료되지 않습니다.
ENTRYPOINT ["nginx", "-g", "daemon off;"]