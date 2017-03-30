#!/usr/local/bin/bash
#
#..........cleanup MySQL ctmadm
#
cd /netfs/CTLM/TOOLS/jobosr_scripts/bin
minusDay=20
dat=`date --date '-'${minusDay}' day' +'%Y-%m-%d'`
DB_table="tst"
echo ${dat} 
echo $DB_table   
mysql -ustatsdb -pdETA54hntvHc8HC3 statsdb -e "select count(*) from runinfshout_${DB_table} where STARTTIME like ${dat}%" 
mysql -ustatsdb -pdETA54hntvHc8HC3 statsdb -e "delete from runinfshout_${DB_table} where STARTTIME like '${dat}%'"
#
DB_table="cft"
minusDay=30
dat=`date --date '-'${minusDay}' day' +'%Y-%m-%d'`
echo ${dat}
echo $DB_table
mysql -ustatsdb -pdETA54hntvHc8HC3 statsdb -e "select count(*) from runinfshout_${DB_table} where STARTTIME like '${dat}%'" 
mysql -ustatsdb -pdETA54hntvHc8HC3 statsdb -e " select * from runinfshout_${DB_table} where STARTTIME like '${dat}%'"  | sed 's/\t/","/g;s/^/"/;s/$/"/' > /netfs/CTLM/TOOLS/jobosr_scripts/archive/runinfstat/${DB_table}_${dat}.csv 
mysql -ustatsdb -pdETA54hntvHc8HC3 statsdb -e "delete from runinfshout_${DB_table} where STARTTIME like '${dat}%'" 
mysql -ustatsdb -pdETA54hntvHc8HC3 statsdb -e "select count(*) from runinfshout_${DB_table} where STARTTIME like '${dat}%'" 
#
DB_table="dev"
minusDay=5
dat=`date --date '-'${minusDay}' day' +'%Y-%m-%d'`
echo ${dat}
echo $DB_table
mysql -ustatsdb -pdETA54hntvHc8HC3 statsdb -e "select count(*) from runinfshout_${DB_table} where STARTTIME like '${dat}%'"
mysql -ustatsdb -pdETA54hntvHc8HC3 statsdb -e "delete from runinfshout_${DB_table} where STARTTIME like '${dat}%'"
#
DB_table="prd"
minusDay=60
dat=`date --date '-'${minusDay}' day' +'%Y-%m-%d'`
echo ${dat}
echo "PRD"
mysql -ustatsdb -pdETA54hntvHc8HC3 statsdb -e "select count(*) from runinfshout where STARTTIME like '${dat}%'"
mysql -ustatsdb -pdETA54hntvHc8HC3 statsdb -e " select * from runinfshout where STARTTIME like '${dat}%'"  | sed 's/\t/","/g;s/^/"/;s/$/"/' > /netfs/CTLM/TOOLS/jobosr_scripts/archive/runinfstat/${DB_table}_${dat}.csv
mysql -ustatsdb -pdETA54hntvHc8HC3 statsdb -e "delete from runinfshout where STARTTIME like '${dat}%'"
mysql -ustatsdb -pdETA54hntvHc8HC3 statsdb -e "select count(*) from runinfshout where STARTTIME like '${dat}%'" 
#
# cleanup FS
#
gzip /netfs/CTLM/CTMLOG/*.csv
find /netfs/CTLM/CTMLOG/ -iname "*.gz" -mtime +30 -delete
#
find /netfs/CTLM/TOOLS/jobosr_scripts/archive/runinfstat -iname "*.csv" -mtime +60 -delete

