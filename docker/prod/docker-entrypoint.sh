#!/bin/bash
set -euo pipefail

# usage: file_env VAR [DEFAULT]
#    ie: file_env 'XYZ_DB_PASSWORD' 'example'
# (will allow for "$XYZ_DB_PASSWORD_FILE" to fill in the value of
#  "$XYZ_DB_PASSWORD" from a file, especially for Docker's secrets feature)
file_env() {
	local var="$1"
	local fileVar="${var}_FILE"
	local def="${2:-}"
	if [ "${!var:-}" ] && [ "${!fileVar:-}" ]; then
		echo >&2 "error: both $var and $fileVar are set (but are exclusive)"
		exit 1
	fi
	local val="$def"
	if [ "${!var:-}" ]; then
		val="${!var}"
	elif [ "${!fileVar:-}" ]; then
		val="$(< "${!fileVar}")"
	fi

	export "$var"="$val"
	unset "$fileVar"
}


# allow any of these "Authentication Unique Keys and Salts." to be specified via
# environment variables with a "WORDPRESS_" prefix (ie, "WORDPRESS_AUTH_KEY")
uniqueEnvs=(
    AUTH_KEY
    SECURE_AUTH_KEY
    LOGGED_IN_KEY
    NONCE_KEY
    AUTH_SALT
    SECURE_AUTH_SALT
    LOGGED_IN_SALT
    NONCE_SALT
)
envs=(
    MYSQL_HOST
    MYSQL_USER
    MYSQL_PASSWORD
    MYSQL_NAME
    "${uniqueEnvs[@]}"
    WP_ENV
    WP_HOME
    WP_SITEURL
)
haveConfig=
for e in "${envs[@]}"; do
    file_env "$e"
    if [ -z "$haveConfig" ] && [ -n "${!e}" ]; then
        haveConfig=1
    fi
done


# only touch "wp-config.php" if we have environment-supplied configuration values
if [ "$haveConfig" ]; then
    : "${MYSQL_HOST:=mysql}"
    : "${MYSQL_USER:=root}"
    : "${MYSQL_PASSWORD:=}"
    : "${MYSQL_NAME:=wordpress}"
    : "${DB_PREFIX:=wp_}"
    : "${WP_ENV:=development}"
    : "${WP_HOME:=localhost}"
    : "${WP_SITEURL:=${WP_HOME}/wp}"

    if [ ! -e .env ]; then
        touch .env
    fi
    chown -R www-data:www-data .

    set_config() {
        key="${1}"
        value="$2"
        echo "${key}=${value}" >> .env
    }

    set_config 'WP_HOME' "$WP_HOME"
    set_config 'WP_SITEURL' "$WP_HOME/wp"
    set_config 'DB_HOST' "$MYSQL_HOST"
    set_config 'DB_USER' "$MYSQL_USER"
    set_config 'DB_PASSWORD' "$MYSQL_PASSWORD"
    set_config 'DB_NAME' "$MYSQL_NAME"

    for unique in "${uniqueEnvs[@]}"; do
        uniqVar="${unique}"
        if [ -n "${!uniqVar}" ]; then
            set_config "$unique" "${!uniqVar}"
        else
            set_config "$unique" "$(head -c1m /dev/urandom | sha1sum | cut -d' ' -f1)"
        fi
    done

    if [ "$DB_PREFIX" ]; then
        set_config 'db_prefix' "$DB_PREFIX"
    fi

    if [ "$WP_ENV" ]; then
    set_config 'wp_env' "$WP_ENV"
    fi


	# now that we're definitely done writing configuration, let's clear out the relevant envrionment variables (so that stray "phpinfo()" calls don't leak secrets from our code)
	for e in "${envs[@]}"; do
		unset "$e"
	done
fi

exec "$@"