# Retrieves raw Envoy proxy configuration for a specific pod. This is useful for advanced troubleshooting of the Envoy sidecar.
istioctl x envoy <pod-name> --namespace <namespace>

# Retrieves the endpoints that a specific Envoy proxy is aware of, which is helpful for debugging service discovery issues.
istioctl pc endpoints <pod-name> -n <namespace>
