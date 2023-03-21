#!/bin/bash

d=$(cd $(dirname $0); pwd)
kubectl="${d}/kubectl.sh"

if [ -z "$1" ]; then
    # create redis cluster
    # c.f. https://kubernetes.io/docs/concepts/workloads/controllers/statefulset/#stable-network-id
    nodes=$("$kubectl" get pod|awk '$1~/^redis-/{printf "%s.redis.experimental-redis-cluster.svc.cluster.local:7000\n", $1}'|xargs)
    "$kubectl" exec -it $("$kubectl" get pod|awk '$1~/^redis-/{print $1}'|head -n1) -- /bin/bash -c "echo yes|redis-cli --cluster create --cluster-replicas 1 $nodes"
else
    pod="$1"
    shift
    # redis-cli cluster-mode
    # e.g.
    # redis-cli:
    #   cluster.sh redis-1
    # check cluster status:
    #   cluster.sh redis-1 --cluster check 127.0.0.1:7000
    # list cluster nodes:
    # compare with `kubectl.sh get pod -owide`
    #   cluster.sh redis-1 cluster nodes
    "$kubectl" exec -it "$pod" -- redis-cli -c -p 7000 "$@"
fi
