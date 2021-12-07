resource "helm_release" "airflow" {
  depends_on = [
    google_container_cluster.primary
  ]
  name       = var.helm_chart_name
  repository = "https://airflow.apache.org"
  chart = var.helm_chart_name
  timeout = 900

  set {
      name = "service.type"
      value = "LoadBalancer"
  }
}