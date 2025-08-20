# How to setup Traefik v2 with automatic Let’s Encrypt certificate resolver

## Today it is really important to have SSL encrypted websites. This guide will show how easy it is to have an automatic SSL resolver built into your traefik load balancer.

[After I learned how to docker](https://medium.com/geekculture/beginner-friendly-introduction-into-devops-with-docker-on-windows-6aac2de2db33), the next thing I needed was a service to help me organize my websites. This is why I learned about [traefik](https://traefik.io/) which is a:

> Cloud-Native Networking Stack That Just Works

One important feature of _traefik_ is the ability to create [Let’s Encrypt](https://letsencrypt.org/) SSL certificates automatically for every domain which is managed by _traefik_.

Then I started to research…

Me sitting in front of my computer researching

I tested several configurations and created my own _traefik_ instances on my local machine until I came up with this docker-compose.yml:

```yaml
version: "3.3"
services:
  traefik:
    image: "traefik:v2.2.1"
    container_name: traefik
    hostname: traefik
    command:
      - --entrypoints.web.address=:80
      - --entrypoints.websecure.address=:443
      - --providers.docker
      - --providers.docker.exposedByDefault=false
      - --api
      - --certificatesresolvers.le.acme.email=${TRAEFIK_SSLEMAIL?Variable not set}
      - --certificatesresolvers.le.acme.storage=./acme.json
      - --certificatesresolvers.le.acme.tlschallenge=true
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - "/var/run/docker.sock:/var/run/docker.sock:ro"
      - "./acme.json:/acme.json"
    labels:
      - "traefik.enable=true"
      # Dashboard
      - "traefik.http.routers.traefik.rule=Host(`dashboard.${PRIMARY_DOMAIN}`)"
      - "traefik.http.routers.traefik.service=api@internal"
      - "traefik.http.routers.traefik.tls=true"
      - "traefik.http.routers.traefik.tls.certresolver=le"
      - "traefik.http.routers.traefik.entrypoints=websecure"
      - "traefik.http.routers.traefik.middlewares=authtraefik"
      - "traefik.http.middlewares.authtraefik.basicauth.users=devAdmin:$$2y$$05$$h9OxLeY20/5uiXjfPgdRxuFlrfqBf2QifYDgrwsR6rAEgX3/dpOGq" # user:devAdmin, password:devto
      # global redirect to https
      - "traefik.http.routers.http-catchall.rule=hostregexp(`{host:.+}`)"
      - "traefik.http.routers.http-catchall.entrypoints=web"
      - "traefik.http.routers.http-catchall.middlewares=redirect-to-https"
      # middleware redirect
      - "traefik.http.middlewares.redirect-to-https.redirectscheme.scheme=https"
    restart: unless-stopped
    networks:
      - traefik-public
  my-app:
    image: containous/whoami:v1.3.0
    hostname: whoami
    container_name: whoami
    restart: unless-stopped
    labels:
      - "traefik.enable=true"
      - "traefik.http.routers.my-app.rule=Host(`whoami.${PRIMARY_DOMAIN}`)"
      - "traefik.http.routers.my-app.middlewares=auth"
      - "traefik.http.routers.my-app.entrypoints=websecure"
      - "traefik.http.routers.my-app.tls=true"
      - "traefik.http.routers.my-app.tls.certresolver=le"
      - "traefik.http.middlewares.authtraefik.basicauth.users=devAdmin:$$2y$$05$$h9OxLeY20/5uiXjfPgdRxuFlrfqBf2QifYDgrwsR6rAEgX3/dpOGq" # user:devAdmin, password:devto
    networks:
      - traefik-public:
networks:
  traefik-public:
    external: true
```

[docker-compose.traefik.yml](https://gist.github.com/paulknulst/68e5e63badaa6a9ac80b4227ca07baee#file-docker-compose-traefik-yml) hosted with ❤ by [GitHub](https://github.com/)

This file contains several important sections:

1.  Two entry points `web` (_Line 8_) and `websecure` (_Line 9_) which are used for `http` and `https`
2.  Enabling docker (_Line 10_) but not publishing every container by default (_Line 11_)
3.  Activate API (with URL defined in labels) (_Line 12_)
4.  Certificate handling. Defining an info email (_Line 13_), set a storage `acme.json` (_Line 14_), activating TLS (_Line 15_)
5.  Exposing port for HTTP (_Line 17_) and HTTPS (_Line 18_)
6.  Within the volumes section, the docker-socket will be mounted into `traefik` container (_Line 20_) and the `acme.json` is mounted into the local filesystem (_Line 21_)
7.  Enable `traefik` for this service (_Line 23_). This has to be done because no service is exported by default (_see Line 11_)
8.  Add the dashboard domain (_Line 25_), define a service (_Line 26_), activate TLS (_Line 27_) with prior defined certificate resolver (_Line 28_), and set the `websecure` entry point (_Line 29_)
9.  Activate _HTTP - Basic Auth_ middleware (_Line 30_)which will be “_created_” in the next line
10.  Creating the `traefik` dashboard which is encrypted with _HTTP - Basic Auth_ (_Line 31_)
11.  Global redirect to HTTPS is defined and activation of the middleware (_Line 32 - 37_)
12.  To test I defined another service `whoami` just to show some data and test the SSL certificate creation (_Line 41 - Line 55_)

Before running the docker-compose.yml a network has to be created! This is necessary because within the file an external network is used (Line 56–58). This is important because the external network `traefik-public` will be used between different services.

The external network is created with:

docker create network traefik-public

The last step is exporting the needed variables and running the `docker-compose.yml`:

export PRIMARY_DOMAIN=yourdomain.de  
export TRAEFIK_SSLEMAIL=youremai@yourdomain.de  
  
docker-compose up -d

The commands above will now create two new subdomains (https://dashboard.yourdomain.de and [https://whoami.yourdomain.de)](https://whoami.yourdomain.de%29/) which also uses an SSL certificate provided by Let’s Encrypt

![](https://miro.medium.com/max/875/0*qpZJXYW1tZkpqRVg)

# Closing Notes

I hope this article gave you a quick and neat overview of how to set up _traefik_

Code-wise a lot of improvements can be made. However, with the current very limited functionality it is enough. It is more about customizing new commands, but always focusing on the least amount of sources for truth.

Happy Dockering! 🥳 👨🏻‍💻

[Original](https://levelup.gitconnected.com/how-to-setup-traefik-v2-with-automatic-lets-encrypt-certificate-resolver-83de0ed0f542)

[More baout traefic](https://doc.traefik.io/traefik/v1.7/user-guide/docker-and-lets-encrypt/)
