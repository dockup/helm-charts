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
> kubectl create clusterrolebinding tiller-cluster-rule --clusterrole=cluster-admin
    --serviceaccount=kube-system:tiller
> kubectl patch deploy --namespace kube-system tiller-deploy
    -p '{"spec":{"template":{"spec":{"serviceAccount":"tiller"}}}}'
~~~

This helm + tiller installation is to get you started asap. If you need
more control over security, please open a github issue with your
requirements, we would be more than happy to help out.

#### Step 2: Elevate your credentials for assigning roles

~~~sh
> kubectl create clusterrolebinding yuva-cluster-admin-binding
    --clusterrole=cluster-admin --user=<your-email-used-for-gke>
~~~


#### Step 3: Add these helm charts as repository

Now add codemancers chart repository to your helm config

~~~
helm repo add c9s https://helm-charts.c9s.tech
~~~


#### Step 4: Install dockup

After adding a new helm repository, install dockup as helm package

~~~sh
> helm install --name=dockup c9s/dockup
~~~

The above commands installs postgresql required by dockup, and traefik by
default for your staging servers. You can optionally disable traefik by
editing `values.yaml` file

NOTE: You also have to give dns api token so that traefik can do the
following:

- Use api token to access dns settings
- Add a `TXT` record for `dns-01` challenge
- Verify your domain, and obtain wildcard certificate via letsencrypt
- Remove the added `TXT` record

Say, your domain is controlled by Gandi, you can use the following command:

~~~sh
> helm install --set ingress.host=dockup.codemancers.org \
               --set traefik.ssl.email=yuva@codemancers.com \
               --set traefik.acme.domain.main=*.codemancers.org \
               --set traefik.acme.dnsProvider.name=gandiv5 \
               --set traefik.acme.dnsProvider.gandiv5.GANDIV5_API_KEY=<your-token> \
               --set traefik.dashboard.domain=traefik.codemancers.org \
               c9s/dockup
~~~

Once all of this is done, ensure that you add external-ip to dns
settings.

Its recommended to set all these values in yaml file, say `dockup.yaml`
and then install it

~~~sh
> helm install -f dockup.yaml --name=dockup c9s/dockup
~~~
