#!/usr/bin/env bash

. /etc/profile
. /usr/local/bin/docker-entrypoint-functions.sh

MYUSER="${APPUSER}"
MYUID="${APPUID}"
MYGID="${APPGID}"
MYPHPFPMURL="php-fpm:9000"
MYFCGIURL="fcgi:9001"
MYSSL="0"
MYVHOST="default"
MYUPSTREAMURL="myupstream:80"

ConfigureUser

if [ "${1}" == 'nginx' ]; then
  MYSSLEXT=""
  if [ -n  "${DOCKUPSTREAMURL}" ]; then
    MYUPSTREAMURL="${DOCKUPSTREAMURL}"
  fi
  if [ -n  "${DOCKPHPFPMURL}" ]; then
    MYPHPFPMURL="${DOCKPHPFPMURL}"
  fi
  if [ -n  "${DOCKFCGIURL}" ]; then
    MYFCGIURL="${DOCKFCGIURL}"
  fi
  if [ -n  "${DOCKSSL}" ]; then
    MYSSL="${DOCKSSL}"
  fi
  if [ -n  "${DOCKVHOST}" ]; then
    MYVHOST="${DOCKVHOST}"
  fi

  if [ "${MYSSL}" == '1' ]; then
    MYSSLEXT="https"
  elif [ "${MYSSL}" == '0' ]; then
    MYSSLEXT="http"
  else
    DockLog "ERROR: DOCKSSL value not supported, please check and try again."
    exit 1
  fi

  DockLog "Disabling all vhosts"
  rm -rf /etc/nginx/vhost-enabled/*


  case "$MYVHOST" in
    default)
      DockLog "Enabling vhost: 00-default-${MYSSLEXT}"
      cp /etc/nginx/vhost-disabled/00-default-${MYSSLEXT}.conf /etc/nginx/vhost-enabled/
      ;;
    php)
      DockLog "Enabling vhost: 01-php-${MYSSLEXT}"
      cp /etc/nginx/vhost-disabled/01-php-${MYSSLEXT}.conf /etc/nginx/vhost-enabled/
      DockLog "Setting php-fpm URL to ${MYPHPFPMURL}"
      sed -i \
        -e "s|localhost:9000|${MYPHPFPMURL}|g" \
      /etc/nginx/vhost-enabled/01-php-${MYSSLEXT}.conf
      ;;
    symfony3-prd)
      DockLog "Enabling vhost: 02-symfony3-prd-${MYSSLEXT}"
      cp /etc/nginx/vhost-disabled/02-symfony3-prd-${MYSSLEXT}.conf /etc/nginx/vhost-enabled/
      DockLog "Setting php-fpm URL to ${MYPHPFPMURL}"
      sed -i \
        -e "s|localhost:9000|${MYPHPFPMURL}|g" \
      /etc/nginx/vhost-enabled/02-symfony3-prd-${MYSSLEXT}.conf
      ;;
    symfony3-dev)
      DockLog "Enabling vhost: 03-symfony3-dev-${MYSSLEXT}"
      cp /etc/nginx/vhost-disabled/03-symfony3-dev-${MYSSLEXT}.conf /etc/nginx/vhost-enabled/
      DockLog "Setting php-fpm URL to ${MYPHPFPMURL}"
      sed -i \
        -e "s|localhost:9000|${MYPHPFPMURL}|g" \
      /etc/nginx/vhost-enabled/03-symfony3-dev-${MYSSLEXT}.conf
      ;;
    symfony4)
      DockLog "Enabling vhost: 02-symfony4-${MYSSLEXT}"
      cp /etc/nginx/vhost-disabled/02-symfony4-${MYSSLEXT}.conf /etc/nginx/vhost-enabled/
      DockLog "Setting php-fpm URL to ${MYPHPFPMURL}"
      sed -i \
        -e "s|localhost:9000|${MYPHPFPMURL}|g" \
      /etc/nginx/vhost-enabled/02-symfony4-${MYSSLEXT}.conf
      if [ ! -d /var/www/html/default/public ]
      then
        mkdir -p /var/www/html/default/public
      fi
      ;;
    angular)
      DockLog "Enabling vhost: 04-angular-${MYSSLEXT}"
      cp /etc/nginx/vhost-disabled/04-angular-${MYSSLEXT}.conf /etc/nginx/vhost-enabled/
      ;;
    grav)
      DockLog "Enabling vhost: 05-grav-${MYSSLEXT}"
      cp /etc/nginx/vhost-disabled/05-grav-${MYSSLEXT}.conf /etc/nginx/vhost-enabled/
      sed -i \
        -e "s|localhost:9000|${MYPHPFPMURL}|g" \
      /etc/nginx/vhost-enabled/05-grav-${MYSSLEXT}.conf
      ;;
    fcgi)
      DockLog "Enabling vhost: 06-fcgi-${MYSSLEXT}"
      cp /etc/nginx/vhost-disabled/06-fcgi-${MYSSLEXT}.conf /etc/nginx/vhost-enabled/
      sed -i \
        -e "s|localhost:9001|${MYFCGIURL}|g" \
      /etc/nginx/vhost-enabled/06-fcgi-${MYSSLEXT}.conf
      ;;
    nextcloud)
      DockLog "Enabling vhost: 08-nextcloud-${MYSSLEXT}"
      cp /etc/nginx/vhost-disabled/08-nextcloud-${MYSSLEXT}.conf /etc/nginx/vhost-enabled/
      DockLog "Setting php-fpm URL to ${MYPHPFPMURL}"
      sed -i \
        -e "s|localhost:9000|${MYPHPFPMURL}|g" \
      /etc/nginx/vhost-enabled/08-nextcloud-${MYSSLEXT}.conf
      ;;
    proxy)
      DockLog "Enabling vhost: 09-proxy-${MYSSLEXT}"
      cp /etc/nginx/vhost-disabled/09-proxy-${MYSSLEXT}.conf /etc/nginx/vhost-enabled/
      DockLog "Setting upstream URL to ${MYUPSTREAMURL}"
      sed -i \
        -e "s|localhost:80|${MYUPSTREAMURL}|g" \
      /etc/nginx/vhost-enabled/09-proxy-${MYSSLEXT}.conf
      ;;
    spotweb)
      DockLog "Enabling vhost: 10-spotweb-${MYSSLEXT}"
      cp /etc/nginx/vhost-disabled/10-spotweb-${MYSSLEXT}.conf /etc/nginx/vhost-enabled/
      DockLog "Setting php-fpm URL to ${MYPHPFPMURL}"
      sed -i \
        -e "s|localhost:9000|${MYPHPFPMURL}|g" \
      /etc/nginx/vhost-enabled/10-spotweb-${MYSSLEXT}.conf
      ;;
    mediawiki)
      DockLog "Enabling vhost: 11-mediawiki-${MYSSLEXT}"
      cp /etc/nginx/vhost-disabled/11-mediawiki-${MYSSLEXT}.conf /etc/nginx/vhost-enabled/
      DockLog "Setting php-fpm URL to ${MYPHPFPMURL}"
      sed -i \
        -e "s|localhost:9000|${MYPHPFPMURL}|g" \
      /etc/nginx/vhost-enabled/11-mediawiki-${MYSSLEXT}.conf
      ;;
    proxycache)
      DockLog "Enabling vhost: 12-proxycache-${MYSSLEXT}"
      cp /etc/nginx/vhost-disabled/12-proxycache-${MYSSLEXT}.conf /etc/nginx/vhost-enabled/
      DockLog "Setting upstream URL to ${MYUPSTREAMURL}"
      sed -i \
        -e "s|localhost:80|${MYUPSTREAMURL}|g" \
      /etc/nginx/vhost-enabled/12-proxycache-${MYSSLEXT}.conf
      mkdir /tmp/nginx/cache
      chown -R "${MYUSER}" /tmp/nginx
      ;;
    custom)
      DockLog "Enabling vhost: 07-custom-${MYSSLEXT}"
      if [ -f /docker-entrypoint.d/07-custom-${MYSSLEXT}.conf ]; then
        cp /docker-entrypoint.d/07-custom-${MYSSLEXT}.conf /etc/nginx/vhost-enabled/
      else
        DockLog "ERROR: /docker-entrypoint.d/07-custom-${MYSSLEXT}.conf not found"
	      exit 1
      fi
      ;;
    *)
      DockLog "ERROR: DOCKVHOST value not supported, please check and try again."
      exit 1
      ;;
  esac

  RunDropletEntrypoint

  DockLog "Setting permissions on /etc/nginx"
  chown -R root:root /etc/nginx
  DockLog "Setting permissions on /var/www/html/default"
  chown -R "${MYUSER}" /var/www/html/default

  DockLog "Starting app: ${1}"
  exec nginx -c /etc/nginx/nginx.conf -g 'daemon off;'
else
  exec "$@"
fi
