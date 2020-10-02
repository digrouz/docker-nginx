# docker-nginx
Installs NGINX into an CentOS Linux container

![nginx](https://assets.wp.nginx.com/wp-content/themes/nginx-theme/assets/img//logo.png)

## Description

Nginx is software to provide a web server. It can act as a reverse proxy server for TCP, UDP, HTTP, HTTPS, SMTP, POP3, and IMAP protocols, as well as a load balancer and an HTTP cache.


http://nginx.org/

## Usage

    docker create --name=nginx  \
      -v /etc/localtime:/etc/localtime:ro \
      -v <path to webroot>:/var/www/html/default \
      -v <path to nginx logs>:/var/log/nginx  \
      -e DOCKUID=<UID default:10002> \
      -e DOCKGID=<GID default:10002> \
      -e DOCKPHPFPMURL=<url-to-php-fpm default:php-fpm:9000> \
      -e DOCKFCGIURL=<url-to-fastcgi default:fcgi:9001> \
      -e DOCKSSL=<0|1 default:0> \
      -e DOCKVHOST<default|php|symfony3-dev|symfony3-prd|symfony4|angular|grav|fcgi|nextcloud|custom default:default>
      -p 80:80 \
      -p 443:443 docker/docker-nginx

## Environment Variables

When you start the `nginx` image, you can adjust the configuration of the `nginx` instance by passing one or more environment variables on the `docker run` command line.

### `DOCKUID`

This variable is not mandatory and specifies the user id that will be set to run the application. It has default value `10002`.

### `DOCKGID`

This variable is not mandatory and specifies the group id that will be set to run the application. It has default value `10002`.

### `DOCKPHPFPMURL`

This variable is not mandatory and specifies the URL of a PHP FPM server. It has default value `php-fpm:9000`.

### `DOCKFCGIURL`

This variable is not mandatory and specifies the URL of a FastCGI server. It has default value `fcgi:9001`.

### `DOCKSSL`

This variable is not mandatory and specifies if the configured vhost will serve through https or http. It has default value `0`.

### `DOCKVHOST`

This variable is not mandatory and specifies to the entrypoint which vhost to configure. Valid values are `default`, `php`, `symfony3-dev`, `symfony3-prd`, `symfony4` and `angular`. It has default value `default`.
* `default` will configure a vhost to serve static files.
* `php` will configure a vhost that support php-fpm.
* `symfony3-prd` will configure a vhost with support for symfony 3 production environment.
* `symfony3-dev` will configure a vhost with support for symfony 3 development environment.
* `symfony4` will configure a vhost with support for symfony 4 environment.
* `angular` will configure a vhost with support for angular.
* `grav` will configure a vhost with support for grav CMS.
* `fcgi` will configure a vhost with support for FastCGI like spawn-fcgi.
* `nextcloud` will configure a vhost with support for Nextcloud
* `custom` will configure a vhost from a provided vhost config file `/docker-entrypoint.d/07-custom-http(s).conf`

## Notes

* The integrated nginx configuration redirects http to https and vice-versa depending the value of `DOCKSSL`.
* The https vhost is using an autosigned certificate.
* The image a builtin support for php-fpm, To correct the php-fpm destination, just add `-e DOCKPHPFPMURL=<url-to-php-fpm>` at container creation.
* Avoiding to define `DOCKSSL` will result to let the entrypoint configure nginx with a regular vhost without SSL support.
* Avoiding to define `DOCKVHOST` will result to let the entrypoint configure nginx with a regular vhost without support php-fpm.
* The image supports adding bash droplets in /docker-entrypoint.d that will be launched at start up just before the launch of nginx.
