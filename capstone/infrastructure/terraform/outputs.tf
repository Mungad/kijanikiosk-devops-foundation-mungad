output "staging_namespace" {
  description = "Name of the KijaniKiosk staging namespace"
  value       = kubernetes_namespace.kijani_staging.metadata[0].name
}
