#! /bin/bash

###############################################################
# 작성자 : 유민상
# 작성일 : 2024-01-04
# 수정자 :
# 수정일 : 
# 설명   : 모니터링 대상 서버 추가시 수행.
###############################################################

# MariaDB 비밀번호 입력
echo "==============================================================="
echo "MariaDB 비밀번호 입력"
stty -echo
read pw
stty echo
echo "==============================================================="

RESULT=$(mariadb -u root -p$pw -e "select 0 as 'result'")

if [ "${RESULT:6:7}" -eq 0 ]
then
	echo "접속가능"
else
	echo "비밀번호가 틀렸습니다"
	exit
fi

# 모니터링 설정
while ( true )
do

echo "==============================================================="
echo '
1.DB_생성
2.Table_생성
3.작업끝내기
'
echo "==============================================================="

echo -n "번호 선택 :"
read no

case $no in 
	"1" )
		echo "==============================================================="
		echo "모니터링대상 DB명(해당 명칭으로 DB생성)"
		read db_name
		mariadb -u root -p$pw -e "create database $db_name"
		mariadb -u root -p$pw -e "show databases"
		echo "===============================================================" ;;
	"2" )
		echo "==============================================================="
		echo "테이블 생성 중...."
		mariadb -u root -p$pw $db_name -e "create table TBL_CPU_CHECK(ILJA datetime not null comment '일자', CPU_USAGE int not null comment 'CPU_사용률') comment 'CPU_모니터링';"
		mariadb -u root -p$pw $db_name -e "create table TBL_MEMORY_CHECK(ILJA datetime not null comment '일자', MEMORY_USAGE int not null comment '메모리_사용률', MEMORY_CACHE_CHECK int not null comment '메모리_캐시사용률', TOTAL_MEMORY int not null comment '총_메모리', USED_MEMORY int not null comment '사용중인_메모리', FREE_MEMORY int not null comment '사용가능_메모리') comment 'MEMORY_모니터링';"
		mariadb -u root -p$pw $db_name -e "create table TBL_STORAGE_CHECK(ILJA datetime not null comment '일자', DRIVE_NAME char(1) null comment '드라이브_명', TOTAL_STORAGE_GB int null comment '총_용량', USED_STORAGE_GB int null comment '사용중인_용량', FREE_STORAGE int null comment '사용가능_용량') comment 'STORAGE_모니터링';"
		echo "테이블 생성완료"
		mariadb -u root -p$pw $db_name -e "show tables" 
		echo "===============================================================";;
	"3" )
		echo "==============================================================="
		echo "작업종료"
		echo "==============================================================="
		exit 0 ;;
esac

done
 
