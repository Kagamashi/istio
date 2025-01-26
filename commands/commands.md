# Istioctl Command Guide

`istioctl` is the command-line interface (CLI) tool for managing Istio. It allows users to configure, validate, debug Istio resources, and manage the lifecycle of Istio components. Below is a categorized list of key `istioctl` commands with descriptions and usage examples.

---

## General Management

### Bug Report
- **Description:** Gathers information about the current state of the Istio service mesh, including configuration, logs, and cluster state, to create a comprehensive bug report. Useful for support or bug reporting.
- **Command:**
  ```bash
  istioctl bug-report
  ```

### Metrics
- **Description:** Provides access to metrics for Istio components, services, and proxies. Useful for debugging performance and traffic issues.
- **Command:**
  ```bash
  istioctl x metrics pods <pod-name>
  ```

### Analyze
- **Description:** Analyzes Istio and Kubernetes configurations for potential issues and generates recommendations.
- **Commands:**
  ```bash
  istioctl analyze
  istioctl analyze -n default  # Analyze for a specific namespace
  ```

### Verify Installation
- **Description:** Verifies whether Istio has been installed correctly by checking the state of Istio components and resources.
- **Command:**
  ```bash
  istioctl verify-install
  ```

---

## Proxy Debugging

### Proxy Status
- **Description:** Shows the status of sidecar proxies running in the mesh and reports synchronization issues between Envoy proxies and the control plane.
- **Command:**
  ```bash
  istioctl proxy-status
  ```

### Proxy Configuration
- **Description:** Retrieves configuration for Envoy sidecar proxies, helping to debug issues related to traffic routing, clusters, and listeners.
- **Commands:**
  ```bash
  istioctl proxy-config routes <pod-name> -n <namespace>
  istioctl proxy-config listeners <pod-name> -n <namespace>
  istioctl proxy-config clusters <pod-name> -n <namespace>
  istioctl proxy-config endpoints <pod-name> -n <namespace>
  ```

### Envoy Proxy Debugging
- **Description:** Retrieves raw Envoy proxy configuration for advanced troubleshooting or service discovery issues.
- **Commands:**
  ```bash
  istioctl x envoy <pod-name> --namespace <namespace>
  istioctl pc endpoints <pod-name> -n <namespace>
  ```

---

## Istio Installation and Lifecycle

### Install Istio
- **Description:** Installs Istio into a Kubernetes cluster.
- **Command:**
  ```bash
  istioctl install --set profile=demo
  ```

### Upgrade Istio
- **Description:** Upgrades Istio to a newer version.
- **Command:**
  ```bash
  istioctl upgrade --set profile=default
  ```

### Generate Manifest
- **Description:** Generates an Istio configuration manifest without applying it to the cluster.
- **Command:**
  ```bash
  istioctl manifest generate --set profile=default
  ```

### Initialize Operator
- **Description:** Initializes the Istio operator, responsible for managing the lifecycle of Istio installations.
- **Command:**
  ```bash
  istioctl operator init
  ```

---

## Traffic Management

### Inject Sidecar
- **Description:** Injects the Envoy sidecar into Kubernetes workloads.
- **Commands:**
  ```bash
  istioctl kube-inject -f samples/sleep/sleep.yaml | kubectl apply -f -

  istioctl kube-inject \
      --injectConfigFile inject-config.yaml \
      --meshConfigFile mesh-config.yaml \
      --valuesFile inject-values.yaml \
      --filename samples/sleep/sleep.yaml \
      | kubectl apply -f -
  ```

### Traffic Management Description
- **Description:** Provides a detailed description of how traffic is being managed for a specific service, including applied policies like VirtualServices, DestinationRules, and mTLS settings.
- **Command:**
  ```bash
  istioctl x describe service my-service -n default
  ```

### Traffic Routing
- **Description:** Shows how traffic is being routed for a given host or service, detailing the associated VirtualService and routing rules.
- **Command:**
  ```bash
  istioctl x route service my-service
  ```

---

## Profiles

### Profile Dump
- **Description:** Dumps the configuration of a specified Istio profile.
- **Command:**
  ```bash
  istioctl profile dump demo
  ```

### Profile List
- **Description:** Lists all available Istio profiles.
- **Command:**
  ```bash
  istioctl profile list
  ```

### Profile Diff
- **Description:** Compares two Istio installation profiles to show differences in configuration, useful for understanding how profiles like default, demo, and minimal differ.
- **Command:**
  ```bash
  istioctl profile diff default minimal
  ```

---

## Security and Authorization

### Mutual TLS Check
- **Description:** Checks the mutual TLS (mTLS) status between two services or pods to identify security issues with service-to-service communication.
- **Command:**
  ```bash
  istioctl authn tls-check <source-pod> <destination-pod> -n <namespace>
  ```

### Authorization Policy Analysis
- **Description:** Analyzes authorization policies applied to a specific workload, showing requests that are allowed or denied based on the policies.
- **Commands:**
  ```bash
  istioctl x authz check <pod-name> --namespace <namespace>
  istioctl x authz list --workload <workload-name> --namespace <namespace>
  ```
