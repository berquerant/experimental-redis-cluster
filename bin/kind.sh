#!/bin/bash

d=$(cd $(dirname $0)/..; pwd)

config="${d}/kind.yml"
case "$1" in
    "") # recreate kind cluster
        kind delete cluster --name "$CLUSTER_NAME"
        kind create cluster --name "$CLUSTER_NAME" --config "$config"
        ;;
    "create")
        kind create cluster --name "$CLUSTER_NAME" --config "$config"
        ;;
    "delete")
        kind delete cluster --name "$CLUSTER_NAME"
        ;;
esac
