FROM centos/nginx-18-centos7

LABEL com.redhat.component="rhmap-nginx18-docker" \
      name="rhmap/nginx-18-centos" \
      version="1" \
      release="1" \
      architecture="x86_64"

USER root 

ADD /app-root/ /opt/app-root
RUN chmod 777 -Rf /opt/app-root/

## Default values for required environment variables
ENV DNS_SERVER=8.8.8.8 \
    BASE_HOST=localhost  \
    LOG_LEVEL=error \
    RHMAP_PLATFORM_PATH=/box/srv/1.1/

## Default user from upstream image
USER 1001

CMD [ "/opt/app-root/nginx18" ]
