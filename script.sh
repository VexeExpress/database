#!/bin/sh

PROJECT=vexeexpress
PROJECT_CONTAINER=vexeexpress-database-container-1
PROJECT_IMAGE=vexeexpress-database-image
PROJECT_NETWORK=vexeexpress_network

# Check postgresql database ready or not then generate documentation
generate_documentation() {
	# Maximum number of attempts to check PostgreSQL readiness
	max_attempts=2

	# Counter for tracking the number of successful checks
	success_count=0

	# Check PostgreSQL readiness with a loop
	while [ $success_count -lt $max_attempts ]; do
		if docker exec ${PROJECT_CONTAINER} pg_isready; then
			echo "PostgreSQL is ready"
			success_count=$((success_count + 1))
			echo "Successful checks: $success_count"
		else
			echo "Waiting for PostgreSQL to become ready..."
		fi
		sleep 2
	done

	# Run the test if PostgreSQL is ready for the specified number of times
	if [ $success_count -eq $max_attempts ]; then
		echo "PostgreSQL is ready for $max_attempts checks. Running the test..."

		docker exec ${PROJECT_CONTAINER} mkdir /app/documentation/
		docker exec ${PROJECT_CONTAINER} java -jar /app/schemaspy/schemaspy-6.2.4.jar -t pgsql -dp /app/schemaspy/postgresql-42.7.3.jar -db vexeexpress -host localhost -port 5432 -u postgres -p postgres -o /app/documentation

		FILES=$(ls ./documentation)
		if [ -z "$FILES" ]; then
			echo "No files found in documentation directory."
			exit 1
		else
			echo "Files found in documentation directory."
		fi
	else
		echo "PostgreSQL is not ready after $max_attempts attempts"
		exit 1
	fi
}

access() {
	docker exec -it ${PROJECT_CONTAINER} sh
}

access_database() {
	docker exec -it ${PROJECT_CONTAINER} psql -U postgres
}

build_image() {
	docker buildx build . -t ${PROJECT_IMAGE}
}

log_container() {
	docker logs ${PROJECT_CONTAINER}
}

rebuild_all() {
    remove_all
    build_image
    start_compose
}

remove_all() {
	remove_container
	remove_image
}

remove_container() {
	docker compose -p ${PROJECT} down
}

remove_image() {
	docker rmi ${PROJECT_IMAGE}:latest
}

start_compose() {
	FILES=$(find documentation)
	if [ -z "$FILES" ]; then
		mkdir documentation
	fi

	docker compose -p ${PROJECT} -f docker-compose.yml up -d
}

stop_compose() {
	docker compose -p ${PROJECT} stop
}

print_list() {
	echo "Pass wrong arguments! Here is list of arguments for docker script"
	echo -e "\taccess                 : access container"
	echo -e "\taccess-database        : access database in container"
	echo -e "\tbuild-image            : build docker image"
	echo -e "\tgenerate-documentation : generate schemaspy documentation"
	echo -e "\tlog                    : log docker container"
	echo -e "\trebuild-all            : rebuild all (container, network, image)"
	echo -e "\tremove-all             : remove all"
	echo -e "\tremove-container       : remove container"
	echo -e "\tremove-image           : remove image"
	echo -e "\tstart                  : start docker compose"
	echo -e "\tstop                   : stop docker compose"
}

if [ $# -eq 1 ]; then
	case "$1" in
		"access" )
			access ;;
		"access-database" )
			access_database ;;
		"build-image" )
			build_image ;;
		"generate-documentation" )
			generate_documentation ;;
		"log" )
			log_container ;;
		"rebuild-all" )
			rebuild_all ;;
		"remove-all" )
			remove_all ;;
		"remove-container" )
			remove_container ;;
		"remove-image" )
			remove_image ;;
		"start" )
			start_compose ;;
		"stop" )
			stop_compose ;;
		* )
			print_list ;;
	esac
else
	print_list
fi
