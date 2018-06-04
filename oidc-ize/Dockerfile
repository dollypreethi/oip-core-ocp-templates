FROM openresty/openresty:alpine-fat

RUN apk update && \
    apk add openssl && \
    apk add --virtual .build-dependencies openssl-dev git && \
    luarocks install luacrypto && \
    luarocks install lua-resty-openidc && \
    apk del .build-dependencies

ADD nginx* /

USER 1001
