#! /bin/sh


cmd=$1
db_username=$2
db_password=$3


sudo systemctl status docker || sudo systemctl start docker

docker pull postgres

docker container inspect jrvs-psql
container_status=$?


case $cmd in
  create)


  if [ $container_status -eq 0 ]; then
  		echo 'Container already exists'
  		exit 1
  	fi

  #check # of CLI arguments
 if [ $# -ne  3 ]; then
    echo 'Create requires username and password'
    exit 1
  fi


  #Create container
	docker volume create pgdata

	docker run --name jrvs-psql -e POSTGRES_PASSWORD=$db_password -d -v pgdata:/var/lib/postgresql/data -p 5432:5432 postgres:9.6-alpine
	exit $?
	#connecting to a psql instance
	psql -h localhost -U postgres -d $db_username -W
	;;

  start|stop)

  if [ $container_status -ne 0 ]; then

  		exit 1
  fi


	docker container $cmd jrvs-psql
	exit $?
	;;

  *)
	echo 'Illegal command'
	echo 'Commands: start|stop|create'
	exit 1
	;;

esac

