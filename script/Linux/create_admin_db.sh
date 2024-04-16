#! /bin/bash

###############################################################
# 작성자: 유민상
# 작성일: 2024-04-16
# 수정자:
# 수정일:
# 설명	: 어드민 관리 DB & Table  생성.
###############################################################

# MariaDB 비밀번호 입력
echo "======================================================================"
echo "MariaDB 비밀번호 입력"
stty -echo
read pw
stty echo
echo "======================================================================"

RESULT=$(maraidb -u root -p$pw -e "select 0 as 'result'")

if [ "${RESULT:6:7}" -eq 0 ]; then
	echo "접속가능"
else
	echo "비밀번호가 틀렸습니다."
	exit
fi

# MariaDB DB생성
echo "======================================================================"
echo "STM DB 생성중..."
mariadb -u root -p$pw -e "create database STM"
mariadb -u root -p$pw -e "show databases"
echo "======================================================================"

# Table 생성
echo "======================================================================"
mariadb -u root -p$pw -e "show tables"
mariadb -u root -p$pw STM -e "CREATE TABLE ADM_USER (CD_ILJA DATETIME NOT NULL COMMENT '일자', CD_USERID VARCHAR(32) NOT NULL COMMENT '유저아이디', NM_PASSWD VARCHAR(20) NOT NULL COMMENT '비밀번호', NO_XPASS TINYINT UNSIGNED NOT NULL COMMENT '비밀번호틀린횟수', NM_ROLE VARCHAR(10) NOT NULL COMMENT	'권한명', NM_ROLE_DETAIL VARCHAR(500) NOT NULL COMMENT '권한_상세내용', NM_IP_1 VARCHAR(15) COMMENT '아이피1', NM_IP_2 VARCHAR(15) COMMENT '아이피2', DS_USE ENUM('Y','N') NOT NULL COMMENT '사용구분', SD_UPDATE DATETIME COMMENT '업데이트일자', CONSTRAINT PRIMARY KEY (CD_ILJA desc, CD_USERID ASC)) COMMENT 'STM_계정리스트';"
mariadb -u root -p$pw STM -e "CREATE TABLE ADM_USER_LOG (CD_ILJA DATETIME NOT NULL COMMENT '일자', CD_USERID	VARCHAR(32) NOT NULL COMMENT '유저아이디', NM_DETAIL	VARCHAR(400) COMMENT '상세내역', NM_IP VARCHAR(15) COMMENT '접속IP', CONSTRAINT PRIMARY KEY (CD_ILJA desc)) COMMENT 'STM_계정로그';"
mariadb -u root -p$pw -e "show tables"
echo "======================================================================"
