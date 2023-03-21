#!/bin/bash

d=$(cd $(dirname $0)/..; pwd)

echo "Create kind cluster..."
"${d}/bin/kind.sh"

echo "Apply kustomization..."
"${d}/bin/kustom.sh"

get_pod_desired() {
    "${d}/bin/kubectl.sh" get statefulset|awk '$1=="redis"{split($2,xs,"/");print xs[2]}'
}
get_pod_running() {
    "${d}/bin/kubectl.sh" get statefulset|awk '$1=="redis"{split($2,xs,"/");print xs[1]}'
}
wait_pod_running() {
    desired_pods=$(get_pod_desired)
    running=$(get_pod_running)
    while [ "$running" != "$desired_pods" ]; do
          echo "wait pod running (${running}/${desired_pods})..."
          sleep 1
          running=$(get_pod_running)
    done
}

wait_pod_running

get_first_pod() {
    "${d}/bin/kubectl.sh" get pod|awk '$1~/^redis-/{print $1}'|head -n1
}

echo "Create redis cluster..."
"${d}/bin/cluster.sh"

echo "Wait for node roles to be determined..."
sleep 10

echo "Redis cluster status:"
"${d}/bin/cluster.sh" $(get_first_pod) --cluster check 127.0.0.1:7000

echo "Redis cluster nodes:"
"${d}/bin/cluster.sh" $(get_first_pod) cluster nodes

echo "Pods:"
"${d}/bin/kubectl.sh" get pod -owide
