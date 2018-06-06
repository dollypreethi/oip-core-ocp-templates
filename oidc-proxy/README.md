# Template description

This template will run the specified docker image and protect it with an Open ID Connect side-car container.

[![Run on Openshift](../assets/images/run_on_openshift.png)](https://console.ocp.lab-nxtit.com/console/create?template=oidc-ize&templateParamsMap={"NGINX_DOCKERFILE_REPO"%3A"https%3A%2F%2Fgithub.com%2Foip-core%2Foip-core-ocp-templates.git"})

## Components provisioned

| Type | Components | Description |
| ---------- | ---- | ------- |
| configMap | ${NAME}-nginx-config | nginx config for Open ID Connect |
| deploymentConfig | ${NAME} | The deployment config handling pod life-cycle |
| service | ${NAME} | exposing the pod outside the project |
| route | ${name} | exposing the app outside the cluster |
|  | [Let's Encrypt](https://letsencrypt.org/) certificate | Trusted TLS certificate to secure communication to your app |

## External documentation

Tbd
