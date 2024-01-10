#! /bin/bash

###############################################################
# 작성자 : 유민상
# 작성일 : 2024-01-08
# 수정자 :
# 수정일 :
# 설명   : 에이전트
###############################################################

# 비밀번호 불러오기
N_DB_PW=$(cat /script/db_info.conf | grep -a -1 MONITOR_MAIN_DB_PW | cut -d '=' -f2)
DB_PW="${N_DB_PW:1:10}"

# 서버 CPU 모니터링
CPU_VALUE=$(top -bn 1 | awk '{ print $9}' | awk 'NR>=8{print}' | awk '{total_size += $1;} END {print total_size;}')
CPU_CHECK_TIME=$(date "+%F %T")

# 서버 MEMORY 모니터링
MEMORY_TOTAL=$(free | sed -n 2p | awk '{print $2}')
MEMORY_USED=$(free | sed -n 2p | awk '{print $3}')
MEMORY_FREE=$(free | sed -n 2p | awk '{print $4}')
MEMORY_CHECK_TIME=$(date "+%F %T")

# CPU값 insert
mariadb -u root -p$DB_PW TEST01 -e "insert into TBL_CPU_CHECK values ($CPU_CHECK_TIME,$CPU_VALUE);"


