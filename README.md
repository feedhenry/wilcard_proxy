## OpenShift Wildcard Proxy

Universal RHMAP platform proxy that can be used as an alternative to wildcard SSL certificates used in the OpenShift environment.

## Purpose of this repository

Provide mapping and proxy between public nginx proxy and
applications deployed via RHMAP and running on OpenShift.


## Running on OpenShift

To install Proxy on OpenShift use supplied template:

    oc new-app -f openshift/rhmap-nginx-proxy.json

## Running with Docker

Proxy can be launched on any operating system that supports Docker (Windows, Linux and MacOSX)

To run the service pull the image from registry:

    docker pull feedhenry/wildcard-proxy-centos

Run downloaded image

    docker run -it -e BASE_HOST=test-host.com -p 80:8080 feedhenry/wildcard-proxy-centos

## Environment variables

> BASE_HOST `required`

Full base host url that would be used to proxy to the RHMAP applications.
It represents the domain name of the OpenShift router DNS name without the first wildcard subdomain.

> BASE_PROTOCOL `optional`

Protocol used to connect to the service

> PLATFORM_URL `optional`

Full URL to RHMAP Core platform. For example https://rhmap.corehost.net

> DNS_SERVER `optional`

DNS server that should be used to query subdomains from BASE_HOST
For internal networks you would need to specify your local DNS server.

> LOG_LEVEL `optional`

Nginx log level. By default it's INFO.

## CONTRIBUTING

To contribute to this repository, fork and create a pull request against master. Changes in this repository will need to be reflected in
the OpenShift templates repositroy that are provided with the RHMAP product. Maintainers of this project are responsible for this update to [fh-core-openshift-templates](https://github.com/fheng/fh-core-openshift-templates)

## Base image

Documentation:
https://hub.docker.com/r/centos/nginx-18-centos7

Source code:
https://github.com/sclorg/nginx-container
