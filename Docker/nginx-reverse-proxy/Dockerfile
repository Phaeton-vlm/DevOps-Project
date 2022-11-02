FROM centos:7
RUN mkdir -p /opt/nginx/www.nginxtest.com /opt/nginx/logs /opt/cert && \
    yum -y update && yum install -y epel-release && yum install -y nginx
COPY ./cert /opt/cert
COPY ./nginx.conf /etc/nginx
EXPOSE 80
EXPOSE 443
CMD ["nginx", "-g", "daemon off;"]