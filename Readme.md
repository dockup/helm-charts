# Helm charts for opensource projects

### How to install Dockup

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
> kubectl create clusterrolebinding yuva-cluster-admin-binding \
    --clusterrole=cluster-admin --user=<your-email-used-for-gke>
~~~


#### Step 3: Add these helm charts as repository

Now add codemancers chart repository to your helm config

~~~
helm repo add c9s https://helm-charts.c9s.tech
~~~

Time to time, its advised to update helm repository caches

~~~
helm repo update
~~~


#### Installing dockup

After adding a new helm repository, install dockup as helm package

~~~sh
> helm install --name=dockup c9s/dockup
~~~

The above commands installs postgresql required by dockup

You need to have traefik or nginx ingress in order to expose dockup to
external world. Also, its recommended to set custom values in yaml
file, say `dockup.yaml` and then install dockup.

~~~sh
> helm install -f dockup.yaml --name=dockup c9s/dockup
~~~

#### Installing db-pool

Db-pool is used to create a farm of pre-poulated databases which can be
connected to dockup deployments. This saves time when it comes to
spinning up new testing sites.

~~~sh
> helm install --name=db-pool c9s/db-pool
~~~

The above commands installs postgresql required by db-pool, and mysql.
Currently db-pool only supports managing of mysql databases.

Its recommended to set all these values in yaml file, say `db-pool.yaml`
and then install it

~~~sh
> helm install -f db-pool.yaml --name=db-pool c9s/db-pool
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
