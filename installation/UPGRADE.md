# Istio Upgrade Guide

## Operator Upgrade

### In-Place Upgrade
1. **Download the appropriate `istioctl` version:**
   ```bash
   <extracted-dir>/bin/istioctl operator init
   ```
2. **Verify the Istio Operator upgrade:**
   Check that the Istio operator restarts and updates to the target version:
   ```bash
   kubectl get pods --namespace istio-operator \
     -o=jsonpath='{range .items[*]}{.metadata.name}{":\t"}{range .spec.containers[*]}{.image}{", "}{end}{"\n"}{end}'
   ```
3. **Verify Control Plane upgrade:**
   After a minute or two, Istio control plane components should restart with the new version:
   ```bash
   kubectl get pods --namespace istio-system \
     -o=jsonpath='{range .items[*]}{"\n"}{.metadata.name}{":\t"}{range .spec.containers[*]}{.image}{", "}{end}{"\n"}{end}'
   ```

---

### Canary Upgrade
The recommended way to upgrade Istio with zero downtime is by using **Canary Upgrades**. 

#### Step 1: Install the Current Version
- Download and set up Istio 1.18.0:
  ```bash
  curl -L https://istio.io/downloadIstio | ISTIO_VERSION=1.18.0 sh -
  ```
- Deploy the operator with Istio 1.18.0:
  ```bash
  istio-1.18.0/bin/istioctl operator init
  ```
- Install the Istio control plane:
  ```bash
  kubectl apply -f - <<EOF
  apiVersion: install.istio.io/v1alpha1
  kind: IstioOperator
  metadata:
    namespace: istio-system
    name: example-istiocontrolplane-1-18-0
  spec:
    profile: default
  EOF
  ```
- Verify the IstioOperator CR:
  ```bash
  kubectl get iop --all-namespaces
  ```

#### Step 2: Install the New Version
- Download and extract the `istioctl` version for the target Istio (e.g., 1.19.0):
  ```bash
  curl -L https://istio.io/downloadIstio | ISTIO_VERSION=1.19.0 sh -
  istio-1.19.0/bin/istioctl operator init --revision 1-19-0
  ```
- Create and modify the IstioOperator CR for 1.19.0:
  ```yaml
  apiVersion: install.istio.io/v1alpha1
  kind: IstioOperator
  metadata:
    namespace: istio-system
    name: example-istiocontrolplane-1-19-0
  spec:
    revision: 1-19-0
    profile: default
  ```
- Apply the updated CR:
  ```bash
  kubectl apply -f example-istiocontrolplane-1-19-0.yaml
  ```
- Verify side-by-side deployments:
  ```bash
  kubectl get pod -n istio-system -l app=istiod
  kubectl get services -n istio-system -l app=istiod
  ```
- Label namespaces to use the new revision:
  ```bash
  kubectl label namespace test-ns istio-injection- istio.io/rev=1-19-0
  kubectl rollout restart deployment -n test-ns
  ```

#### Step 3: Remove Old Version
- Uninstall the old Istio control plane:
  ```bash
  kubectl delete istiooperators.install.istio.io -n istio-system example-istiocontrolplane-1-18-0
  ```
- Remove the old Istio operator:
  ```bash
  istioctl operator remove --revision 1-18-0
  ```
- Clean up remaining resources:
  ```bash
  istioctl uninstall -y --purge
  kubectl delete ns istio-system istio-operator
  ```

---

## In-Place Upgrade
For minimal changes and downtime:
- Perform an in-place upgrade using the following steps:
  ```bash
  istioctl upgrade
  ```
- Verify the control plane and sidecars:
  ```bash
  kubectl get pods -n istio-system
  kubectl get mutatingwebhookconfigurations
  ```

---

## Data Plane Upgrade
- Ensure the data plane (Envoy proxies) matches the control plane version by restarting application pods:
  ```bash
  kubectl rollout restart deployment -n <namespace>
  ```
- Verify that the updated proxies are using the correct revision:
  ```bash
  istioctl proxy-status | grep "\.test-ns "
  ```

---

## Stable Revision Tags
- Use **revision tags** for easier management of namespace upgrades.
- Tags act as stable identifiers for revisions, eliminating the need for relabeling namespaces.
- To switch namespaces to a new revision, simply update the tag:
  ```bash
  kubectl label namespace test-ns istio.io/rev=<revision-tag>
  ```
