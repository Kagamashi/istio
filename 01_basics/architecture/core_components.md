## Control Plane
The **Control Plane** manages configuration and policy distribution to the Data Plane. It handles tasks such as:
- Service discovery
- Traffic routing rules
- Security policies
- Observability

In Istio, the component responsible for these tasks is **Istiod**.

---

## Istiod
**Istiod** is the unified control plane in Istio, combining the functions of **Pilot**, **Citadel**, and **Galley**. 
It manages the entire service mesh by handling:
- Service discovery
- Certificate management
- Traffic control
- Policy enforcement

### Key Features:
- Simplifies deployment by consolidating multiple Istio components into one unified control plane.
- Includes a built-in **Certificate Authority (CA)** for managing mTLS certificates.

---

## Data Plane
The **Data Plane** handles the actual traffic between microservices. In Istio, this is managed by **Envoy Proxies**.

---

## Envoy Sidecar
**Envoy** is deployed as a sidecar proxy alongside every service in the mesh. It intercepts all incoming and outgoing traffic for the service, applying Istio's traffic rules and security policies, while also collecting telemetry data.

### Responsibilities:
- **Load Balancing**: Distributes traffic across service instances.
- **Fault Tolerance**: Handles retries, failovers, and circuit breaking.
- **Security Enforcement**: Applies mTLS for secure communication.
- **Routing**: Manages traffic routing based on Istio's configurations.

The sidecar model ensures:
- Consistent traffic management and security across the entire mesh.
- No need to modify application code for traffic management or security policies.
