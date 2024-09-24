# Checks the mutual TLS (mTLS) status between two services or pods, helping identify security issues with service-to-service communication.
istioctl authn tls-check <source-pod> <destination-pod> -n <namespace>

# Analyzes authorization policies applied to a specific workload, showing which requests are allowed or denied based on the current policies.
istioctl x authz check <pod-name> --namespace <namespace>

# Lists all AuthorizationPolicies applied to a specific workload, helping you understand access control configurations.
istioctl x authz list --workload <workload-name> --namespace <namespace>
