output "server_names" {
  description = "Multipass VM names"

  value = {
    for name, server in local.servers :
    name => server.name
  }
}