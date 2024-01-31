#! /bin/bash

###############################################################
# 작성자 : 유민상
# 작성일 : 2024-01-08
# 수정자 :
# 수정일 :
# 설명   : 에이전트
###############################################################

# 비밀번호 불러오기
N_DB_PW=$(cat /mnt/Linux/db_info.conf | grep -a -1 MONITOR_MAIN_DB_PW | cut -d '=' -f2)
DB_PW="${N_DB_PW:1:10}"

# 서버 CPU 모니터링
CPU_VALUE=$(top -bn 1 | awk '{ print $9}' | awk 'NR>=8{print}' | awk '{total_size += $1;} END {print total_size;}')
CPU_CHECK_TIME="'"$(date "+%F %T")"'"

# 서버 MEMORY 모니터링
MEMORY_TOTAL=$(free -g | sed -n 2p | awk '{print $2}')
MEMORY_USED=$(free -g | sed -n 2p | awk '{print $3}')
MEMORY_FREE=$(free -g | sed -n 2p | awk '{print $4}')
SERVER_MEMORY_USAGE=$(echo "scale=2; $MEMORY_USED/$MEMORY_TOTAL*100" | bc -l)
MEMORY_CHECK_TIME="'"$(date "+%F %T")"'"

# 서버 STORAGE 모니터링
STORAGE_TOTAL=$(df -h | sed -n 2p | awk '{print $2}' | sed 's/G.*$//')
STORAGE_USED=$(df -h | sed -n 2p | awk '{print $3}' | sed 's/G.*$//')
STORAGE_FREE=$(df -h | sed -n 2p | awk '{print $4}' | sed 's/G.*$//')
SERVER_STORAGE_USAGE=$(df -h | sed -n 2p | awk '{print $5}' | sed 's/%.*$//')
STORAGE_CHECK_TIME="'"$(date "+%F %T")"'"


# DBMS 커넥션 모니터링
MAX_CONNECTION=$(mariadb -uroot -p@minsang1 mysql -e "show variables like 'max_connections';" | awk '{print $2}' | sed -n 2p)
NOW_CONNECTION=$(mariadb -uroot -p@minsang1 mysql -e "show status like 'threads_connected';" | awk '{print $2}' | sed -n 2p)
MAX_USED_CONNECTION=$(mariadb -uroot -p@minsang1 mysql -e "show status like 'Max_used_connections';" | awk '{print $2}' | sed -n 2p)
CONNECTION_CHECK_TIME="'"$(date "+%F %T")"'"

# 모니터링값_Insert
mariadb -u root -p$DB_PW MONITOR -e "insert into TBL_CPU_CHECK values ($CPU_CHECK_TIME,$CPU_VALUE);"
mariadb -u root -p$DB_PW MONITOR -e "insert into TBL_MEMORY_CHECK values ($MEMORY_CHECK_TIME,$MEMORY_TOTAL,$MEMORY_USED,$MEMORY_FREE,$SERVER_MEMORY_USAGE,0,0);"
mariadb -u root -p$DB_PW MONITOR -e "insert into TBL_STORAGE_CHECK values ($STORAGE_CHECK_TIME,'L',$STORAGE_TOTAL,$STORAGE_USED,$STORAGE_FREE,$SERVER_STORAGE_USAGE);"
mariadb -u root -p$DB_PW MONITOR -e "insert into TBL_CONNECTION values ($CONNECTION_CHECK_TIME,$MAX_CONNECTION,$NOW_CONNECTION,$MAX_USED_CONNECTION);"




