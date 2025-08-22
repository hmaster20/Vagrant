# Структура проекта

```shell
wp-multi-test/
├── Vagrantfile
├── sites/
│   ├── site1/                  # Стандартная установка WordPress
│   │   └── wp-content/
│   │       └── plugins/
│   │           └── WpQuiz/     # ← ПЛАГИН (редактируем здесь)
│   ├── site2/                  # Аналогично
│   └── site3/                  # Аналогично
└── docker-compose.yml          # Обновленная конфигурация
```



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

---

Ниже приведён полный шаблон `wp-config.php`, оптимизированный для разработки плагина в вашем окружении (Vagrant + Docker, без кэширования, с мгновенным отображением изменений).

Этот файл можно скопировать в каждый сайт (`site1`, `site2`, `site3`) по умолчанию — он подходит для всех трёх экземпляров, так как переменные окружения (`WORDPRESS_DB_*`) передаются через Docker Compose.

---

### ✅ `wp-config.php` (универсальный шаблон для всех сайтов)

```php
<?php
/
 * WordPress Configuration File for Plugin Development
 * Auto-generated for wp-multi-test environment
 */

//  MySQL settings - from Docker environment variables  //
/ The name of the database */
define( 'DB_NAME', getenv('WORDPRESS_DB_NAME') ?: 'wordpress' );

/ MySQL database username */
define( 'DB_USER', getenv('WORDPRESS_DB_USER') ?: 'wpuser' );

/ MySQL database password */
define( 'DB_PASSWORD', getenv('WORDPRESS_DB_PASSWORD') ?: 'wppass' );

/ MySQL hostname (container name in Docker network) */
define( 'DB_HOST', getenv('WORDPRESS_DB_HOST') ?: 'db' );

/ Database charset to use in creating database tables. */
define( 'DB_CHARSET', 'utf8' );

/ The database collate type. Don't change this if in doubt. */
define( 'DB_COLLATE', '' );

//  Authentication Unique Keys and Salts  //
// You can generate these using: https://api.wordpress.org/secret-key/1.1/salt/
define('AUTH_KEY',         'put-your-unique-auth-key-here');
define('SECURE_AUTH_KEY',  'put-your-unique-secure-auth-key-here');
define('LOGGED_IN_KEY',    'put-your-unique-logged-in-key-here');
define('NONCE_KEY',        'put-your-unique-nonce-key-here');
define('AUTH_SALT',        'put-your-unique-auth-salt-here');
define('SECURE_AUTH_SALT', 'put-your-unique-secure-auth-salt-here');
define('LOGGED_IN_SALT',   'put-your-unique-logged-in-salt-here');
define('NONCE_SALT',       'put-your-unique-nonce-salt-here');

//  WordPress Database Table prefix  //
$table_prefix = 'wp_';

//  For development: Disable all caching  //
// ----------------------------------------------------------------------
define( 'WP_CACHE', false );
define( 'WP_DEBUG', true );
define( 'WP_DEBUG_LOG', true );
define( 'WP_DEBUG_DISPLAY', true );
define( 'SCRIPT_DEBUG', true );
define( 'SAVEQUERIES', true );

// Отключаем кэширование на уровне PHP (OPcache)
@ini_set('opcache.revalidate_freq', 0);
@ini_set('opcache.validate_timestamps', 1);
@ini_set('opcache.max_accelerated_files', 20000);
@ini_set('opcache.memory_consumption', '192');
@ini_set('opcache.interned_strings_buffer', '16');
@ini_set('opcache.fast_shutdown', '1');

// Отключаем автоматическое обновление
define( 'AUTOMATIC_UPDATER_DISABLED', true );
define( 'WP_AUTO_UPDATE_CORE', false );

// Отключаем ревизии (опционально, чтобы не засорять БД)
define( 'WP_POST_REVISIONS', false );

// Максимальный размер медиа (опционально)
@ini_set('upload_max_filesize', '64M');
@ini_set('post_max_size', '64M');

//  WordPress Localized Language (optional)  //
// Set to empty string for default (English).
define( 'WPLANG', '' );

//  Absolute path to the WordPress directory  //
if ( ! defined( 'ABSPATH' ) ) {
    define( 'ABSPATH', __DIR__ . '/' );
}

//  Bootstrap WordPress  //
require_once ABSPATH . 'wp-settings.php';
```

---

### 📁 Куда положить этот файл?

Для каждого сайта:

```shell
wp-multi-test/
└── sites/
    ├── site1/
    │   └── wp-config.php   ← этот файл
    ├── site2/
    │   └── wp-config.php   ← этот файл
    └── site3/
        └── wp-config.php   ← этот файл
```

> ✅ Все три файла идентичны — WordPress будет использовать переменные из Docker (`WORDPRESS_DB_*`), а не жёстко прописанные значения.

---

### 🔐 Где взять уникальные ключи (AUTH_KEY и т.д.)?

Замените строки вида `'put-your-unique-auth-key-here'` на реальные значения с официального генератора:

👉 [https://api.wordpress.org/secret-key/1.1/salt/](https://api.wordpress.org/secret-key/1.1/salt/)

Скопируйте 8 строк и вставьте вместо текущих. Пример:

```php
define('AUTH_KEY',         'tT`@ZrUHs-+aVzYvZx2qX!v9A#kLmNpQrStUvWxYz1#');
define('SECURE_AUTH_KEY',  'aB2cD4eF6gH8iJ0kL2mN4oP6qR8sT0uV2wX4yZ6aB8');
// ... и так далее
```

---

### 🔧 Что делает этот конфиг?

| Настройка                         | Назначение                                     |
|-----------------------------------|------------------------------------------------|
| `WP_DEBUG = true`                 | Показывает PHP-ошибки и предупреждения         |
| `SCRIPT_DEBUG = true`             | Использует несжатые версии JS/CSS              |
| `opcache.validate_timestamps = 1` | PHP-файлы перезагружаются при каждом изменении |
| `SAVEQUERIES = true`              | Полезно для отладки SQL                        |
| `AUTOMATIC_UPDATER_DISABLED`      | Запрещает автообновления                       |
| `ABSPATH` и `wp-settings.php`     | Стандартная инициализация WordPress            |

---

### ✅ Проверка после установки

1. Запустите `vagrant up`
2. Откройте `http://site1.webserver.local`
3. Убедитесь, что:
   - WordPress видит ваш плагин `WpQuiz`
   - При редактировании файлов плагина на Windows — изменения мгновенно видны
   - В консоли браузера нет 404 на JS/CSS (если есть — включите `SCRIPT_DEBUG`)
   - Нет ошибок PHP (если есть — они будут отображаться на экране)

---

Готово! Этот `wp-config.php` — идеальный выбор для разработки плагинов в вашем окружении: он отключает все формы кэширования, показывает ошибки и работает стабильно в Docker.
