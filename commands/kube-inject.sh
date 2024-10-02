istioctl kube-inject -f samples/sleep/sleep.yaml | kubectl apply -f -

istioctl kube-inject \
    --injectConfigFile inject-config.yaml \
    --meshConfigFile mesh-config.yaml \
    --valuesFile inject-values.yaml \
    --filename samples/sleep/sleep.yaml \
    | kubectl apply -f -
