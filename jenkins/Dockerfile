FROM nginx:1.23

ARG DOCKER_MESSAGE

WORKDIR /usr/share/nginx/html/

RUN echo "${DOCKER_MESSAGE}" > index.html
