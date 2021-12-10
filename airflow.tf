data "kubernetes_service" "webserver" {
  depends_on = [
    helm_release.airflow,
    
  ]
  metadata {
    name = "${var.helm_chart_name}-webserver"
    namespace = var.helm_chart_name
  }
}
data "external" "creds" {
  depends_on = [
    helm_release.airflow,
  ]
    program = ["bash", "${path.module}/scripts/get_cred.sh"]
    query = {
      chart = "${var.helm_chart_name}"
      region = "${var.region}"
      project_id = "${var.project_id}"

    }
}
# data "external" "password" {
#   depends_on = [
#     helm_release.airflow
#   ]
#   program = ["bash", "-c", <<EOT
# echo "{\"password\": \"$(helm -n ${var.helm_chart_name} status ${var.helm_chart_name} | grep password: | head -n 1 | cut -d ':' -f2 | tr -d ' ')\"}"
# EOT
# ]
# }
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
