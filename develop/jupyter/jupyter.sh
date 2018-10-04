#! /bin/sh

jupyter_BIN=/usr/local/bin/jupyter
IP=127.0.0.1

case "$1" in
	start)
		echo -n "Starting jupyter "
        /usr/bin/nohup ${jupyter_BIN} notebook --ip=$IP >/dev/null 2>&1 &
		echo " done"
	;;

	stop)
		echo -n "Gracefully shutting down jupyter"
		# 排除当前 grep 进程
        /bin/ps -ef | grep jupyter | grep -v grep | awk '{print $2}' | xargs kill -9
		echo " done"
	;;

	restart)
		$0 stop
		$0 start
	;;

	*)
		echo "Usage: $0 {start|stop|restart}"
		exit 1
	;;

esac