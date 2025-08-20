# Deploy Sonatype Nexus Repository OSS v3 with Docker & Traefik v2

![](https://miro.medium.com/max/875/1*IlUzgrFjStL8CmPx2esyMg.png)

[Nexus](https://www.sonatype.com/nexus-repository-oss) has a [Docker image](https://hub.docker.com/r/sonatype/nexus3/) but it exposes port HTTP 8081. In this post, I will explain how to configure nexus repository OSS version 3 with [Traefik](https://hub.docker.com/_/traefik?tab=description) version 2 via [docker-compose](https://docs.docker.com/compose/install/) on Ubuntu 18

I assume that you already installed the latest docker engine and docker-compose.

1. Create a volume directory for nexus-data. I used /nexus-data directory which is the mount point of the second disk. You can create a docker volume but I would like to use a dedicated disk for nexus. If I need to resize the disk later, I could do it by changing the volume size online.

# mkdir /nexus-data  
# chown -R 200 /nexus-data

Nexus user id is 200 in the docker image.

2. Create let's encrypt directory to store traefik version 2 acme.json file which keeps SSL certs.  
`# mkdir -p /docker/letsencrypt`

3. Download the following docker-compose file

then change `NEXUS.mydomain.com` with your domain name.

Before starting traefik container, you must create this record and must point your nexus server IP address to get Letscrypt SSL automatically.

Change `[acme.email=MYEMAIL@gmail.com](mailto:acme.email=MYEMAIL@gmail.com)` Traefik will renew the SSL automatically. Letsencrypt will send notifications to this email address about renewal or updates.

then run `docker-compose up -d`

$ sudo docker-compose up -d  
Creating traefik ... done  
Creating nexus   ... done  
root@nexus:/docker# docker ps  
CONTAINER ID        IMAGE               COMMAND                  CREATED              STATUS              PORTS                                      NAMES  
226902a54fe9        sonatype/nexus3     "sh -c ${SONATYPE_DI…"   About a minute ago   Up About a minute   8081/tcp                                   nexus  
4b50941c2386        traefik             "/entrypoint.sh --lo…"   About a minute ago   Up About a minute   0.0.0.0:80->80/tcp, 0.0.0.0:443->443/tcp   traefik

# NOTES

-   Traefik version 2 configuration is completely different from version 1. So this configuration works only with v2.
-   Traefik was configured to redirect HTTP to HTTPS
-   Treafik log level set to DEBUG. If you don’t see any problem, you can change it to INFO or ERROR later.
-   Use all labels for the containers!  
    For example, If you set `traefik.http.routers.nexus.tls` but don’t set `traefik.http.routers.nexus.tls.certresolver` Traefik will use it’s default self-signed SSL.  
    If you don’t set `traefik.http.routers.nexus.entrypoints=websecure` traefik will server only over HTTP not HTTPS.
-   Nexus 3 Repository Manager admin password will be stored in /nexus-data/admin. password When you change it over the admin panel, it will be deleted.
-   Nexus 3 docker image by default allocated 1.2GB memory for java proces. If you need more you can set with the `INSTALL4J_ADD_VM_PARAMS` env variable

- Конфигурация Traefik версии 2 полностью отличается от версии 1. 
  Таким образом, эта конфигурация работает только с v2.  
- Traefik настроен на перенаправление с HTTP на HTTPS.  
- Уровень журнала Treafik установлен на DEBUG. 
  Если вы не видите никаких проблем, вы можете изменить его на INFO или ERROR позже.  
- Используйте все этикетки для контейнеров!  
- Например, если вы установите traefik.http.routers.nexus.tls, 
  но не установите traefik.http.routers.nexus.tls.certresolver, 
  Traefik будет использовать самоподписанный SSL по умолчанию.
- Если вы не установите traefik.http.routers.nexus.entrypoints=websecure, traefik будет работать только через HTTP, а не через HTTPS.  
- Пароль администратора Nexus 3 Repository Manager будет храниться в /nexus-data/admin. пароль При смене через админку он будет удален.  
- Образ докера Nexus 3 по умолчанию выделяет 1,2 ГБ памяти для процессов Java. Если вам нужно больше, вы можете установить переменную env INSTALL4J_ADD_VM_PARAMS.

 environment:  
    — INSTALL4J_ADD_VM_PARAMS=-Xms4200m -Xmx4200m -XX:MaxDirectMemorySize=4g -Djava.util.prefs.userRoot=/nexus-data/javaprefs

