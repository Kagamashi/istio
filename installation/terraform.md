https://medium.com/@vipinagarwal18/install-istio-on-azure-kubernetes-cluster-using-terraform-214f6d3f611 

  1. Create AKS cluster 
  
  2. Create isitio namespace - istio-system 
resource "kubernetes_namespace" "istio_system" { 
  provider = kubernetes.local 
  metadata { 
    name = "istio-system" 
  } 
} 
  
  3. Ustawienie configu na nasz AKS 
resource "null_resource" "set-kube-config" { 
  triggers = { 
    always_run = "${timestamp()}" 
  } 
  provisioner "local-exec" { 
    command = "az aks get-credentials -n ${azurerm_kubernetes_cluster.aks.name} -g ${azurerm_resource_group.rg.name} --file \".kube/${azurerm_kubernetes_cluster.aks.name}\" --admin --overwrite-existing" 
  } 
  depends_on = [local_file.kube_config] 
} 
  
  4. Sekrety dla Grafany i Kiali (optional) - kubernetes_secret 
resource "kubernetes_secret" "grafana" { 
  provider = kubernetes.local 
  metadata { 
    name      = "grafana" 
    namespace = "istio-system" 
    labels = { 
      app = "grafana" 
    } 
  } 
  data = { 
    username   = "admin" 
    passphrase = random_password.password.result 
  } 
  type       = "Opaque" 
  depends_on = [kubernetes_namespace.istio_system] 
} 
  
resource "kubernetes_secret" "kiali" { 
  provider = kubernetes.local 
  metadata { 
    name      = "kiali" 
    namespace = "istio-system" 
    labels = { 
      app = "kiali" 
    } 
  } 
  data = { 
    username   = "admin" 
    passphrase = random_password.password.result 
  } 
  type       = "Opaque" 
  depends_on = [kubernetes_namespace.istio_system] 
} 
  
  5. Ustawienie configu Istio - zainstalowanie manifestu Istio przy użyciu istioctl 
resource "local_file" "istio-config" { 
  content = templatefile("${path.module}/istio-aks.tmpl", { 
    enableGrafana = true 
    enableKiali   = true 
    enableTracing = true 
  }) 
  filename = ".istio/istio-aks.yaml" 
} 
  
resource "null_resource" "istio" { 
  triggers = { 
    always_run = "${timestamp()}" 
  } 
  provisioner "local-exec" { 
    command = "istioctl manifest apply -f \".istio/istio-aks.yaml\" --kubeconfig \".kube/${azurerm_kubernetes_cluster.aks.name}\"" 
  } 
  depends_on = [kubernetes_secret.grafana, kubernetes_secret.kiali, local_file.istio-config] 
} 
  
  6. Sample istio-aks.yaml file 
apiVersion: install.istio.io/v1alpha2 
kind: IstioControlPlane 
spec: 
  # Use the default profile as the base 
  # More details at:  https://istio.io/docs/setup/additional-setup/config-profiles/ 
  profile: default 
  values: 
    global: 
      # Ensure that the Istio pods are only scheduled to run on Linux nodes 
      defaultNodeSelector: 
        beta.kubernetes.io/os: linux 
      # Enable mutual TLS for the control plane 
      controlPlaneSecurityEnabled: true 
      mtls: 
        # Require all service to service communication to have mtls 
        enabled: false 
    grafana: 
      # Enable Grafana deployment for analytics and monitoring dashboards 
      enabled: ${enableGrafana} 
      security: 
        # Enable authentication for Grafana 
        enabled: true 
    kiali: 
      # Enable the Kiali deployment for a service mesh observability dashboard 
      enabled: ${enableKiali} 
    tracing: 
      # Enable the Jaeger deployment for tracing 
      enabled: ${enableTracing} 
  
  7. Terraform apply - create AKS cluster/kubernetes secret/install Istio using istioctl 
Verify install: istioctl verify-install -f istio-aks.yaml 
