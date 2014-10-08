# Kubernetes - Docker-in-Docker

This recipe lets you run Kubernetes in Docker within Docker.

Forked from https://github.com/jpetazzo/dind

The purpose of this came down to a desire to quickly start a local kubernetes
cluster using hack/local-up-cluster.sh in the kubernetes source code.


There is only one requirement: your Docker version should support the
`--privileged` flag.


## Quickstart

Build the image:
```bash
docker build -t dind-kubernetes.
```
then run:
```bash
docker run --privileged -t -i --net="host" dind-kubernetes
```

Or run the image without building:
```bash
docker run --privileged -t -i --net="host" llamashoes/dind-kubernetes
```

Using --net="host" allows the pods/services that will start in the local
cluster to be visible on the host.

You can then make api calls to kubernetes apiserver running on <yourip>:8888
