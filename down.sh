#!/bin/bash

docker stack rm  rbmdkrfinalapp

sleep 10
docker stack rm  rbmdkrfinalefk
sleep 10
docker network rm app
sleep 5
docker network rm pub


docker ps -a
docker network ls

