# Analyzed istio and kubernetes configurations for potential issues and generates recommendations
istioctl analyze

# Can be targeted for specific namespace
istioctl analyze -n default

# Verifies whether Istio has been installed correctly by checking the state of Istio components and resources
istioctl verify-install

# Shows the status of sidecar proxies running in the mesh and reports sync issues beteen Envoy proxies and control plane
istioctl proxy-status

# Retrieves configuration for Envoy sidecar proxy, helping to debug issues related to traffic routing, custers, and listeners
istioctl proxy-config routes pod-name -n namespace
istioctl proxy-config listeners ...
istioctl proxy-config clusters ...
istioctl proxy-config endpoints ...