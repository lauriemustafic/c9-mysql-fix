#!/bin/bash

function mvlogfiles () {
    if [ -e /var/lib/mysql/ib_logfile0 ]
    then
        echo "found ib_logfile0 moving it to ~/workspace"
        mv /var/lib/mysql/ib_logfile0 ~/ib_logfile0.bak
    else
        echo "ib_logfile0 not found, trying ib_logfile1"
    fi
    if [ -e /var/lib/mysql/ib_logfile1 ]
    then
        echo "found ib_logfile1 moving it to ~/workspace"
        mv /var/lib/mysql/ib_logfile1 ~/ib_logfile1.bak
    else
        echo "ib_logfile1 not found."
    fi
    echo "trying to start mysql"
    service mysql start -uroot
    
}

function init () {
    tail -1000 /var/log/mysql/error.log | grep -q 'ibdata files do not match the log sequence number'
    greprc=$?
    if [[ $greprc -eq 0 ]] ; then
        echo Found the error. Moving forward
        mvlogfiles
    else
    	echo Required error not found in the logs. Stopping here.
    fi
}

init
