# Gathers information about the current state of the Istio service mesh, including configuration, 
# logs, and cluster state, to create a comprehensive bug report. 
# This is especially helpful when seeking support or reporting bugs.
istioctl bug-report

# Provides access to metrics for Istio components, services, and proxies. This command is useful for debugging performance and traffic issues.
istioctl x metrics pods <pod-name>
