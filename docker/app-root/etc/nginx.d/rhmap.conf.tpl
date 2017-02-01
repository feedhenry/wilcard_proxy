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
        resolver ${DNS_SERVER} valid=30s;
        access_log /dev/stdout;

        ## Expose direct routes to applications running behind mbaas containers.
        ## Remap routes to subdomain part used internally by platform
        location ~* ^/([^/]+)(.*) {
            proxy_pass ${BASE_PROTOCOL}://$1.${BASE_HOST}$2$is_args$args;
            proxy_redirect ${BASE_PROTOCOL}://$1.${BASE_HOST} /$1;
            proxy_redirect / ${BASE_PROTOCOL}://$http_host/$1/;
            proxy_cookie_path / /$1;
        }

        ## Expose core platform millicore and security endpoints that are used to perform 
        ## Mobile app init (retrieving the actual app url basing on connection tag)
        location ^~ /box/srv/1.1/ {
            proxy_pass ${PLATFORM_URL}/$request_uri;
        }

        ## Expose core platform push functionalities
        location ^~ /api/v2/ag-push/ {
            proxy_pass ${PLATFORM_URL}/$request_uri;
        }

        location = /favicon.ico {
            log_not_found off;
        }

        location = / {
            root   /opt/app-root/src;
            try_files /index.html /index.html;
        }
    }
}