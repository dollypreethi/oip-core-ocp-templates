# To Do list

## Create dynamic app installation process

It would be nice to be able to specify a list of Nextcloud apps to install at deployment time.
Tried to do it using a job pod, mounting nextcloud-source pvc but for an unknown reason, the
/var/www/html directory is empty whereas it is not in the nextcloud pod... need more investigation.

Also, using a pvc instead of an ephemeral volume for /var/www/html prevents nextcloud from working
properly: /var/www/html/lib missing

It may be caused by the interruption of installation process when the pod is redeployed
after the nginx sidecar container is ready (image being dynamically built at provisioning
time, which causes the redeployment of the pod after the build. Maybe the start).

Any way, a snippet of the wip job pod.

```yaml
- apiVersion: batch/v1
  kind: Job
  metadata:
    name: post-install
  spec:
    parallelism: 1    
    completions: 1    
    template:         
      metadata:
        name: post-install
      spec:
        containers:
        - name: post-install
          image: docker.io/nextcloud:latest
          command: ["bash",  "-c", "cd /var/www/html && /tmp/post-install.sh"]
          volumeMounts:
          - mountPath: /var/www/html
            name: nextcloud-source
          - mountPath: /var/www/html/data
            name: nextcloud-data
            subPath: data
          - mountPath: /var/www/html/config
            name: nextcloud-data
            subPath: config
          - mountPath: /var/www/html/custom_apps
            name: nextcloud-data
            subPath: apps
          - mountPath: /tmp/post-install.sh
            name: nextcloud-post-install-job
            subPath: post-install.sh
        volumes:
        - name: nextcloud-source
          persistentVolumeClaim:
            claimName: nextcloud-source
        - name: nextcloud-data
          persistentVolumeClaim:
            claimName: nextcloud-data
        - name: nextcloud-post-install-job
          configMap:
            name: nextcloud-post-install-job
            defaultMode: 0755
        restartPolicy: OnFailure   
```
