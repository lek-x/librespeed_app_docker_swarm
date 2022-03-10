#!/bin/bash


echo 'Creating network APP'
docker network create -d overlay  app
sleep 1

echo 'Creating network PUB'
docker network create -d overlay  pub
sleep 1

docker stack deploy -c rbmdkrfinalefk/efk.compose.yml --prune --with-registry-auth rbmdkrfinalefk
echo "Stack efk was deployed. Waiting 5 sec"
sleep 5



docker stack deploy -c rbmdkrfinalapp/app.compose.yml --prune --with-registry-auth rbmdkrfinalapp
echo "Stack app was deployed. Waiting 20 sec for mysql"
sleep 20



docker service ls

