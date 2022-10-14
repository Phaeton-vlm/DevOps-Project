FROM centos:8

#change the mirrors
RUN cd /etc/yum.repos.d/; \
sed -i 's/mirrorlist/#mirrorlist/g' /etc/yum.repos.d/CentOS-*; \
sed -i 's|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/CentOS-*

RUN dnf update -y
RUN dnf install -y nginx
RUN dnf clean all

COPY index.html /usr/share/nginx/html/

EXPOSE 80

ENTRYPOINT ["/usr/sbin/nginx", "-g", "daemon off;"]