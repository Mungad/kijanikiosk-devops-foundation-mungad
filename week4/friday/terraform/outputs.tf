output "server_names" {
  description = "Server names"

  value = {
    for key, server in module.app_server :
    key => server.name
  }
}