NAME=`grep -i 'project_name' .env | cut -f2- -d=`
VERS=`grep -i 'project_version' .env | cut -f2- -d=`

BUNDLE=${NAME}_${VERS}_bundle
NODE_MODULES=${NAME}_${VERS}_node_modules
PACKS=${NAME}_${VERS}_packs

output=$({ `docker volume inspect $BUNDLE`; } 2>&1)
if [[ "$output" == *"No such volume"* ]]; then
    docker volume create $BUNDLE
fi

output=$({ `docker volume inspect $NODE_MODULES`; } 2>&1)
if [[ "$output" == *"No such volume"* ]]; then
    docker volume create $NODE_MODULES
fi

output=$({ `docker volume inspect $PACKS`; } 2>&1)
if [[ "$output" == *"No such volume"* ]]; then
    docker volume create $PACKS
fi

docker-compose build
