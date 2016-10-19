#!/bin/bash

for i in $@
do
        if  [ ${i:2:2} = "ip" ]
                then
                IP=${i:5:20}
        elif [ ${i:2:7} = "command" ]
                then
                CMD=${i:10:20}
        elif [ ${i:2:4} = "port" ]
                then
                MYSQL_PORT=${i:7:20}
        fi
done
USER="mha"
PASSWORD="test"
function stopssh {
        mysql -s -u$USER -p$PASSWORD -h$IP -P$MYSQL_PORT -e 'select count(*) as c from mysql.user;'  &> /dev/null
        if [ $? -ne 0 ]
        then
                ssh $IP 'killall keepalived'
                if [ $? != 0 ]
                        then
                        echo "$IP killall keepalived fail....."
                        return 1
                fi
                        return 0
        fi
}

function stop {
        mysql -s -u$USER -p$PASSWORD -h$IP -P$MYSQL_PORT -e 'select count(*) as c from mysql.user;'  &> /dev/null
        if [ $? -ne 0 ]
        then
                ssh $IP 'shutdown -h now'
               if [ $? != 0 ]
                        then
                        echo "$IP shutdown  fail....."
                        return 1
               fi
                        return 0
        fi
}

if [ $CMD = 'stopssh' ]
        then
        stopssh
fi