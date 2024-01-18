# Windows Power Shell

################################################
# 작성자    : 유민상
# 작성일    : 2024-01-18
# 수정자    : 
# 수정일    : 
# 설명      : 윈도우&MSSQL 모니터링 에이전트
###############################################

#이벤트 로그 확인 get-eventlog system

# DB 명 기입(모니터링 서버에 있는 DB명)
$DB_NAME = 'MY_COMPUTER'

# DBMS 패스워드
$DB_PW = '-p@minsang1'

# 기본 드라이브 설정(Mariadb 클라이언트 있는 곳)
cd C:\'Program Files'\'MariaDB 10.11'\bin\ 

# CPU 사용량
$CPU_VALUE = (Get-WmiObject win32_processor).LoadPercentage
# CPU_날짜
$CPU_CHECK_TIME = get-date -UFormat "'%Y-%m-%d %T'"

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
$MEMORY_CHECK_TIME = get-date -UFormat "'%Y-%m-%d %T'"

#####################################Storage
# 모든 드라이버 목록 구하기
$driver_list = Get-PSDrive -PSProvider FileSystem | Select -Property Name

# 디스크 정보 불러오기
foreach ($driver in $driver_list)
{
    $disk = Get-WmiObject win32_LogicalDisk -Filter "DeviceID='$($driver.Name):'"
    $DISK_NAME = $driver.Name
    $DISK_TOTAL_SIZE = [math]::Round($disk.Size/1gb)
    $DISK_USED_SIZE = [math]::Round(($disk.Size-$disk.FreeSpace)/1gb)
    $DISK_FREE_SIZE = [math]::Round($disk.FreeSpace/1gb)
    $DISK_USAGE = [math]::Round($DISK_USED_SIZE/$DISK_TOTAL_SIZE*100)
    $STORAGE_CHECK_TIME = get-date -UFormat "'%Y-%m-%d %T'"
    #write-host "insert into TBL_STORAGE_CHECK values ($STORAGE_CHECK_TIME,'$DISK_NAME',$DISK_TOTAL_SIZE,$DISK_USED_SIZE,$DISK_FREE_SIZE,$DISK_USAGE);"
    .\mariadb -h 172.30.170.6 -uuaccof_monitor $DB_PW MY_COMPUTER -e "insert into TBL_STORAGE_CHECK values ($STORAGE_CHECK_TIME,'$DISK_NAME',$DISK_TOTAL_SIZE,$DISK_USED_SIZE,$DISK_FREE_SIZE,$DISK_USAGE);"
}

# 모니터링 항목 Insert
.\mariadb -h 172.30.170.6 -uuaccof_monitor $DB_PW $DB_NAME -e "insert into TBL_CPU_CHECK values ($CPU_CHECK_TIME,$CPU_VALUE);"
.\mariadb -h 172.30.170.6 -uuaccof_monitor $DB_PW $DB_NAME -e "insert into TBL_MEMORY_CHECK values ($MEMORY_CHECK_TIME,$MEMORY_TOTAL,$MEMORY_USED,$MEMORY_FREE,$SERVER_MEMORY_USAGE,0,0);"
