# Installing Istio with Manifests

This guide outlines how to install Istio using manifests and `istioctl`.

---

## Step 1: Download the Istio Release
- Download the Istio release that matches your platform and version requirements:
  ```bash
  curl -L https://istio.io/downloadIstio | sh -
  cd istio-<version>
  export PATH=$PWD/bin:$PATH
  ```

---

## Step 2: Perform Platform-Specific Setup
- Ensure your Kubernetes cluster meets Istio’s requirements.
- Verify prerequisites such as:
  - Kubernetes version compatibility.
  - Sufficient resources for Istio components.
  - Access to required permissions.

---

## Step 3: Check Requirements for Pods and Services
- Verify that your cluster has:
  - Appropriate node selectors for Linux workloads.
  - Configuration to allow Istio sidecar injection and other resource requirements.

---

## Step 4: Install Istio Using the Default Profile
- Install Istio with the default profile:
  ```bash
  istioctl install
  ```
- Optionally, enable access logs:
  ```bash
  istioctl install --set meshConfig.accessLogFile=/dev/stdout
  ```

---

## Step 5: Customize the Installation
- Create a custom configuration file for Istio:
  ```yaml
  cat <<EOF > ./my-config.yaml
  apiVersion: install.istio.io/v1alpha1
  kind: IstioOperator
  spec:
    meshConfig:
      accessLogFile: /dev/stdout
  EOF
  ```
- Apply the custom configuration:
  ```bash
  istioctl install -f my-config.yaml
  ```

---

## Step 6: Check Installed Components
- Verify the installed components and configuration:
  ```bash
  kubectl -n istio-system get IstioOperator installed-state -o yaml > install-state.yaml
  ```

---

## Step 7: View Available Profiles
- List and view settings for Istio profiles:
  ```bash
  istioctl profile list
  istioctl profile dump demo
  ```

---

## Step 8: Generate and Verify a Manifest
- Generate a manifest before installation to capture potential changes:
  ```bash
  istioctl manifest generate > $HOME/generated-manifest.yaml
  ```
- Compare manifests for differences:
  ```bash
  istioctl manifest diff 1.yaml 2.yaml
  ```
- Verify the generated manifest:
  ```bash
  istioctl verify-install -f $HOME/generated-manifest.yaml
  ```

---

## Step 9: Uninstall Istio
- Uninstall Istio and remove all related resources:
  ```bash
  istioctl uninstall --purge
  ```
