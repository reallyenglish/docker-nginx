### Nginx patch for next upstream on http 401

It adds `http_401` support in `proxy_next_upstream` option of `ngx_http_proxy_module`.

### References

- [Dockerfile for nginx](https://github.com/nginxinc/docker-nginx/blob/master/mainline/stretch/Dockerfile)
- [`ngx_http_proxy_module`: `proxy_next_upstream`](http://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_next_upstream)
- [How `http_403` implemented](https://github.com/nginx/nginx/commit/1a983a0c05594b55e95ebbda15611f0bc2930ec7)
- [How to Compile Nginx From Source](https://www.vultr.com/docs/how-to-compile-nginx-from-source-on-ubuntu-16-04)
- [Building nginx from Sources](http://nginx.org/en/docs/configure.html)
