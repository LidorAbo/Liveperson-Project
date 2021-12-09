data "external" "username" {
  depends_on = [
    helm_release.airflow
  ]
  program = ["/bin/bash", "-c", "echo \"{\\\"username\\\":\\\"$(helm -n airflow status airflow | grep username | head -n 1 | cut -d ':' -f 2 | sed 's/^ *//g')\\\"}\""]
}
data "external" "password" {
  depends_on = [
    helm_release.airflow
  ]
  program = ["/bin/bash", "-c", "echo \"{\\\"password\\\":\\\"$(helm -n airflow status airflow | grep password | head -n 1 | cut -d ':' -f 2 | sed 's/^ *//g')\\\"}\""]
}
resource "helm_release" "airflow" {
  depends_on = [
    google_container_cluster.primary,
    google_container_node_pool.node-pool-1,
    google_container_node_pool.node-pool-2,
    google_container_node_pool.node-pool-3
  ]
  name       = var.helm_chart_name
  repository = "https://airflow.apache.org"
  chart = var.helm_chart_name
  namespace = var.helm_chart_name
  create_namespace = true
  wait = false

  set {
      name = "webserver.service.type"
      value = "LoadBalancer"
  }
} 
