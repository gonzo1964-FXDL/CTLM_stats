#!/bin/bash
#
#       get runstats from cmr_iolaog     
#
# 05.12.2016 : change Table "cms_jobdef" to "cmr_ajf" in order to catch jobs created by "ctmcreate" utility
#
#
qYear=`date --date '-'-1' day' +'%y'`
qDay=`date --date '-'-1' day' +'%d'`
qDat=`date --date '-'-1' day' +'%Y%m%d'`
#
############################
outPath="/netfs/CTLM/TOOLS/jobosr_scripts/log"
#
#
#       temporarily until ORACLE has been migrated to PG - SOurce jobs are in "CTMADM-IOALOG-CSV" called "RUNSSTATS-[1-6]P"
#
    cd ${outPath}
    # temp --- until db has been moved
    #
    #
    ls -l /MUC*${qDat}.csv
    files=`ls  MUC*${qDat}.csv`
    for j in ${files}
    do
        tail -n +3 ${j} > x_${j}
        xx=`echo ${j:5:2}`
        if [ ${xx} == "4C" ]
        then
            db_Table="runinfshout_cft"
        else
            db_Table="runinfshout"
        fi
        echo "parse_insert_csv.py ${outPath}/x_${j} ${db_Table}"
        python /netfs/CTLM/TOOLS/jobosr_scripts/bin/parse_insert_csv.py ${outPath}/x_${j} ${db_Table}
    done
#
#
rm -irf ${outPath}/x_${j}
echo "ORACLE done"
echo "PG START"
#
#db_Table="runinfshout_tst"
#for i in ct1tst ct4tst ct5tst ct6tst ct4dev ct1prd ct4prd ct5prd ct4cfs
for i in ct4prd ct5prd ct1prd ct4cfs ct1tst ct4tst ct5tst ct6tst ct4dev
do
#    dbHost="mucctlatv02"
db_Table="runinfshout_tst"
    if [ $i == "ct1tst" ]
        then
			echo "$i"
            export PGPASSWORD=ct1tst900
            dbUser="ct1tst900"
            dbName="ct1tst900"
            dbHost="mucctlatv02"
            dbPort="5438"
    fi
    if [ $i == "ct2tst" ]
        then
			echo "$i"
            export PGPASSWORD=ct2tst900
            dbUser="ct2tst900"
            dbName="ct2tst900"
            dbHost="mucctlatv02"
            dbPort="5438"
    fi
    if [ $i == "ct3tst" ]
        then
			echo "$i"		
            export PGPASSWORD=ct3tst900
            dbUser="ct3tst"
            dbName="ct3tst900"
            dbHost="mucctlatv02"
            dbPort="5433"
    fi    
    if [ $i == "ct4tst" ]
        then
			echo "$i"
			export PGPASSWORD=ct4tst900			
            dbUser="ct4tst900"
            dbName="ct4tst900"
            dbHost="mucctlatv02"
            dbPort="5436"
    fi
    if [ $i == "ct5tst" ]
        then
			echo "$i"		
            export PGPASSWORD=ct5tst900
            dbUser="ct5tst900"
            dbName="ct5tst900"
            dbHost="mucctlatv02"
            dbPort="5435"
    fi    
    if [ $i == "ct6tst" ]
        then
			echo "$i"		
            export PGPASSWORD=ct6tst900
            dbUser="ct6tst900"
            dbName="ct6tst900"
            dbHost="mucctlatv02"
            dbPort="5437"
    fi    
    if [ $i == "ct4dev" ]
        then
			echo "$i"		
            export PGPASSWORD=ct4dev900
            dbUser="ct4dev900"
            dbName="ct4dev900"
            dbHost="mucctlatv02"
            dbPort="5434"
	    db_Table="runinfshout_dev"
    fi    
	#
	#prd
    if [ $i == "ct1prd" ]
        then
			echo "$i"		
            export PGPASSWORD=ct1prd900
            dbUser="ct1prd900"
            dbName="ct1prd900"
            dbHost="mucctlapv02"
            dbPort="5432"
	    db_Table="runinfshout"
    fi 
    if [ $i == "ct4prd" ]
        then
			echo "$i"		
            export PGPASSWORD=ct4prd900
            dbUser="ct4prd900"
            dbName="ct4prd900"
            dbHost="mucctlapv04"
            dbPort="5432"
	    db_Table="runinfshout"
    fi
    if [ $i == "ct4cfs" ]
        then
			echo "$i"		
            export PGPASSWORD=ct4cfs900
            dbUser="ct4cfs900"
            dbName="ct4cfs900"
            dbHost="mucctlapv07"
            dbPort="5432"
	    db_Table="runinfshout_cft"
    fi 
    if [ $i == "ct3prd" ]
        then
			echo "$i"		
            export PGPASSWORD=ct3prd900
            dbUser="ct3prd900"
            dbName="ct3prd900"
            dbHost="mucctlapv03"
            dbPort="5432"
	    db_Table="runinfshout"
    fi 
    if [ $i == "ct5prd" ]
        then
			echo "$i"		
            export PGPASSWORD=ct5prd900
            dbUser="ct5prd900"
            dbName="ct5prd900"
            dbHost="mucctlapv05"
            dbPort="5432"
	    db_Table="runinfshout"
    fi 

   
	psql -U ${dbUser} -h ${dbHost} -p ${dbPort} -d ${dbName} -c "\copy (select distinct cmr_runinf.JOBNAME, cmr_runinf.ELAPTIME, cmr_runinf.TIMESTMP, cmr_runinf.ORDERNO, cmr_runinf.nodeid, cmr_ioalog.odate, cmr_ajf.APPLIC, cmr_ajf.APPLGROUP, cmr_runinf.RUNCOUNT, cmr_runinf.OSCOMPSTAT from cmr_runinf, cmr_ioalog, cmr_ajf where cmr_runinf.orderno = cmr_ioalog.orderno and cmr_runinf.jobname = cmr_ajf.jobname and cmr_runinf.jobname = cmr_ioalog.jobname and cmr_runinf.STARTRUN = '${qDat}' order by TIMESTMP) to ${outPath}/${dbName}_${qDat}.csv  WITH CSV"
	#
    chmod 666 ${outPath}/${dbName}_${qDat}.csv
    echo "parse_insert_csv.py ${outPath}/${dbName}_${qDat}.csv  ${db_Table}"
    python /netfs/CTLM/TOOLS/jobosr_scripts/bin/parse_insert_csv.py ${outPath}/${dbName}_${qDat}.csv  ${db_Table}
    #
done
#
gzip ${outPath}/*.csv
find ${outPath}/ -iname "*.gz" -mtime +30 -delete
