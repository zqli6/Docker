FROM alpine:3.23.2
LABEL author=lzq version=1.0 mail=zqli6@qq.com
ENV NGINX_VERSION=1.28.1 DIR=/usr/local/nginx
ADD nginx-${NGINX_VERSION}.tar.gz /usr/local/src
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.ustc.edu.cn/' /etc/apk/repositories \
    && apk update && apk --no-cache add tzdata gcc make curl zip unzip net-tools pstree \
    wget libgcc libc-dev libcurl libc-utils pcre-dev zlib-dev libnfs pcre pcre2 libevent \
    libevent-dev iproute2 \
    && ln -s /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && echo "Asia/Shanghai" > /etc/timezone \
    && addgroup -g 888 -S nginx && adduser -s /sbin/nologin -S -D -u 888 -G nginx nginx \
    && cd /usr/local/src/nginx-${NGINX_VERSION} && ./configure --prefix=${DIR} \
    && make && make install && ln -s ${DIR}/sbin/nginx /usr/local/bin/nginx \
    && chown -R nginx:nginx ${DIR}/ && rm -rf /usr/local/src/nginx-${NGINX_VERSION} \
    && apk del gcc make
ADD nginx.conf $DIR/conf/nginx.conf
# ADD www.wang.org.conf /usr/local/nginx/conf/conf.d/www.wang.org.conf
# ADD index.html /data/website/index.html
COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
# USER nginx
RUN chmod +x /usr/local/bin/docker-entrypoint.sh
CMD nginx -g "daemon off;"
ENTRYPOINT ["docker-entrypoint.sh"]
