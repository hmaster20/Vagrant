# Создаем WildCard от Let’s Encrypt

```shell

# Для начала нам необходимо установить утилиту CertBot
sudo apt-add-repository -r ppa:certbot/certbot
sudo apt update
sudo apt-get update
sudo apt-get install python3-certbot-nginx

# Проверка функционирования механизма создания сертификатов
sudo certbot --dry-run --manual --agree-tos --preferred-challenges dns certonly --server https://acme-v02.api.letsencrypt.org/directory -d *.it-enginer.ru -d it-enginer.ru

Saving debug log to /var/log/letsencrypt/letsencrypt.log
Plugins selected: Authenticator manual, Installer None
Obtaining a new certificate
Performing the following challenges:
dns-01 challenge for it-enginer.ru
dns-01 challenge for it-enginer.ru

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
NOTE: The IP of this machine will be publicly logged as having requested this
certificate. If you're running certbot in manual mode on a machine that is not
your server, please ensure you're okay with that.

Are you OK with your IP being logged?
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
(Y)es/(N)o: y


# Проверка публикации записей в DNS серверах
dig -t txt _acme-challenge.it-enginer.ru
dig @8.8.8.8 -t txt _acme-challenge.it-enginer.ru


# Выполняем создание сертификата
sudo certbot --manual --agree-tos --manual-public-ip-logging-ok --preferred-challenges dns certonly --server https://acme-v02.api.letsencrypt.org/directory -d *.it-enginer.ru -d it-enginer.ru


Saving debug log to /var/log/letsencrypt/letsencrypt.log

Plugins selected: Authenticator manual, Installer None
Enter email address (used for urgent renewal and security notices) (Enter 'c' to cancel): hmaster20@gmail.com
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
Would you be willing to share your email address with the Electronic Frontier
Foundation, a founding partner of the Let's Encrypt project and the non-profit
organization that develops Certbot? We'd like to send you email about our work
encrypting the web, EFF news, campaigns, and ways to support digital freedom.
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
(Y)es/(N)o: n
 - Congratulations! Your certificate and chain have been saved at:
   /etc/letsencrypt/live/it-enginer.ru/fullchain.pem
   Your key file has been saved at:
   /etc/letsencrypt/live/it-enginer.ru/privkey.pem
   Your cert will expire on 2023-05-05. To obtain a new or tweaked
   version of this certificate in the future, simply run certbot
   again. To non-interactively renew *all* of your certificates, run
   "certbot renew"
 - Your account credentials have been saved in your Certbot
   configuration directory at /etc/letsencrypt. You should make a
   secure backup of this folder now. This configuration directory will
   also contain certificates and private keys obtained by Certbot so
   making regular backups of this folder is ideal.

```

---

## Обновление сертификата для сайта

```shell
# Проверка механизма создания сертификатов
sudo certbot --dry-run --manual --agree-tos --preferred-challenges dns certonly --server https://acme-v02.api.letsencrypt.org/directory -d *.it-enginer.ru -d it-enginer.ru

# Выпуск сертификата
sudo certbot --manual --agree-tos --manual-public-ip-logging-ok --preferred-challenges dns certonly --server https://acme-v02.api.letsencrypt.org/directory -d *.it-enginer.ru -d it-enginer.ru

```

---

## Прочее

```shell
# nginx
sudo nano /etc/nginx/site-available/obu4alka-ssl.conf
server_name obu4alka.ru *.obu4alka.ru;

ssl_certificate /etc/letsencrypt/live/obu4alka.ru-0001/fullchain.pem; ssl_trusted_certificate /etc/letsencrypt/live/obu4alka.ru-0001/fullchain.pem; ssl_certificate_key /etc/letsencrypt/live/obu4alka.ru-0001/privkey.pem;

nginx -t
sudo /etc/init.d/nginx restart

Теперь Nginx настроен на обработку поддоменов третьего уровня с WildCard сертификатом.
```

## Ошибка при обновлении сертификата wildcard от Let`s Encrypt

При обновлении wildcard сертификата certbot категарически не хотел обновлять данные сертификаты. Терминал выдал мне следующее:

```shell
All renewal attempts failed. The following certs could not be renewed:
  /etc/letsencrypt/live/obu4alka.ru-0001/fullchain.pem (failure)
  /etc/letsencrypt/live/obu4alka.ru-0002/fullchain.pem (failure)
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
2 renew failure(s), 0 parse failure(s)
```

Решение было найдено после 4 часов изучение интернета. Опишу все процедуры к которым я прибегал. Может кому помогут.

После долгих мучений я решил удалить конфиги и директории
`/etc/letsencrypt/live`
`/etc/letsencrypt/archive`
`/etc/letsencrypt/renewal`
А далее переходим к созданию сертификата заново

## Настройка автопродления сертификатов

Создаем исполняемый bash скрипт и открываем на редактирование:

```shell
sudo touch /etc/cron.weekly/cert-nginx && sudo chmod +x /etc/cron.weekly/cert-nginx && sudo nano /etc/cron.weekly/cert-nginx
```

Следующего содержания:

```shell
#!/bin/bash
/usr/bin/certbot renew --post-hook "service nginx reload"
```

В результате каждую неделю скрипт будет запускаться и проверять необходимость обновления сертификатов. В случае такой необходимости сертификаты автоматически будут обновлены и будет запущен хук обновляющий конфигурацию сервера nginx (в моём случае)

---

[Original](https://obu4alka.ru/free-wildcard-lets-encrypt.html)
