STIO-based SERVICE MESH ADD-ON

Difference between add-on and open-source Istio
  • Istio versions are tested and verified to be compatible with supported versions of Azure Kubernetes Service.
  • Microsoft handles scaling and configuration of Istio control plane
  • Microsoft adjusts scaling of AKS components like coredns when Istio is enabled.
  • Microsoft provides managed lifecycle (upgrades) for Istio components when triggered by user.
  • Verified external and internal ingress set-up.
  • Verified to work with Azure Monitor managed service for Prometheus and Azure Managed Grafana.
  • Official Azure support provided for the add-on.

Limitations:
  • The add-on doesn't work on AKS clusters that are using Open Service Mesh addon for AKS.
  • The add-on doesn't work on AKS clusters that have Istio installed on them already outside the add-on installation.
  • Managed lifecycle of mesh on how Istio versions are installed and later made available for upgrades.
  • Istio doesn't support Windows Server containers.
  • Customization of mesh based on the following custom resources is blocked for now - EnvoyFilter, ProxyConfig, WorkloadEntry, WorkloadGroup, Telemetry, IstioOperator, WasmPlugin

How to deploy Istio-based service mesh add-on (PREVIEW)
https://learn.microsoft.com/en-us/azure/aks/istio-deploy-addon

az extension add --name aks-preview
az extension update --name aks-preview
az feature register --namespace "Microsoft.ContainerService" --name "AzureServiceMeshPreview"
az feature show --namespace "Microsoft.ContainerService" --name "AzureServiceMeshPreview"
az provider register --namespace Microsoft.ContainerService

Install Istio add-on at the time of cluster creation:
az aks create … --enable-asm (--enable-azure-service-mesh)

Install Istio add-on for existing cluster:
az aks mesh enable --resource-group ${RESOURCE_GROUP} --name ${CLUSTER}
az aks show --resource-group ${RESOURCE_GROUP} --name ${CLUSTER}  --query 'serviceMeshProfile.mode'

Enable sidecar injection:
kubectl label namespace default istio.io/rev=asm-1-17
Manual: kubectl apply -f <(istioctl kube-inject -f sample.yaml -i aks-istio-system -r asm-1-17) -n foo

