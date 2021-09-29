# ------------------------------------------------------------------------------
# OUTPUT CALCULATED VARIABLES (prefer full objects)
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
# OUTPUT ALL RESOURCES AS FULL OBJECTS
# ------------------------------------------------------------------------------

output "cloud_function" {
  description = "All outputs of the created \"google_cloudfunctions_function\" resource."
  value       = try(google_cloudfunctions_function.function[0], {})
}

output "bucket_object" {
  description = "All outputs of the created \"google_storage_bucket_object.archive\" resource."
  value       = try(google_storage_bucket_object.archive[0], {})
}

# ------------------------------------------------------------------------------
# OUTPUT ALL INPUT VARIABLES
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
# OUTPUT MODULE CONFIGURATION
# ------------------------------------------------------------------------------

output "module_enabled" {
  description = "Whether the module is enabled."
  value       = var.module_enabled
}
