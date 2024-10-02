### Security in Istio

#### Mutual TLS (mTLS)
- **Role**: Istio implements **mutual TLS (mTLS)** to provide **end-to-end encryption** between services. 
Both the client and server authenticate each other using certificates. 
This ensures that only authorized services can communicate securely within the mesh.
- **Key Features**: Encrypts traffic, ensures data integrity, and authenticates services on both sides of the communication.

---

#### Authentication and Authorization

##### Role-Based Access Control (RBAC)
- **Role**: Istio provides **Role-Based Access Control (RBAC)** to restrict access to services based on a user's identity or service account. Policies can be defined to allow or deny access to services.
- **Example**: Only allow services with a specific service account to communicate with each other.

##### JWT Validation
- **Role**: Istio supports **JWT (JSON Web Token)** validation to authenticate users or services using tokens. 
JWTs are often used for verifying a user's identity and can be attached to requests for authorization.
- **Example**: Validate JWT tokens before allowing access to a protected service.

---

#### Service Identity & Certificates
- **Role**: Istio uses certificates to establish **service identities**, which are used for mTLS. 
Each service in the mesh is assigned an identity in the form of **X.509 certificates**, managed and issued by Istio's **Citadel (now part of Istiod)**. 
These certificates are used for secure communication and identifying services.
- **Key Features**: Automatic certificate issuance and rotation, ensuring services are securely identified within the mesh.

---

#### Policy Enforcement
- **Role**: Istio allows the enforcement of security policies across the mesh. 
These policies define **access control** (e.g., RBAC), **traffic control** (e.g., rate limiting), and other operational rules (e.g., retries, timeouts). 
This ensures that only authorized services and users can access the resources they are entitled to.
- **Example**: Define policies that enforce specific security rules, like denying access to certain services unless a JWT token is provided.

---

### Security at Depth
- Every point has security check, not just entry point to the network - this is called **security at depth**
- Sidecar and Ingress/Exgress proxies work as Policy Enforcement Points
  