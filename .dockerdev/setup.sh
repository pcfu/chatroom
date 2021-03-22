NAME=`grep -i 'project_name' .env | cut -f2- -d=`
VERS=`grep -i 'project_version' .env | cut -f2- -d=`

BUNDLE=${NAME}_${VERS}_bundle
NODE_MODULES=${NAME}_${VERS}_node_modules

output=$({ `docker volume inspect $BUNDLE`; } 2>&1)
if [[ "$output" == *"No such volume"* ]]; then
    docker volume create $BUNDLE
fi

output=$({ `docker volume inspect $NODE_MODULES`; } 2>&1)
if [[ "$output" == *"No such volume"* ]]; then
    docker volume create $NODE_MODULES
fi

docker-compose build
