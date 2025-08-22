<?php
// Определяем сайт по HTTP-заголовку Host
$host = $_SERVER['HTTP_HOST'] ?? 'site1.webserver.local';

switch ($host) {
    case 'site1.webserver.local':
        define('DB_NAME', 'wp_site1');
        define('WP_HOME', 'http://site1.webserver.local');
        define('WP_SITEURL', 'http://site1.webserver.local');
        break;
    case 'site2.webserver.local':
        define('DB_NAME', 'wp_site2');
        define('WP_HOME', 'http://site2.webserver.local');
        define('WP_SITEURL', 'http://site2.webserver.local');
        break;
    case 'site3.webserver.local':
        define('DB_NAME', 'wp_site3');
        define('WP_HOME', 'http://site3.webserver.local');
        define('WP_SITEURL', 'http://site3.webserver.local');
        break;
    default:
        define('DB_NAME', 'wp_site1');
        define('WP_HOME', 'http://site1.webserver.local');
        define('WP_SITEURL', 'http://site1.webserver.local');
}

// Общие настройки для всех сайтов
define('DB_USER', 'wpuser');
define('DB_PASSWORD', 'wppass');
define('DB_HOST', 'db');
define('DB_CHARSET', 'utf8');
define('DB_COLLATE', '');

// Соли — лучше сгенерировать уникальные
define('AUTH_KEY',         'put-your-unique-auth-key-here');
define('SECURE_AUTH_KEY',  'put-your-unique-secure-auth-key-here');
define('LOGGED_IN_KEY',    'put-your-unique-logged-in-key-here');
define('NONCE_KEY',        'put-your-unique-nonce-key-here');
define('AUTH_SALT',        'put-your-unique-auth-salt-here');
define('SECURE_AUTH_SALT', 'put-your-unique-secure-auth-salt-here');
define('LOGGED_IN_SALT',   'put-your-unique-logged-in-salt-here');
define('NONCE_SALT',       'put-your-unique-nonce-salt-here');

$table_prefix = 'wp_';

// Режим разработки
define('WP_DEBUG', true);
define('WP_DEBUG_LOG', true);
define('WP_DEBUG_DISPLAY', true);
define('SCRIPT_DEBUG', true);
define('SAVEQUERIES', true);
define('WP_CACHE', false);

// Отключаем автообновления
define('AUTOMATIC_UPDATER_DISABLED', true);
define('WP_AUTO_UPDATE_CORE', false);

// Ревизии и загрузки
define('WP_POST_REVISIONS', false);
@ini_set('upload_max_filesize', '64M');
@ini_set('post_max_size', '64M');

// Путь к WordPress
if (!defined('ABSPATH')) {
    define('ABSPATH', __DIR__ . '/');
}

require_once ABSPATH . 'wp-settings.php';
