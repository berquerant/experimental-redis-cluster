#!/bin/bash

d=$(cd $(dirname $0)/..; pwd)
kubectl="${d}/bin/kubectl.sh"
kustomized="${d}/kube"

if [ -z "$1" ]; then
    # reapply kustomization
    "$kubectl" delete -k "$kustomized"
    while ! "$kubectl" apply -k "$kustomized" ; do
        sleep 1
    done
else
    "$kubectl" "$1" -k "$kustomized"
fi
