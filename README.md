## OpenShift Wildcard Proxy

Universal RHMAP platform proxy that can be used to map core and 
mbaas requests outside OpenShift environment.

## Purpose of this repository

Provide mapping and proxy between public nginx proxy and
mbaas and core components running on openshift platform.
By default proxy would use single hostname for every mbaas application 
and I would map first element of the path into subdomain internally.

## Running on OpenShift

To install proxy on openshift use supplied template

    oc new-app -f openshift/rhmap-nginx-proxy.json

## Running on Docker

Proxy can be launched on any operating system that supports docker (Windows, Linux and MacOSX)

To run service pull image from registry:

    docker pull feedhenry/wildcard-proxy-centos

Run downloaded image 

    docker run -it -e BASE_HOST=test-host.com -p 80:8080 feedhenry/wildcard-proxy-centos

## Environment variables


>  BASE_HOST `required`

Full base host url that would be used to proxy to the mbaas, core and apps.
It represents openshift router dns without wildcard.

> PLATFORM_URL `optional`

Full URL to core platform. For example https://rhmap.corehost.net

> DNS_SERVER `optional`

DNS server that would be used to query subdomains from BASE_HOST 
For internal networks you would need to specify your local DNS server.

> LOG_LEVEL `optional` 

Nginx log level. By default it's INFO.

## Base image

Documentation:
https://hub.docker.com/r/centos/nginx-18-centos7/

Source code:
https://github.com/sclorg/nginx-container