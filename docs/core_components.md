### CONTROL PLANE
The **Control Plane** manages configuration and policy distribution to the data plane. It handles tasks like:
- Service discovery
- Traffic routing rules
- Security policies
- Observability

In Istio, the component responsible for these tasks is **ISTIOD**.

---

### ISTIOD
**Istiod** is the unified control plane in Istio, combining the functions of **Pilot**, **Citadel**, and **Galley**. It manages the entire service mesh by handling:
- Service discovery
- Certificate management
- Traffic control
- Policy enforcement

Istiod simplifies deployment by consolidating multiple Istio components into one unified control plane.
Istiod has built-in certificate authority (CA)


---

### DATA PLANE
The **Data Plane** handles the actual traffic between microservices. In Istio, this is managed by **Envoy Proxies**.

---

### ENVOY SIDECAR
**Envoy** is deployed as a sidecar proxy alongside every service in the mesh. It handles all incoming and outgoing traffic for the service, applying Istio's traffic rules and security policies (e.g., mTLS) and collecting telemetry data. Envoy performs the following tasks:
- Load balancing
- Fault tolerance
- Security enforcement (mTLS)
- Routing

The sidecar model ensures that traffic management and security are consistent across the entire mesh without modifying the application code.
