import csv
import sys
import time
from datetime import datetime
import mysql.connector


class JobInsert:

    def __init__(self, filename):
        self.filename = filename
        
        self.filename = sys.argv[1]
        self.tablename = sys.argv[2]


    def parsecsv(self):
        'parse csv file and insert values in to MySql database'
        f = open(self.filename, 'rb')
        try:
            reader = csv.reader(f, delimiter=',')
            for content in reader:
                jobname = str(content[0]).strip()
                elap_time = str(content[1]).strip()
                end_time_in_string = str(content[2]).strip()
                start_time = self.calculatestarttime(end_time_in_string, int(elap_time))
                order_no = str(content[3]).strip()
                node_id = str(content[4]).strip()
                order_date = str(content[5]).strip()
                app = str(content[6]).strip()
                app_group = str(content[7]).strip()
                run_count = str(content[8]).strip()
                OSCOMPSTAT = str(content[9]).strip()
                self.insert_db_values(jobname, start_time, end_time_in_string, order_no, node_id, order_date, app, app_group, int(run_count), int(OSCOMPSTAT))
        except Exception as e:
            print "Exception in parsing csv file:- ", str(e)

    def calculatestarttime(self, end_time, elapse_time):
        'calculate start time from end time and elapsed time'
        year,month,day,hrs,min,sec = self.parsedatetime(end_time)
        end_date_time = datetime(year,month,day,hrs,min,sec)
        end_time_in_sec = time.mktime(end_date_time.timetuple())*100
        start_time_sec = (end_time_in_sec - elapse_time)/100
        start_time = datetime.fromtimestamp(start_time_sec)
        start_time_format = '{:%Y%m%d%H%M%S}'.format(start_time)
        return start_time_format

    def parsedatetime(self, exec_time):
        'parse the date and time in a particular format from the string'
        end_date = exec_time[:8]
        year = int(end_date[:4])
        month = int(end_date[4:6])
        day = int(end_date[6:8])
        try:
            time = exec_time[8:]
            hrs,min,sec = int(time[:2]), int(time[2:4]), int(time[4:])
            return year,month,day,hrs,min,sec
        except:
            pass
        return year,month,day

    def insert_db_values(self, jobname, start_time, end_time, order_no, node_id, order_date,app,app_group, run_count, OSCOMPSTAT):
        'connecting with db and inserting the job values in mysql db'
        try:
            #con = mysql.connector.connect(host="localhost", user="root", passwd="admin@123", db="vishal", port=3306) # replace database credentials if wrong
            con = mysql.connector.connect(host="mucctlwpv01", user="runinfshout", passwd="Amadeus$1", db="statsdb", port=3306) # replace database credentials if wrong
            cursor = con.cursor()
            if OSCOMPSTAT == 0:
                status = 'ENDED_OK'
            else:
                #status = None
                status = 'ENDED_NOTOK'
            #print self.tablename
            #add_job = ("INSERT INTO runinfshout_new "
            add_job = ("INSERT INTO "+ self.tablename +""
                       "(JOBNAME, STARTTIME, ENDTIME, ORDERID, NODEGROUP, ODATE, APPLICATION, GROUPNAME, RERUNCOUNTER, STATUS) "
                       "VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s)")
            job_values = (jobname, start_time, end_time, order_no, node_id, order_date, app, app_group, run_count, status)
            cursor.execute(add_job, job_values)
        except Exception as e:
            print "Database Error:- ", str(e)
        finally:
            con.commit()
            cursor.close()
            con.close()

if __name__ == '__main__':
    print "......................................"
    print sys.argv[1]
    JobInsert(sys.argv[1]).parsecsv()
#    JobInsert('final.csv').parsecsv()
