# Helm charts for Dockup services

### How to install Dockup Agent

Follow these steps, and you should be all good with a dockup installation
where you can deploy serveral staging sites loadbalanced by traefik. You
need a working google kubernetes cluster. Ensure that you are able to
connect to it using `kubectl`

#### Step 1: Get helm working

~~~sh

> helm init
> kubectl create serviceaccount --namespace kube-system tiller
> kubectl create clusterrolebinding tiller-cluster-rule --clusterrole=cluster-admin \
    --serviceaccount=kube-system:tiller
> kubectl patch deploy --namespace kube-system tiller-deploy \
    -p '{"spec":{"template":{"spec":{"serviceAccount":"tiller"}}}}'
~~~

This helm + tiller installation is to get you started asap. If you need
more control over security, please open a github issue with your
requirements, we would be more than happy to help out.

#### Step 2: Elevate your credentials for assigning roles

~~~sh
> kubectl create clusterrolebinding <your-name>-cluster-admin-binding \
    --clusterrole=cluster-admin --user=<your-email-used-for-gke>
~~~


#### Step 3: Add these helm charts as repository

Now add dockup chart repository to your helm config

~~~
helm repo add dockup https://helm-charts.getdockup.com
~~~

Time to time, its advised to update helm repository caches

~~~
helm repo update
~~~


#### Installing dockup agent

After adding a new helm repository, install dockup as helm package

~~~sh
> helm install --name=dockup-agent dockup/agent
~~~

The above commands installs postgresql required by dockup

You need to have traefik or nginx ingress in order to expose dockup to
external world. Also, its recommended to set custom values in yaml
file, say `agent.yaml` and then install dockup.

~~~sh
> helm install -f agent.yaml --name=dockup-agent dockup/agent
~~~
