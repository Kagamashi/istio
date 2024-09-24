# Install Istio into Kubernetes cluster
istioctl install --set profile=demo

# Upgrade istio to newer version
istioctl upgrade --set profile=default

# Generate Istio configuration manifest without applying it tot the cluster
istioctl manifest generate --set profile=default

# Initializes Istio operator, which is responsible for managing lifecycle of Istio installations
istioctl operator init