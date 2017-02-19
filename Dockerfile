FROM docker:dind

RUN apk add --update --no-cache ca-certificates supervisor

RUN mkdir -p /var/log/supervisor
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

WORKDIR /repos
RUN git clone https://github.com/GoogleCloudPlatform/kubernetes.git
RUN wget https://storage.googleapis.com/golang/go1.7.1.linux-amd64.tar.gz
RUN tar -C /usr/local -xzf go1.7.1.linux-amd64.tar.gz
ENV PATH /usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/local/go/bin

# Install etcd
WORKDIR /repos/kubernetes
RUN hack/install-etcd.sh
RUN cp third_party/etcd/* /usr/bin/

# Open apisever to all interfaces
RUN sed -i '/API_HOST=${API_HOST:-127.0.0.1}/ c\API_HOST=${API_HOST:-0.0.0.0}' /repos/kubernetes/hack/local-up-cluster.sh
RUN sed -i '/API_PORT=${API_PORT:-8080}/ c\API_PORT=${API_PORT:-8888}' /repos/kubernetes/hack/local-up-cluster.sh
WORKDIR /

ADD start.sh /start.sh
RUN chmod +x /start.sh

# Define additional metadata for our image.
VOLUME /var/lib/docker

# Start supervisord
CMD ["supervisord", "-c", "/etc/supervisor/supervisord.conf"]
