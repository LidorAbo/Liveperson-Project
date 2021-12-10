# Provision a GKE Cluster in  Google Cloud with Apache Airflow Helm Chart 

**The Google Kubernetes Engine (GKE) is a fully managed Kubernetes service for deploying, managing, and scaling containerized applications on Google Cloud.**

This repo including `vpc.tf` and `gke.tf` for provisioning [GKE](https://cloud.google.com/kubernetes-engine) cluster in `us-west1` region with 3 nodes(one in each [Node pool](https://cloud.google.com/kubernetes-engine/docs/concepts/node-pools) with different zone within cluster region(one of: `us-east1-a`, `us-east1-b`, `us-east1-c`)) and [VPC](https://cloud.google.com/vpc) with subnetwork in  [Google Cloud Platform](https://cloud.google.com).

This repo also including `airflow.tf` and `output.tf` for install [airflow helm chart](https://airflow.apache.org/docs/helm-chart/stable/index.html) in the [GKE](https://cloud.google.com/kubernetes-engine) cluster, configuring the airflow webui service for access outside to the cluster by configuring [LoadBalancer](https://kubernetes.io/docs/tasks/access-application-cluster/create-external-load-balancer/) in the relevant service in the created cluster and finally print the url of airflow web ui and required credentials to access it.


> **_NOTE:_**  The `.tfstate` file saved remotely in [GCS](https://console.cloud.google.com/storage/browser) bucket to manage infrastructure effectively and to share your teams with current infrastructure in the cloud.

> **_NOTE:_** The `variables.tf`  file used to store used variables by all the `.tf` files except `backend.tf`.

> **_NOTE:_** The `terraform.tfvars` file used to initialize the region and project_id parameters in google provider.

> **_NOTE:_** The `provider.tf` used to connect to the created cluster in  [Google Cloud Platform](https://cloud.google.com) for install [airflow helm chart](https://airflow.apache.org/docs/helm-chart/stable/index.html) on it and access airflow-webserver service attributes for getting web ui url.

## Prerequisites

If you want to follow along and create your own GKE Cluster and access afterthat to airflow webui you need:
* Create [Google Cloud Account](https://console.cloud.google.com/getting-started)
* a configured [Google Cloud SDK](https://cloud.google.com/sdk/docs/install)
* [kubectl](https://kubernetes.io/docs/reference/kubectl/overview/)
* [helm cli](https://helm.sh/docs/intro/install/)

## Usage

After you installed the [Google Cloud SDK](https://cloud.google.com/sdk/docs/install), you need to initialize [Google Cloud Account](https://console.cloud.google.com/getting-started) by following command:
```console
gcloud init 
```
**The above command authorize the SDK to access GCP using your user account credentials and add the SDK to your PATH. This steps requires you to login and select the project you want to work in. Finally, add your account to the Application Default Credentials (ADC). This will allow Terraform to access these credentials to provision resources on GCloud by following command:**

```console
gcloud auth application-default login
```

Afterthat, you need to initialize the providers plugins and initialize the google provider provided by `terraform.tfvars` by the using the following command:
```console
terraform init
```

Immediately afterwards, In your initialized directory, run `terraform apply` command and review the planned actions. Your terminal output should indicate the plan is running and what resources will be created as following:
```console
Plan: 7 to add, 0 to change, 0 to destroy.

Changes to Outputs:
  + password = (known after apply)
  + url      = (known after apply)
  + username = (known after apply)

Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value: 
```
You can see this terraform apply will provision a VPC, subnet, GKE Cluster and a GKE with node pools and airflow velm chart . **Confirm the apply** with a `yes`.

Finally, upon successful your output should be something like:

```console
Apply complete! Resources: 7 added, 0 changed, 0 destroyed.

Outputs:

password = "****"
url = "http://34.145.125.99:8080"
username = "****"
```
You can access airflow webui by enter above url in your browser, enter credentials and get the airflow webui interface.

Also you can access cluster by configuring kubectl to using kubeconfig of GKE by following command:

```console
gcloud container clusters get-credentials <your-project-id>  --region  us-west1
```

and you can access by cluster by following command:

```console
kubectl get nodes
```
You should see output something like this:

```console
NAME                                                  STATUS   ROLES    AGE   VERSION
gke-liveperson-proje-liveperson-proje-65e81078-k6r3   Ready    <none>   12m   v1.21.5-gke.1302
gke-liveperson-proje-liveperson-proje-6ee0b5bc-kkb5   Ready    <none>   13m   v1.21.5-gke.1302
gke-liveperson-proje-liveperson-proje-add19330-8x9t   Ready    <none>   10m   v1.21.5-gke.1302

```

## Cleanup

Running the following commands for removing above infrastructure:

```console
terraform state rm helm_release.airflow
terraform destroy -auto-aprrove