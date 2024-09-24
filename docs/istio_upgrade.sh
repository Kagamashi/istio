# - **Best Practices**:
#   - **Backup Configuration**: Before upgrading, backup your current Istio configuration, including custom resource definitions (CRDs) and traffic management policies.
#   - **Version Compatibility**: Always check Istio’s **release notes** for changes in API or CRD versions that might affect your configuration.
#   - **Canary Upgrades**: Perform **canary upgrades** where you run multiple versions of Istio (e.g., testing a new version in one namespace while keeping the old version in production). This reduces the risk of outages.
#   - **Monitor and Validate**: After upgrading, use **istioctl analyze** and other tools to validate the configuration and monitor traffic behavior.
#   - **Regular Maintenance**: Regularly update Istio to ensure you get the latest security patches, bug fixes, and performance improvements. Follow a clear maintenance schedule.
# - **Downtime Minimization**: Istio upgrades are designed to be non-disruptive, but always run in **stages** to minimize downtime.


# Backup Custom Resources
kubectl get virtualservices --all-namespaces -o yaml > virtualservices-backup.yaml
kubectl get destinationrules --all-namespaces -o yaml > destinationrules-backup.yaml


# Download new Istio version
curl -L https://istio.io/downloadIstio | sh -
cd istio-<new-version>
export PATH=$PWD/bin:$PATH


# Verify current Istio instalation
istioctl version
kubectl get pods -n istio-system
# Check that all pods in istio-system namespace are running without issues


# Upgrade Istio Control Plane
istioctl upgrade 


# Check upgrade status 
kubectl get pods -n istio-system


# Upgrade Sidecar Proxies
# After upgrading the control plane, you need to upgrade the Envoy sidecar proxies running alongside your application pods. 
# This can be done by restarting the pods, which will automatically inject the new Envoy sidecars.
kubectl rollout restart deployment -n <namespace>


# Validate configuration
istioctl analyze