# Launches the dashboard for various observability tools integrated with Istio, such as Kiali, Grafana, Prometheus, and Jaeger.
istioctl dashboard kiali
istioctl dashboard grafana
istioctl dashboard jaeger

# Compares two Istio installation profiles to show differences in configuration, useful for understanding how profiles like default, demo, and minimal differ.
istioctl profile diff default minimal
