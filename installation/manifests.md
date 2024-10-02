  1. Download the Istio release.
  2. Perform any necessary platform-specific setup.
  3. Check the Requirements for Pods and Services.

Install Istio using default profile
This command installs default profile on cluster.
istioctl install
istioctl install -set meshConfig.accessLogFile=/dev/stdout

cat <<EOF > ./my-config.yaml
apiVersion: install.istio.io/v1alpha1
kind: IstioOperator
spec:
  meshConfig:
    accessLogFile: /dev/stdout
EOF

istioctl install -f my-config.yaml

-set i -f to te same komendy

Check what's installed
[Represents full user configuration]
kubectl -n istio-system get IstioOperator installed-state -o yaml > install-state.yaml

Display profiles
View settings for demo profile:
istioctl profile dump demo
istioctl profile list

Generate a manifest before instllation
[Captures possible changes in underlying charts and tracks actual installed resources]
istioctl manifest generate > $HOME/generated-manifest.yaml
istioctl manifest diff 1.yaml 2.yaml

istioctl verify-install -f $HOME/generated-manifest.yaml
istioctl uninstall --purge
