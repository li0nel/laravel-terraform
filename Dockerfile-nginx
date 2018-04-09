FROM nginx

ADD deploy/nginx/nginx.conf /etc/nginx/
ADD deploy/nginx/default.conf /etc/nginx/conf.d/

ADD public /usr/share/nginx/html

ADD deploy/nginx/ssl/ssl.cert /etc/ssl/certs/ssl.cert
ADD deploy/nginx/ssl/ssl.key /etc/ssl/private/ssl.key

WORKDIR /usr/share/nginx/html