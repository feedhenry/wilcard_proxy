daemon off;
pid /var/opt/rh/rh-nginx18/run/nginx/nginx.pid;

events {
    worker_connections  1024;
}
error_log stderr ${LOG_LEVEL};

http {
    include       /etc/opt/rh/rh-nginx18/nginx/mime.types;
    default_type  application/octet-stream;

    log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
                      '$status $body_bytes_sent "$http_referer" '
                      '"$http_user_agent" "$http_x_forwarded_for"';

    server {
        include $NGINX_CONFIGURATION_PATH/proxy.conf;
        listen 8080 default_server;
        resolver ${DNS_SERVER};
        access_log /dev/stdout;

        ## Expose core platform millicore and security endpoints that are used to perform 
        ## Mobile app init (retrieving the actual app url basing on connection tag)
        location ~* ^/core/([^/]+)${RHMAP_PLATFORM_PATH}(.*) {
            proxy_pass https://$1.${BASE_HOST}${RHMAP_PLATFORM_PATH}$2$is_args$args;
            proxy_redirect ${BASE_HOST} https://$http_host/core/$1;
            proxy_cookie_path / /core/$1;
        }

        ## Expose url to external mbaas component used when setting up nginx proxy on separate mbaas
        ## Core would need to call mbaas metrics endpoints to determine if it's working properly.
        location ~* ^/mbaas/([^/]+)/(.*) {
            proxy_pass https://$1.${BASE_HOST}/$2$is_args$args;
            proxy_redirect ${BASE_HOST} /mbaas/$1;
            proxy_cookie_path / /mbaas/$1;
        }

        ## Expose direct routes to applications running behind mbaas containers.
        ## Remap routes to subdomain part used internally by platform
        location ~* ^/app/([^/]+)/(.*) {
            proxy_pass https://$1.${BASE_HOST}/$2$is_args$args;
            proxy_redirect https://$1.${BASE_HOST} /app/$1;
            proxy_redirect / http://$http_host/app/$1/;
            proxy_cookie_path / /app/$1;
        }

        location = /favicon.ico {
            log_not_found off;
        }

        location / {
            root   /opt/app-root/src;
            index  index.html;
        }
    }
}