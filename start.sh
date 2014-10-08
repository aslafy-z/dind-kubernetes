#!/bin/bash

# Waits for wrapdocker to start then starts a local kubernetes cluster
sleep 5
/repos/kubernetes/hack/local-up-cluster.sh
