# OPERATOR UPGRADE
ISTIO OPERATOR upgrade

In-Place
Download istioctl corresponding to the version of Istio we want to upgrade to.
<extracted-dir>/bin/istioctl operator init

istio-operator should be restarted and it's version should have changes to target version
kubectl get pods --namespace istio-operator \
  -o=jsonpath='{range .items[*]}{.metadata.name}{":\t"}{range .spec.containers[*]}{.image}{", "}{end}{"\n"}{end}'

After a minute or two, Istio control plane components should also be restarted at new version:
kubectl get pods --namespace istio-system \
  -o=jsonpath='{range .items[*]}{"\n"}{.metadata.name}{":\t"}{range .spec.containers[*]}{.image}{", "}{end}{"\n"}{end}'


Canary
https://istio.io/latest/docs/setup/install/operator/
Example upgrade Istio 1.18.0 to 1.19.0

[ 1 ]
Install 1.18.0:
curl -L https://istio.io/downloadIstio | ISTIO_VERSION=1.18.0 sh -

Deploy operator with Istio 1.18.0:
istio-1.18.0/bin/istioctl operator init

Install Istio control plane demo profile:
kubectl apply -f - <<EOF
apiVersion: install.istio.io/v1alpha1
kind: IstioOperator
metadata:
  namespace: istio-system
  name: example-istiocontrolplane-1-18-0
spec:
  profile: default
EOF

Verify that IstioOperator CR with this name exit:
kubectl get iop --all-namespaces


[ 2 ]
Download and extract istioctl corresponding to version of Istio we wish to upgrade to:
istio-1.19.0/bin/istioctl operator init --revision 1-19-0

Make a copy of example-istiocontrolplane CR and save it in a file named example-istiocontrolplane -1-19-0.yaml. 
Change the name to example-istiocontrolplane-1-19-0 and revision: 1-19-0.
$ catexample-istiocontrolplane-1-19-0.yaml
apiVersion: install.istio.io/v1alpha1
kind: IstioOperator
metadata:
  namespace: istio-system
  name: example-istiocontrolplane-1-19-0
spec:
  revision: 1-19-0
  profile: default

Apply updated IstioOperator CR to the cluster. 
You will have 2 CR deployments and services running side-by-side.
kubectl get pod -n istio-system -l app=istiod
kubectl get services -n istio-system -l app=istiod

To complete the upgrade, label the workload namespaces with istio.io/rev=1-19-0 and restart the workloads, as explained in the Data plane upgrade documentation.


[ 3 ]
Uninstall old Control Plane.
kubectl delete istiooperators.install.istio.io -n istio-system example-istiocontrolplane

Remove Istio operator for the old revision:
istioctl operator remove --revision <revision>

To clean ub anything not removed by operator:
istioctl uninstall -y --purge
kubectl delete ns istio-system istio-operator









# ISTIO UPGRADE

In-Place
https://istio.io/latest/docs/setup/upgrade/in-place/

Canary [0 downtime]
https://istio.io/latest/docs/setup/upgrade/canary/#before-you-upgrade

[Recommended upgrade method]
istioctl x precheck


CONTROL PLANE
In production environment a better revision name would correspond to the Istio version.
(revision=1-19-0 for Istio 1.19.0 because . Is not a valid revision name character)
isctiocl install --set revision=canary

After this command we will have 2 CR deployments and services running side by side.
kubectl get pods -n istio-system -l app=istiod
kubectl get svc -n istio-system -l app=istiod


There should also be 2 sidecar injector configurations:
kubectl get mutatingwebhookconfiguratrions


DATA PLANE
Gateway Canary Upgrade

Verify that istio-ingress gateway is using the canary revision:
istioctl proxy-status | grep "$(kubectl -n istio-system get pod -l app=istio-ingressgateway -o jsonpath='{.items..metadata.name}')" | awk '{print $10}'

To upgrade namespace test-ns remove istio-injection label, and add istio.io/rev label to point to the canary revision.
kubectl label namespace test-ns istio-injection- istio.io/rev=canary

After namespace update we have to restart the pods to trigger re-injection
kubectl rollout restart deployment -n test-ns

When pods are re-injected they will be configured to point to the istiod-canary CR. 
We can verify this by using:
istioctl proxy-status | grep "\.test-ns "
upg
STABLE REVISION LABELS
Revision tags are stable identifiers that point to revisions and can be used to avoid relabeling namesapces. 
Rather than relabeling the namespace, a mesh operator can simply change the tag to point to a new revision.
All namespaces labeled with that tag will be updated at the same time.
