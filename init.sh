#!/bin/sh

cat >/etc/nginx/conf.d/default.conf <<EOF
http {
	access_log /dev/stdout;
	server {
		client_max_body_size 256M;
		listen $PORT;

		location / {
			proxy_pass "http://localhost:8080";
			proxy_http_version 1.1;
			proxy_buffering off;
		}

		if ($http_x_forwarded_proto != "https") {
			rewrite ^(.*)$ https://$host$1 permanent;
		}
	}
}
EOF

nginx -g 'daemon off;'
