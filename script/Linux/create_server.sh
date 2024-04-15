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

# 테이블구분자
echo "==============================================================="
echo "Table 구분자입력(DB:1, WEB:2, ADMIN:3)"
read DT
echo "==============================================================="

if [ "$DT" -eq 1 ]; then
	echo "DB 테이블 생성 작업"
	DT="DMT"
elif [ "$DT" -eq 2 ]; then
	echo "WEB 테이블 생성 작업"
	DT="WMT"
elif [ "$DT" -eq 3 ]; then
	echo "ADMIN 테이블 생성 작업"
	DT="ADM"
else
	echo "없는 구분자입니다. 작업 확인요망"
	exit
fi

echo $DT
# 모니터링 설정
while ( true )
do

echo "==============================================================="
echo '
1.모니터링대상 전체추가(DB생성, Table생성)
2.대상 DB에 Table만 생성
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
		echo "==============================================================="
                echo "테이블 생성 중...."
                mariadb -u root -p$pw $db_name -e "create table ${DT}_CPU_CHECK(CD_ILJA datetime not null comment '일자', NO_CPU_USAGE int not null comment 'CPU_사용률', CONSTRAINT PRIMARY KEY (CD_ILJA desc)) comment 'CPU_모니터링';"
                mariadb -u root -p$pw $db_name -e "create table ${DT}_MEMORY_CHECK(CD_ILJA datetime not null comment '일자', NO_TOTAL_MEMORY int not null comment '총_메모리', NO_USED_MEMORY int not null comment '사용중인_메모리', NO_FREE_MEMORY int not null comment '사용가능_메모리', NO_SEVER_MEMORY_USAGE int not null comment '메모리_사용률', NO_DBMS_TOTAL_MEMORY int comment 'DBMS_허용된_메모리크기', NO_DBMS_MEMORY_CACHE_CHECK int comment 'DBMS_메모리_캐시사용률', CONSTRAINT PRIMARY KEY (CD_ILJA desc)) comment 'MEMORY_모니터링';"
                mariadb -u root -p$pw $db_name -e "create table ${DT}_STORAGE_CHECK(CD_ILJA datetime not null comment '일자', DS_DRIVE_NAME char(1) not null comment '드라이브_명', NO_TOTAL_STORAGE_GB int null comment '총_용량', NO_USED_STORAGE_GB int null comment '사용중인_용량', NO_FREE_STORAGE_GB int null comment '사용가능_용량',NO_SERVER_STORAGE_USAGE int not null comment '용량_사용률', CONSTRAINT PRIMARY KEY (CD_ILJA desc,DS_DRIVE_NAME)) comment 'STORAGE_모니터링';"
		mariadb -u root -p$pw $db_name -e "create table ${DT}_CONNECTION(CD_ILJA datetime not null comment '일자', NO_MAX_CONNECTION int not null comment 'MAX_CONNECTION', NO_NOW_CONNECTION int not null comment '현재접속자', NO_DBMS_MAX_USED_CONNECTION int not null comment '최대동접자수', CONSTRAINT PRIMARY KEY (CD_ILJA desc)) comment '접속자확인' ;"
                echo "테이블 생성완료"
                mariadb -u root -p$pw $db_name -e "show tables"
                echo "===============================================================";;
	"2" )
                echo "==============================================================="
		echo "테이블 생성 대상 DB 명"
		mariadb -u root -p$pw -e "show databases"
		read db_name
		echo "==============================================================="
                echo "테이블 생성 중...."
                mariadb -u root -p$pw $db_name -e "create table ${DT}_CPU_CHECK(CD_ILJA datetime not null comment '일자', NO_CPU_USAGE int not null comment 'CPU_사용률', CONSTRAINT PRIMARY KEY (CD_ILJA desc)) comment 'CPU_모니터링';"
		mariadb -u root -p$pw $db_name -e "create table ${DT}_MEMORY_CHECK(CD_ILJA datetime not null comment '일자', NO_TOTAL_MEMORY int not null comment '총_메모리', NO_USED_MEMORY int not null comment '사용중인_메모리', NO_FREE_MEMORY int not null comment '사용가능_메모리', NO_SEVER_MEMORY_USAGE int not null comment '메모리_사용률', NO_DBMS_TOTAL_MEMORY int comment 'DBMS_허용된_메모리크기', NO_DBMS_MEMORY_CACHE_CHECK int comment 'DBMS_메모리_캐시사용률', CONSTRAINT PRIMARY KEY (CD_ILJA desc)) comment 'MEMORY_모니터링';"
                mariadb -u root -p$pw $db_name -e "create table ${DT}_STORAGE_CHECK(CD_ILJA datetime not null comment '일자', DS_DRIVE_NAME char(1) not null comment '드라이브_명', NO_TOTAL_STORAGE_GB int null comment '총_용량', NO_USED_STORAGE_GB int null comment '사용중인_용량', NO_FREE_STORAGE_GB int null comment '사용가능_용량',NO_SERVER_STORAGE_USAGE int not null comment '용량_사용률', CONSTRAINT PRIMARY KEY (CD_ILJA desc,DS_DRIVE_NAME)) comment 'STORAGE_모니터링';"
                mariadb -u root -p$pw $db_name -e "create table ${DT}_CONNECTION(CD_ILJA datetime not null comment '일자', NO_MAX_CONNECTION int not null comment 'MAX_CONNECTION', NO_NOW_CONNECTION int not null comment '현재접속자', NO_DBMS_MAX_USED_CONNECTION int not null comment '최대동접자수', CONSTRAINT PRIMARY KEY (CD_ILJA desc)) comment '접속자확인' ;"
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
