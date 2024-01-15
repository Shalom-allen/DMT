# 기본 드라이브 설정(Mariadb 클라이언트 있는 곳)
cd C:

# CPU 사용량
$CPU_VALUE = (Get-WmiObject win32_processor).LoadPercentage
# CPU_날짜
$CPU_CHECK_TIME = get-date -UFormat "%Y-%m-%d %T"

# 메모리 정보 불러오기
$OPERATING_SYSTEM = Get-WmiObject win32_OperatingSystem
# 전체 메모리 크기(GB)
$TOTAL_MEMORY = $Operating_system.TotalVisibleMemorySize
$MEMORY_TOTAL = [Math]::Round($TOTAL_MEMORY / 1024 / 1024, 1)
# 여유 메모리 크기(GB)
$FREE_MEMORY = $Operating_system.FreePhysicalMemory
$MEMORY_FREE = [Math]::Round($FREE_MEMORY / 1024 / 1024, 0)
# 사용 중 메모리 크기(GB)
$USING_MEMORY = $TOTAL_MEMORY - $FREE_MEMORY
$MEMORY_USED = [Math]::Round($USING_MEMORY / 1024 / 1024, 0)
# 메모리 사용률 (%)
$SERVER_MEMORY_USAGE = [Math]::Round(($MEMORY_TOTAL - $MEMORY_FREE) * 100 / $MEMORY_TOTAL, 0)
# MEMORY_날짜
$MEMORY_CHECK_TIME = get-date -UFormat "%Y-%m-%d %T"

echo $CPU_VALUE
echo $MEMORY_TOTAL
echo $MEMORY_FREE
echo $MEMORY_USED
echo $SERVER_MEMORY_USAGE

.\'Program Files'\'MariaDB 10.11'\bin\mariadb.exe -h 172.30.170.6 -uuaccof_monitor -p MY_COMPUTER -e "insert into TBL_CPU_CHECK values ($CPU_CHECK_TIME,$CPU_VALUE);"

