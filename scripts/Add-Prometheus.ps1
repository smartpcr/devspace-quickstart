helm repo add coreos https://s3-eu-west-1.amazonaws.com/coreos-charts/stable/
# Create a new Monitoring Namespace to deploy Prometheus Operator too
kubectl create namespace monitoring
# Install Prometheus Operator
# NOTE: The output of this command will say failed because there is a job (pod)
# running and it takes a while to complete. It is ok, proceed to next step.
helm install coreos/prometheus-operator --version 0.0.27 --name prometheus-operator --namespace monitoring
kubectl -n monitoring get all -l "release=prometheus-operator"
# Install Prometheus Configuration and Setup for Kubernetes
helm install coreos/kube-prometheus --version 0.0.95 --name kube-prometheus --namespace monitoring
kubectl -n monitoring get all -l "release=kube-prometheus"
# Check to see that all the Pods are running
kubectl get pods -n monitoring
# Other Useful Prometheus Operator Resources to Peruse
kubectl get prometheus -n monitoring
kubectl get prometheusrules -n monitoring
kubectl get servicemonitor -n monitoring
kubectl get cm -n monitoring
kubectl get secrets -n monitoring

# Edit kubelet to be http instead of https (Fixes Prometheus kubelet API Metrics)
# Edit kube-dns to update Prometheus ENV (Fixes DNS API Metrics)
# https://github.com/coreos/prometheus-operator/issues/1522
kubectl edit servicemonitors kube-prometheus-exporter-kubelets -n monitoring
$patchContent = Get-Content .\prom-graf-kube-dns-metrics-patch.yaml
kubectl patch deployment kube-dns-v20 -n kube-system --patch "$(cat prom-graf-kube-dns-metrics-patch.yaml)"

# use your VI skills to change the below snippet. It should be "LoadBalancer" and not "ClusterIP"
kubectl.exe edit service kube-prometheus -n monitoring

# repeat for Alert Manager
kubectl.exe edit service kube-prometheus-alertmanager -n monitoring

# repeat for Grafana
kubectl edit service kube-prometheus-grafana -n monitoring

# Get your public IP address for the Prometheus dashboard (if <pending>, you must wait...)
kubectl get service kube-prometheus -n monitoring

# Get your public IP address for the Prometheus Alert Manager (if <pending>, you must wait...)
kubectl get service kube-prometheus-alertmanager -n monitoring