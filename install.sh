#!/bin/bash

####rook
minikube ssh "cd /bin; sudo curl -O https://raw.githubusercontent.com/ceph/ceph-docker/master/examples/kubernetes-coreos/rbd; sudo chmod +x /bin/rbd; rbd"
kubectl create -f rook-operator.yaml
sleep 10
kubectl get pod | grep rook-operator # should be running
kubectl create -f rook-cluster.yaml
sleep 30
kubectl -n rook get pod #should see 5
export MONS=$(kubectl -n rook get pod mon0 mon1 mon2 -o json|jq ".items[].status.podIP"|tr -d "\""|sed -e 's/$/:6790/'|paste -s -d, -)
sed 's#INSERT_HERE#'$MONS'#' rook-storageclass.yaml | kubectl create -f -
sleep 10

#kubectl create -f mysql.yaml
#kubectl create -f wordpress.yaml