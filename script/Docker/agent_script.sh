#! /bin/bash

###############################################################
# 작성자: 유민상
# 작성일: 2024-05-30
# 수정자:
# 수정일:
# 설명	: Agent
###############################################################
# 모니터링 DBMS 비밀번호 불러오기
#echo ${#DB_PW} => 길이 확인
N_DB_PW=$(cat /mnt/d/04.study/DMT/script/Docker/agent_set.conf | sed -n '/MONITOR_MAIN_DB_PW/p' | cut -d '=' -f2)
DB_PW="${N_DB_PW:0:10}"

# 서버 CPU 모니터링
CPU_VALUE=$(top -bn 1 | awk '{ print $9}' | awk 'NR>=8{print}' | awk '{total_size += $1;} END {print total_size;}')
CPU_CHECK_TIME="'"$(date "+%F %T")"'"
echo "insert into TBL_CPU_CHECK values ($CPU_CHECK_TIME,$CPU_VALUE);" > /mnt/d/04.study/Container/maria/share/backup/agent_$(date +"%G%m%d").sql

# 서버 MEMORY 모니터링
MEMORY_TOTAL=$(free -g | sed -n 2p | awk '{print $2}')
MEMORY_USED=$(free -g | sed -n 2p | awk '{print $3}')
MEMORY_FREE=$(free -g | sed -n 2p | awk '{print $4}')
MEMORY_BUFFER=$(free -g | sed -n 2p | awk '{print $6}')
Mem_usage=$(echo "scale=1; $MEMORY_USED/$MEMORY_TOTAL*100" | bc -l)
SERVER_MEMORY_USAGE=$(echo "$Mem_usage/1" | bc)
MEMORY_CHECK_TIME="'"$(date "+%F %T")"'"
echo "insert into TBL_MEMORY_CHECK values ($MEMORY_CHECK_TIME,$MEMORY_TOTAL,$MEMORY_USED,$MEMORY_FREE,$SERVER_MEMORY_USAGE,$MEMORY_BUFFER);" >> /mnt/d/04.study/Container/maria/share/backup/agent_$(date +"%G%m%d").sql

# 서버 STORAGE 모니터링(root)
#df -h | grep ^/dev/sdd && df -h | grep ^"C:" | head -1 && df -h | grep ^"D:" && df -h | grep ^"Y:" | awk '{print $1}
#STORAGE_NAME=$(cat /mnt/d/04.study/DMT/script/Docker/agent_set.conf | sed -n '/ROOT_LOCATION/p' | cut -d '=' -f2)
STORAGE_NAME1="'"$(echo "sdd")"'"
S_TOTAL=$(df | sed -n '/'sdd'/p' | awk '{print $2}')
STORAGE_TOTAL1=$(echo "$S_TOTAL/1024/1024" | bc)
S_USED=$(df | sed -n '/'sdd'/p' | awk '{print $3}')
STORAGE_USED1=$(echo "$S_USED/1024/1024" | bc)
S_FREE=$(df | sed -n '/'sdd'/p' | awk '{print $4}')
STORAGE_FREE1=$(echo "$S_FREE/1024/1024" | bc)
SERVER_STORAGE_USAGE1=$(df | sed -n '/'sdd'/p' | awk '{print $5}' | sed 's/%.*$//')
STORAGE_CHECK_TIME1="'"$(date "+%F %T")"'"
echo "insert into TBL_STORAGE_CHECK values ($STORAGE_CHECK_TIME1,$STORAGE_NAME1,$STORAGE_TOTAL1,$STORAGE_USED1,$STORAGE_FREE1,$SERVER_STORAGE_USAGE1);" >> /mnt/d/04.study/Container/maria/share/backup/agent_$(date +"%G%m%d").sql

# 서버 STORAGE 모니터링
STORAGE_NAME2="'"$(echo "C:")"'"
S_TOTAL=$(df | sed -n '/'C:'/p' | awk '{print $2}' | head -1)
STORAGE_TOTAL2=$(echo "$S_TOTAL/1024/1024" | bc)
S_USED=$(df | sed -n '/'C:'/p' | awk '{print $3}' | head -1)
STORAGE_USED2=$(echo "$S_USED/1024/1024" | bc)
S_FREE=$(df | sed -n '/'C:'/p' | awk '{print $4}' | head -1)
STORAGE_FREE2=$(echo "$S_FREE/1024/1024" | bc)
SERVER_STORAGE_USAGE2=$(df | sed -n '/'C:'/p' | awk '{print $5}' | sed 's/%.*$//' | head -1)
STORAGE_CHECK_TIME2="'"$(date "+%F %T")"'"
echo "insert into TBL_STORAGE_CHECK values ($STORAGE_CHECK_TIME2,$STORAGE_NAME2,$STORAGE_TOTAL2,$STORAGE_USED2,$STORAGE_FREE2,$SERVER_STORAGE_USAGE2);" >> /mnt/d/04.study/Container/maria/share/backup/agent_$(date +"%G%m%d").sql

# 서버 STORAGE 모니터링
STORAGE_NAME3="'"$(echo "D:")"'"
S_TOTAL=$(df | sed -n '/'D:'/p' | awk '{print $2}')
STORAGE_TOTAL3=$(echo "$S_TOTAL/1024/1024" | bc)
S_USED=$(df | sed -n '/'D:'/p' | awk '{print $3}')
STORAGE_USED3=$(echo "$S_USED/1024/1024" | bc)
S_FREE=$(df | sed -n '/'D:'/p' | awk '{print $4}')
STORAGE_FREE3=$(echo "$S_FREE/1024/1024" | bc)
SERVER_STORAGE_USAGE3=$(df | sed -n '/'D:'/p' | awk '{print $5}' | sed 's/%.*$//')
STORAGE_CHECK_TIME3="'"$(date "+%F %T")"'"
echo "insert into TBL_STORAGE_CHECK values ($STORAGE_CHECK_TIME3,$STORAGE_NAME3,$STORAGE_TOTAL3,$STORAGE_USED3,$STORAGE_FREE3,$SERVER_STORAGE_USAGE3);" >> /mnt/d/04.study/Container/maria/share/backup/agent_$(date +"%G%m%d").sql

