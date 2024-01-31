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
                mariadb -u root -p$pw $db_name -e "create table TBL_CPU_CHECK(ILJA datetime not null comment '일자', CPU_USAGE int not null comment 'CPU_사용률', CONSTRAINT PRIMARY KEY (ILJA desc)) comment 'CPU_모니터링';"
                mariadb -u root -p$pw $db_name -e "create table TBL_MEMORY_CHECK(ILJA datetime not null comment '일자', TOTAL_MEMORY int not null comment '총_메모리', USED_MEMORY int not null comment '사용중인_메모리', FREE_MEMORY int not null comment '사용가능_메모리', SEVER_MEMORY_USAGE int not null comment '메모리_사용률', DBMS_TOTAL_MEMORY int comment 'DBMS_허용된_메모리크기',DBMS_MEMORY_CACHE_CHECK int comment 'DBMS_메모리_캐시사용률', CONSTRAINT PRIMARY KEY (ILJA desc)) comment 'MEMORY_모니터링';"
                mariadb -u root -p$pw $db_name -e "create table TBL_STORAGE_CHECK(ILJA datetime not null comment '일자', DRIVE_NAME char(1) not null comment '드라이브_명', TOTAL_STORAGE_GB int null comment '총_용량', USED_STORAGE_GB int null comment '사용중인_용량', FREE_STORAGE_GB int null comment '사용가능_용량',SERVER_STORAGE_USAGE int not null comment '용량_사용률', CONSTRAINT PRIMARY KEY (ILJA desc,DRIVE_NAME)) comment 'STORAGE_모니터링';"
		mariadb -u root -p$pw $db_name -e "create table TBL_CONNECTION(ILJA datetime not null comment '일자', MAX_CONNECTION int not null comment 'MAX_CONNECTION', NOW_CONNECTION int not null comment '현재접속자', DBMS_MAX_USED_CONNECTION int not null comment '최대동접자수', CONSTRAINT PRIMARY KEY (ILJA desc)) comment '접속자확인' ;"
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
