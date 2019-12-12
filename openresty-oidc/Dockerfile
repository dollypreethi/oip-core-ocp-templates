ARG IMAGE_ORG="oip-rnd"
ARG OS_NAME="centos"
ARG COMPONENT_NAME="openresty"
ARG COMPONENT_VERSION="1.15.8.2-5"
ARG COMPONENT_SHORT_VERSION="115825"

FROM openresty/${COMPONENT_NAME}:${COMPONENT_VERSION}-${OS_NAME}

EXPOSE 8080
EXPOSE 8443

ENV SUMMARY="Platform for running openresty $COMPONENT_VERSION or building openresty-based application" \
    DESCRIPTION="OpenResty is an Nginx-based web server and a reverse proxy server for HTTP, SMTP, POP3 and IMAP \
protocols, with a strong focus on high concurrency, performance and low memory usage. The container \
image provides a containerized packaging of the openresty $COMPONENT_VERSION daemon. The image can be used \
as a base image for other applications based on openresty $COMPONENT_VERSION web server. \
OpenResty server image can be extended using source-to-image tool."

# Inspired by https://github.com/sclorg/nginx-container/blob/master/1.14/Dockerfile
LABEL summary="${SUMMARY}" \
      description="${DESCRIPTION}" \
      io.k8s.description="${DESCRIPTION}" \
      io.k8s.display-name="${COMPONENT_NAME} ${COMPONENT_VERSION}" \
      io.openshift.expose-services="8080:http" \
      io.openshift.expose-services="8443:https" \
      io.openshift.tags="builder,${COMPONENT_NAME},${IMAGE_ORG}-${COMPONENT_NAME}${COMPONENT_SHORT_VERSION}" \
      io.openshift.s2i.scripts-path=image:///usr/libexec/s2i \
      io.openshift.s2i.scripts-url=image:///usr/libexec/s2i \
      io.s2i.scripts-path=image:///usr/libexec/s2i \
      io.s2i.scripts-url=image:///usr/libexec/s2i \
      com.socgen.cip.component="${IMAGE_ORG}-${COMPONENT_NAME}${COMPONENT_SHORT_VERSION}-container" \
      name="${IMAGE_ORG}/${COMPONENT_NAME}-${COMPONENT_SHORT_VERSION}-${OS_NAME}" \
      version="${COMPONENT_VERSION}" \
      maintainer="Cloud Innovation Platform team <list.fr-cloud-innovation-platform@socgen.com>" \
      help="For more information visit https://github.com/sclorg/${COMPONENT_NAME}-container" \
      usage="s2i build <SOURCE-REPOSITORY> ${IMAGE_ORG}/${COMPONENT_NAME}-${COMPONENT_SHORT_VERSION}-${OS_NAME}:latest <APP-NAME>"
      version="1"

# From https://github.com/sclorg/s2i-base-container/blob/master/core/Dockerfile
ENV \
    # DEPRECATED: Use above LABEL instead, because this will be removed in future versions.
    STI_SCRIPTS_URL=image:///usr/libexec/s2i \
    # Path to be used in other layers to place s2i scripts into
    STI_SCRIPTS_PATH=/usr/libexec/s2i \
    APP_ROOT=/opt/app-root \
    # The $HOME is not set by default, but some applications needs this variable
    HOME=/opt/app-root/src \
    PATH=/opt/app-root/src/bin:/opt/app-root/bin:$PATH \
    PLATFORM="el7"

# Inspired by https://github.com/sclorg/nginx-container/blob/master/1.14/Dockerfile
ENV NGINX_CONFIGURATION_PATH=${APP_ROOT}/etc/nginx.d \
    NGINX_DEFAULT_CONF_PATH=${APP_ROOT}/etc/nginx.default.d \
    NGINX_CONTAINER_SCRIPTS_PATH=/usr/share/container-scripts/nginx \
    NGINX_LOG_PATH=/var/log/nginx

# From https://github.com/sclorg/s2i-base-container/blob/master/core/Dockerfile
# When bash is started non-interactively, to run a shell script, for example it
# looks for this variable and source the content of this file. This will enable
# the SCL for all scripts without need to do 'scl enable'.
ENV BASH_ENV=${APP_ROOT}/etc/scl_enable \
    ENV=${APP_ROOT}/etc/scl_enable \
    PROMPT_COMMAND=". ${APP_ROOT}/etc/scl_enable"

# From https://github.com/sclorg/nginx-container/blob/master/1.14/Dockerfile
# Copy the S2I scripts from the specific language image to $STI_SCRIPTS_PATH
COPY ./s2i/bin/ $STI_SCRIPTS_PATH

# Copy extra files to the image.
COPY ./root/ /

# Directory with the sources is set as the working directory so all STI scripts
# can execute relative to this path.
WORKDIR ${HOME}

ENTRYPOINT ["container-entrypoint"]
CMD ["base-usage"]

# Image specific...
RUN luarocks install lua-resty-openidc && \
    luarocks install lua-resty-string

# Reset permissions of modified directories and add default user
RUN rpm-file-permissions && \
  useradd -u 1001 -r -g 0 -d ${HOME} -s /sbin/nologin \
      -c "Default Application User" default && \
  chown -R 1001:0 ${APP_ROOT}

USER 1001

