# Docker final task

## Disclaimer

This project is my mini diploma project on Docker course, inside it **old version** of LibreSpeed apllication.

## Description

This code deploy **LibreSpeed php application*** with **php-fpm** and **nginx fastcgi**, **mysql DB**,  inside in app container, also it deploys **fluentd**, **EFK**, **Caddy** as revers proxy.

You may replace docker file with new app from [github](https://github.com/librespeed/speedtest) or build your own Dockerfile.

PHP app build from based on php:7.4-fpm + nginx fastcgi
Fluentd based on fluent/fluentd:v1.14-debian-1
EFK stack has version 7.14.0

## Foler structure

**build** - contains app directory and fluentd with Dockerfiles to build images

**rbmdkrfinalapp** - contains  conf directory and compose file for deploying app and mysql.
**rbmdkrfinalefk** - contains  conf directory and compose file for deploying EFK+proxy.



## Requrements to build 
  - Ubuntu OS 21.10 (tested)
  - Docker 20.10.12 (tested)
  - Docker compose v2.2.3 (tested)

## How to

### Build images
1. Clone repo
2. Change dir to build/app or build/fluentd
3. Build images by command
```
docker build . -t ${image_name}
```

4. Push your images to  your repo 


5. Edit image urls in compose file (rbmdkrfinalapp/app.compose.yml) accordind to your repo (only for app and fluentd service)

### Deploy Stacks
1. Init docker swarm mode and add nodes
```
docker swarm init 
```
2. Set up your MYSQL_PASSWORD,DB_PASSWORD, PASSWORD in rbmdkrfinalapp/app.compose.yml  for DB,APP, and APP statistic.

2. Change dir to root of repo.  Run **up.sh**. It creates two networks **app** and **pub**
```
./up.sh
```

3. Login to Kibana and add index pattern.

#### Check your app

1. APP address http://your_ip:8080
2. Second app add adress for debug http://your_ip:88
3. Kibana http://your_ip:5601
4. MYSQL DB your_ip:3306




## License
GNU GPL v3