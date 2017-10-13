### Nginx patch for next upstream on http 401

It adds `http_401` support in `proxy_next_upstream` option of `ngx_http_proxy_module`.

### References

- [Dockerfile for nginx](https://github.com/nginxinc/docker-nginx/blob/master/mainline/stretch/Dockerfile)
- [`ngx_http_proxy_module`: `proxy_next_upstream`](http://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_next_upstream)
- [How `http_403` implemented](https://github.com/nginx/nginx/commit/1a983a0c05594b55e95ebbda15611f0bc2930ec7)
- [How to Compile Nginx From Source](https://www.vultr.com/docs/how-to-compile-nginx-from-source-on-ubuntu-16-04)
- [Building nginx from Sources](http://nginx.org/en/docs/configure.html)

### Development notes

```console
$ curl -O http://nginx.org/download/nginx-1.13.6.tar.gz
$ tar -xf nginx-1.13.6.tar.gz && mv nginx-1.13.6 nginx-1.13.6-0 && cp nginx-1.13.6-0 nginx-1.13.6-1

# make changes in the nginx-1.13.6-1 dir
$ emacs nginx-1.13.6-1/src/http/ngx_http_upstream.h

# generate patch file
$ diff -Naur nginx-1.13.6-0 nginx-1.13.6-1 > next-upstream-on-401.patch

# build docker image
$ docker build -t nginx:1.13.6-0 .

# push the image
$ docker tag nginx:1.13.6-0 reallyenglish/nginx:1.13.6-0
$ docker push reallyenglish/nginx:1.13.6-0
```
