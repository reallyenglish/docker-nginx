FROM debian:stretch-slim

WORKDIR /build
ADD next-upstream-on-401.patch ./

RUN apt-get update \
  && apt-get install -y --no-install-recommends --no-install-suggests build-essential curl ca-certificates \
  && cd /build \
  # download dependecies
    && curl -O https://ftp.pcre.org/pub/pcre/pcre-8.41.tar.gz \
       && tar xzf pcre-8.41.tar.gz && rm pcre-8.41.tar.gz \
    && curl -O https://www.zlib.net/zlib-1.2.11.tar.gz \
       && tar xzf zlib-1.2.11.tar.gz && rm zlib-1.2.11.tar.gz \
    && curl -O https://www.openssl.org/source/openssl-1.1.0f.tar.gz \
       && tar xzf openssl-1.1.0f.tar.gz && rm openssl-1.1.0f.tar.gz \
  # download and patch nginx source
    && curl -O https://nginx.org/download/nginx-1.13.6.tar.gz \
       && tar xzf nginx-1.13.6.tar.gz && rm nginx-1.13.6.tar.gz \
       && patch -d nginx-1.13.6 -u -p1 -i ../next-upstream-on-401.patch \
  # configure and make
    && cd ./nginx-1.13.6 \
    && ./configure \
    --prefix=/etc/nginx \
    --sbin-path=/usr/sbin/nginx \
    --modules-path=/usr/lib/nginx/modules \
    --conf-path=/etc/nginx/nginx.conf \
    --error-log-path=/var/log/nginx/error.log \
    --http-log-path=/var/log/nginx/access.log \
    --pid-path=/var/run/nginx.pid \
    --lock-path=/var/run/nginx.lock \
    --http-client-body-temp-path=/var/cache/nginx/client_temp \
    --http-proxy-temp-path=/var/cache/nginx/proxy_temp \
    --http-fastcgi-temp-path=/var/cache/nginx/fastcgi_temp \
    --http-uwsgi-temp-path=/var/cache/nginx/uwsgi_temp \
    --http-scgi-temp-path=/var/cache/nginx/scgi_temp \
    --with-zlib=../zlib-1.2.11 \
    --with-openssl=../openssl-1.1.0f \
    --with-pcre=../pcre-8.41 \
    --with-pcre-jit \
    --user=nginx \
    --group=nginx \
    --with-compat \
    --with-file-aio \
    --with-threads \
    --with-http_addition_module \
    --with-http_auth_request_module \
    --with-http_flv_module \
    --with-http_gunzip_module \
    --with-http_gzip_static_module \
    --with-http_mp4_module \
    --with-http_random_index_module \
    --with-http_realip_module \
    --with-http_secure_link_module \
    --with-http_slice_module \
    --with-http_ssl_module \
    --with-http_stub_status_module \
    --with-http_sub_module \
    --with-http_v2_module \
    --with-stream \
    --with-stream_realip_module \
    --with-stream_ssl_module \
    --with-stream_ssl_preread_module \
    --with-cc-opt='-g -O2 -fstack-protector-strong -Wformat -Werror=format-security -Wp,-D_FORTIFY_SOURCE=2 -fPIC' \
    --with-ld-opt='-Wl,-z,relro -Wl,-z,now -Wl,--as-needed -pie' \
    && make \
    && make install \
  # remove tools used for building
    && apt-get remove --purge --auto-remove -y build-essential curl

WORKDIR /

COPY nginx.conf ./etc/nginx/

RUN mkdir /etc/nginx/conf.d \
  && useradd --no-create-home nginx \
  && mkdir -p /var/cache/nginx \
  && ln -sf /dev/stdout /var/log/nginx/access.log \
	&& ln -sf /dev/stderr /var/log/nginx/error.log \
  && rm /etc/nginx/*.default \
  && rm /etc/nginx/fastcgi.conf* \
  && rm -rf /build \
  && rm -rf /var/lib/apt/lists/* \
  && nginx -V \
  && nginx -t

EXPOSE 80

STOPSIGNAL SIGTERM

CMD ["nginx", "-g", "daemon off;"]
