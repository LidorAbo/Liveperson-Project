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
  value = dara.external.password.result.password
}
