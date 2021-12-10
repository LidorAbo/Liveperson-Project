output "url" {
  depends_on = [
    data.kubernetes_service.webserver
  ]
  value = "http://${data.kubernetes_service.webserver.status[0].load_balancer[0].ingress[0].ip}:${data.kubernetes_service.webserver.spec[0].port[0].port}"
}
output "username" {
  depends_on = [
     data.external.creds

  ]
  value = "${data.external.creds.result.username}"
}
output "password" {
  depends_on = [
    data.external.creds
  ]
  value = "${data.external.creds.result.password}"
}