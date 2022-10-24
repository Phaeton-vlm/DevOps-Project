FROM centos:8

#change the mirrors
RUN cd /etc/yum.repos.d/; \
sed -i 's/mirrorlist/#mirrorlist/g' /etc/yum.repos.d/CentOS-*; \
sed -i 's|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/CentOS-*

RUN dnf update -y && dnf install -y nginx; \
dnf clean all; \
mkdir -p /opt/nginx/www.nginxtest.com && mkdir -p /opt/nginx/logs

COPY ./configs/nginx.conf /etc/nginx

EXPOSE 80

ENTRYPOINT ["/usr/sbin/nginx", "-g", "daemon off;"]