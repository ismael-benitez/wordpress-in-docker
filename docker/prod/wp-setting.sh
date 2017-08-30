#!/bin/bash
set -euo pipefail

while getopts u: option
do
 case "${option}"
 in
 u) url=${OPTARG};;
 esac
done

set_secret() {
    local key="$1"
    local value="$2"

    echo $value | docker secret create $key -
}

declare keys=(
    AUTH_KEY
    SECURE_AUTH_KEY
    LOGGED_IN_KEY
    NONCE_KEY
    AUTH_SALT
    SECURE_AUTH_SALT
    LOGGED_IN_SALT
    NONCE_SALT
)

declare passwords=(
    MYSQL_ROOT_PASSWORD
    MYSQL_PASSWORD
)

declare -A configs=(
    [WP_HOME]="$url"
    [WP_ENV]="production"
    [MYSQL_HOST]="mysql"
    [MYSQL_DATABASE]="wordpress"
    [MYSQL_USER]="wordpress"
)


for key in "${keys[@]}"; do
    set_secret "$key" "$(head -c1m /dev/urandom | sha1sum | cut -d' ' -f1)"
done

for password in "${passwords[@]}"; do
    set_secret "$password" "$(openssl rand -base64 20)"
done

for i in "${!configs[@]}"; do
	set_secret "$i" "${configs[$i]}"
done

