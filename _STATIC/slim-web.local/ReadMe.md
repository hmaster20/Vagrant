

cd C:\WPmultiTest
vagrant up

Добавьте в C:\Windows\System32\drivers\etc\hosts:

```shell
192.168.56.80 site1.webserver.local
192.168.56.80 site2.webserver.local
192.168.56.80 site3.webserver.local
```

Проверьте доступность:
Откройте в браузере: `http://site1.webserver.local`
Должна открыться установка WordPress

Проверка логов:

```bash
vagrant ssh
docker logs wp_site1
```

Если нужно изменить версии:
В docker-compose.yml замените теги образов (например, wordpress:6.7-php8.2-apache)
Для полного сброса:

```bash
vagrant destroy -f && vagrant up
```

## ⚠️ Важные нюансы

Права на файлы:
Если возникнут ошибки доступа, выполните в Vagrant:

```bash
vagrant ssh
sudo chown -R www-data:www-data /vagrant/sites
```

Первая установка WordPress:

При первом заходе на site1.webserver.local укажите:
База данных: wp_site1
Пользователь: wpuser
Пароль: wppass

Отключение кэширования на уровне PHP:
Чтобы гарантировать отсутствие кэша, добавьте в wp-config.php:

```php
define('WP_CACHE', false);
@ini_set('opcache.revalidate_freq', 0);
```
