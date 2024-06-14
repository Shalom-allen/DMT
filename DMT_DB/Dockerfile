# 마리아디비 이미지 설치
FROM mariadb:lts

# 서버 시간 설정
ENV TZ=Asia/Seoul

# 패키지 업데이트 및 설치
RUN apt-get update && apt-get upgrade -y \
	&& apt-get install -y init systemd \
	&& apt-get install -y vim curl \
	&& apt-get install -y net-tools iputils-ping \
	&& apt-get install -y cron

# 디렉토리 생성
#RUN mkdir -p /maria/backup && mkdir -p /maria

# 볼륭연결
#VOLUME ["/mnt/d/04.study/Container/maria/share"]
