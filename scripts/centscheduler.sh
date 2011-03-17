#!/bin/sh

### BEGIN INIT INFO
# Provides: centscheduler
# Required-Start: $local_fs
# Required-Stop:
# Default-Start: 2 3 4 5
# Default-Stop: 0 6
# Short-Description: Start and stop the centreon-scheduler
### END INIT INFO

prefix=/usr/local/nagios
exec_prefix=${prefix}
binary=${exec_prefix}/bin/nagios
config_file=${prefix}/etc/nagios.cfg
status_file=${prefix}/var/status.dat
retention_file=${prefix}/var/retention.dat
command_file=${prefix}/var/rw/nagios.cmd
var_dir=${prefix}/var
run_file=${prefix}/var/nagios.lock
lock_dir=/var/lock/subsys
lock_file=nagios
pid_file=/var/run/$(basename $binary).pid
user=nagios
group=nagios
timeout=300

servicename=$(basename "$0")
command="$1"

usage="Usage: $servicename {start|stop|restart|try-restart|reload|force-reload|status}"
lsb_init_functions="/lib/lsb/init-functions"

# Check source function library
if [ ! -r $lsb_init_functions ]; then
    echo "$servicename: not able to read $lsb_init_functions: script cannot run" 1>&2
    exit 1
fi

# Load source function library
. $lsb_init_functions

# Check arguments (only one parameter)
if [ $# -ne 1 ]; then
    if [ $# -lt 1 -o $command = "" ]; then
	log_failure_msg "$servicename: action not specified"
    else
	log_failure_msg "$servicename: too many parameters"
    fi
    log_warning_msg $usage
    exit 2
fi

# Check if we can find the binary.
if [ ! -x $binary ]; then
    if [ $command = "stop" ] ; then
	log_warning_msg "$servicename: binary $binary not found: $command request ignored"
	exit 0
    else
	log_failure_msg "$servicename: binary $binary not found: $command request failed"
	exit 5
    fi
fi

check_configuration()
{
# Check if we can find the configuration file.
    if [ ! -r $config_file ]; then
	log_failure_msg "$servicename: configuration file $config_file not found: $command request failed"
	exit 6
    fi

    $binary -v $config_file > /dev/null 2>&1
    if [ $? -ne 0 ]; then
    	log_failure_msg "$servicename $command: bad configuration."
    	exit 6
    fi
}

service_start()
{
    if [ ! -f $pid_file ]; then
	check_configuration

	su - $user -c "touch $var_dir/nagios.log $retention_file"
	touch $run_file
	chown $user:$group $run_file

	$binary $config_file > /dev/null  2>&1 &
	sleep 1
	pid=$(pidofproc $binary)
	if [ $? -ne 0 ]; then
	    log_failure_msg "$servicename $command: failed."
    	    exit 1
	fi
	echo $pid > $pid_file

	if [ -d $lock_dir ]; then
	    touch $lock_dir/$lock_file;
	fi
    fi
}

service_stop()
{
    pid=$(pidofproc $binary)
    if [ $? -eq 0 ]; then
	kill $pid

	for i in $(seq 1 $timeout); do
	    pidofproc $binary > /dev/null 2>&1
 	    if [ $? -ne 0 ]; then
 		break
 	    fi
 	    echo -n '.'
 	    sleep 1
	done

	pidofproc $binary > /dev/null 2>&1
	if [ $? -eq 0 ]; then
	    kill -TERM $pid
	fi
    fi
    rm -f $status_file $run_file $lock_dir/$lock_file $command_file $pid_file
}

service_reload()
{
    check_configuration
    pid=$(pidofproc $binary)
    if [ $? -ne 0 ]; then
	log_failure_msg "$servicename $command: $binary not running."
	exit 7
    fi
    kill -HUP $pid
}

service_force_reload()
{
    check_configuration
    pid=$(pidofproc $binary)
    if [ $? -ne 0 ]; then
	service_start
    else
	kill -HUP $pid
    fi
}

service_status()
{
    pidofproc $binary > /dev/null 2>&1
    if [ $? -eq 0 ]; then
    	log_success_msg "$servicename $command: running"
    	exit 0
    fi

    if [ -f $pid_file ]; then
	log_failure_msg "$servicename $command: $binary dead with existing pid file: $pid_file"
	exit 2
    fi

    if [ -f $run_file ]; then
	log_failure_msg "$servicename $command: $binary dead with existing lock file: $run_file"
	exit 2
    fi

    log_failure_msg "$servicename $command: $binary not running"
    exit 3
}

# see how we were called.
case $command in
    start)
	service_start
	;;

    stop)
	service_stop
	;;

    restart)
	pidofproc $binary > /dev/null 2>&1
	if [ $? -eq 0 ]; then
	    service_stop
	fi
	service_start
	;;

    try-restart)
	pidofproc $binary > /dev/null 2>&1
	if [ $? -eq 0 ]; then
	    service_stop
	    service_start
	fi
	;;

    reload)
	service_reload
	;;

    force-reload)
	service_force_reload
	;;

    status)
	service_status
	;;

    *)
	log_failure_msg "$servicename: command \"$command\" not recognized"
	log_warning_msg "$usage"
	exit 3
	;;
esac

log_success_msg "$servicename $command: done"
exit 0