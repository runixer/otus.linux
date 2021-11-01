<?php
define( 'DB_NAME', '{{ wp_db_name }}' );
define( 'DB_USER', '{{ wp_db_user }}' );
define( 'DB_PASSWORD', '{{ wp_db_password }}' );
define( 'DB_HOST', '{{ wp_db_host }}' );
define( 'DB_CHARSET', 'utf8' );
define( 'DB_COLLATE', '' );

define( 'AUTH_KEY',         'put your unique phrase here' );
define( 'SECURE_AUTH_KEY',  'put your unique phrase here' );
define( 'LOGGED_IN_KEY',    'put your unique phrase here' );
define( 'NONCE_KEY',        'put your unique phrase here' );
define( 'AUTH_SALT',        'put your unique phrase here' );
define( 'SECURE_AUTH_SALT', 'put your unique phrase here' );
define( 'LOGGED_IN_SALT',   'put your unique phrase here' );
define( 'NONCE_SALT',       'put your unique phrase here' );

define( 'FS_METHOD','direct');
define( 'CONCATENATE_SCRIPTS', false );

# https://wordpress.org/support/article/debugging-in-wordpress/
# Logging configured in php-fpm
define( 'WP_DEBUG', true );
#define( 'WP_DEBUG_LOG', true );
define( 'WP_DEBUG_DISPLAY', false );

define( 'WP_SITEURL', 'https://otus.internal' );

$table_prefix = 'wp_';
if ( ! defined( 'ABSPATH' ) ) {
        define( 'ABSPATH', __DIR__ . '/' );
}
require_once ABSPATH . 'wp-settings.php';
