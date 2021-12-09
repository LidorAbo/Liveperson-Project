output "url" {
  depends_on = [
    data.kubernetes_service.webserver
  ]
  value = "http://${data.kubernetes_service.webserver.status[0].load_balancer[0].ingress[0].ip}:${data.kubernetes_service.webserver.spec[0].port[0].port}"
}
output "username" {
  depends_on = [
     data.external.username
  ]
  value = data.external.username.result.username
}
output "password" {
  depends_on = [
    data.external.password
  ]
  value = data.external.password.result.password
}