# 서버 STORAGE 모니터링
STORAGE_NAME4="'"$(echo "Y:")"'"
S_TOTAL=$(df | sed -n '/'Y:'/p' | awk '{print $2}')
STORAGE_TOTAL4=$(echo "$S_TOTAL/1024/1024" | bc)
S_USED=$(df | sed -n '/'Y:'/p' | awk '{print $3}')
STORAGE_USED4=$(echo "$S_USED/1024/1024" | bc)
S_FREE=$(df | sed -n '/'Y:'/p' | awk '{print $4}')
STORAGE_FREE4=$(echo "$S_FREE/1024/1024" | bc)
SERVER_STORAGE_USAGE4=$(df | sed -n '/'Y:'/p' | awk '{print $5}' | sed 's/%.*$//')
STORAGE_CHECK_TIME4="'"$(date "+%F %T")"'"
echo "insert into TBL_STORAGE_CHECK values ($STORAGE_CHECK_TIME4,$STORAGE_NAME4,$STORAGE_TOTAL4,$STORAGE_USED4,$STORAGE_FREE4,$SERVER_STORAGE_USAGE4);" >> /mnt/d/04.study/Container/maria/share/backup/agent_$(date +"%G%m%d").sql

# DBMS 커넥션 모니터링
MAX_CONNECTION=$(docker exec -t 34489ecd96d6 sh -c "mariadb -uroot -p123 mysql -e 'show variables;' | grep ^max_connections | cut -c 17-10000")
NOW_CONNECTION=$(docker exec -t 34489ecd96d6 sh -c "mariadb -uroot -p123 mysql -e 'show status;' | grep ^Threads_connected | cut -c 19-10000")
MAX_USED_CONNECTION=$(docker exec -t 34489ecd96d6 sh -c "mariadb -uroot -p123 mysql -e 'show status;' | grep ^Max_used_connections | head -1 | cut -c 22-10000")
CONNECTION_CHECK_TIME="'"$(date "+%F %T")"'"
echo "insert into TBL_CONNECTION values ($CONNECTION_CHECK_TIME,$MAX_CONNECTION,$NOW_CONNECTION,$MAX_USED_CONNECTION);" | perl -p -e 's/\015//g' >> /mnt/d/04.study/Container/maria/share/backup/agent_$(date +"%G%m%d").sql

docker exec -d 34489ecd96d6 sh -c "mariadb -u root -p123 moni_study < /maria/backup/agent_$(date +"%G%m%d").sql"

docker exec -d 34489ecd96d6 sh -c "rm -rf /maria/backup/agent_$(date +"%G%m%d").sql"
#sleep 0.5

#모니터링값_Insert
#docker exec -it 34489ecd96d6 sh -c "mariadb -u root -p123 moni_study -e 'insert into TBL_CPU_CHECK(ILJA, CPU_USAGE) values ($CPU_CHECK_TIME,$CPU_VALUE)'"
#docker exec -it 34489ecd96d6 sh -c "mariadb -u root -p123 moni_study -e 'insert into TBL_MEMORY_CHECK values ($MEMORY_CHECK_TIME,$MEMORY_TOTAL,$MEMORY_USED,$MEMORY_FREE,$SERVER_MEMORY_USAGE,$MEMORY_BUFFER);'"
#docker exec -it 34489ecd96d6 sh -c "mariadb -u root -p123 moni_study -e 'insert into TBL_STORAGE_CHECK values ($STORAGE_CHECK_TIME1,$STORAGE_NAME1,$STORAGE_TOTAL1,$STORAGE_USED1,$STORAGE_FREE1,$SERVER_STORAGE_USAGE1);'"
#docker exec -it 34489ecd96d6 sh -c "mariadb -u root -p123 moni_study -e 'insert into TBL_STORAGE_CHECK values ($STORAGE_CHECK_TIME2,$STORAGE_NAME2,$STORAGE_TOTAL2,$STORAGE_USED2,$STORAGE_FREE2,$SERVER_STORAGE_USAGE2);'"
#docker exec -it 34489ecd96d6 sh -c "mariadb -u root -p123 moni_study -e 'insert into TBL_STORAGE_CHECK values ($STORAGE_CHECK_TIME3,$STORAGE_NAME3,$STORAGE_TOTAL3,$STORAGE_USED3,$STORAGE_FREE3,$SERVER_STORAGE_USAGE3);'"
#docker exec -it 34489ecd96d6 sh -c "mariadb -u root -p123 moni_study -e 'insert into TBL_STORAGE_CHECK values ($STORAGE_CHECK_TIME4,$STORAGE_NAME4,$STORAGE_TOTAL4,$STORAGE_USED4,$STORAGE_FREE4,$SERVER_STORAGE_USAGE4);'"
#docker exec -it 34489ecd96d6 sh -c "mariadb -u root -p123 moni_study -e 'insert into TBL_CONNECTION values ($CONNECTION_CHECK_TIME,$MAX_CONNECTION,$NOW_CONNECTION,$MAX_USED_CONNECTION);'"


