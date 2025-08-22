<?php
/**
 * WordPress Configuration File for Plugin Development
 * Auto-generated for wp-multi-test environment
 */

// ** MySQL settings - from Docker environment variables ** //
/** The name of the database */
define( 'DB_NAME', getenv('WORDPRESS_DB_NAME') ?: 'wordpress' );

/** MySQL database username */
define( 'DB_USER', getenv('WORDPRESS_DB_USER') ?: 'wpuser' );

/** MySQL database password */
define( 'DB_PASSWORD', getenv('WORDPRESS_DB_PASSWORD') ?: 'wppass' );

/** MySQL hostname (container name in Docker network) */
define( 'DB_HOST', getenv('WORDPRESS_DB_HOST') ?: 'db' );

/** Database charset to use in creating database tables. */
define( 'DB_CHARSET', 'utf8' );

/** The database collate type. Don't change this if in doubt. */
define( 'DB_COLLATE', '' );

// ** Authentication Unique Keys and Salts ** //
// You can generate these using: https://api.wordpress.org/secret-key/1.1/salt/
define('AUTH_KEY',         'put-your-unique-auth-key-here');
define('SECURE_AUTH_KEY',  'put-your-unique-secure-auth-key-here');
define('LOGGED_IN_KEY',    'put-your-unique-logged-in-key-here');
define('NONCE_KEY',        'put-your-unique-nonce-key-here');
define('AUTH_SALT',        'put-your-unique-auth-salt-here');
define('SECURE_AUTH_SALT', 'put-your-unique-secure-auth-salt-here');
define('LOGGED_IN_SALT',   'put-your-unique-logged-in-salt-here');
define('NONCE_SALT',       'put-your-unique-nonce-salt-here');

// ** WordPress Database Table prefix ** //
$table_prefix = 'wp_';

// ** For development: Disable all caching ** //
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

// ** WordPress Localized Language (optional) ** //
// Set to empty string for default (English).
define( 'WPLANG', '' );

// ** Absolute path to the WordPress directory ** //
if ( ! defined( 'ABSPATH' ) ) {
    define( 'ABSPATH', __DIR__ . '/' );
}

// ** Bootstrap WordPress ** //
require_once ABSPATH . 'wp-settings.php';
