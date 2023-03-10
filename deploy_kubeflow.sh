#!/bin/bash
make install-tools
alias python=python3.8
make deploy-kubeflow INSTALLATION_OPTION=kustomize DEPLOYMENT_OPTION=vanilla
kubectl patch svc istio-ingressgateway -n istio-system -p '{"spec":{"type":"LoadBalancer"}}'
kustomize build ./upstream/contrib/https | kubectl apply -f -
echo "Waiting for Load balancer to get ready ..."
sleep 180
echo "=============================ACCESS KUBEFLOW CENTRAL DASHBOARD AT============================="
kubectl describe service istio-ingressgateway -n istio-system | grep "LoadBalancer Ingress"
echo "=============================================================================================="
