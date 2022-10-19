FROM centos:7

RUN yum -y update && yum install -y epel-release && yum install -y nginx
EXPOSE 80

ENTRYPOINT ["/usr/sbin/nginx", "-g", "daemon off;"]