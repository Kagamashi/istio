# Provides a detailed description of how traffic is being managed for a specific service, 
# including applied policies like VirtualServices, DestinationRules, and mTLS settings.
istioctl x describe service my-service -n default

# Shows how traffic is being routed for a given host or service, 
# detailing the associated VirtualService and routing rules.
istioctl x route service my-service
