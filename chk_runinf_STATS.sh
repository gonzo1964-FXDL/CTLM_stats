#!/usr/local/bin/bash
#
#
#rc=`mysql -Ns \`cat ~/.mysql_statsdb-e\` "select * from runinfshout where jobname like '%UTILCTMJSA%' and NODEGROUP like 'mucct4p' and STARTTIME like '\`date --date '-1 day' +'%Y-%m-%d'% \`'  ;"`
rc=`mysql -Ns \`cat ~/.mysql_statsdb-e\` "select * from runinfshout where jobname like '%UTILCTMJSA%' and STARTTIME like '\`date --date '-1 day' +'%Y-%m-%d'% \`'  ;"`

echo "->${rc}<-"

if [[ -z "$rc" ]] ; then 
    echo "there is no matching entry found in the runinfshout table"
    exit 99
fi

