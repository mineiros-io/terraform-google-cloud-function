resource "google_storage_bucket_object" "archive" {
  count = var.module_enabled ? 1 : 0

  # If a specific archive name is requested for the uploaded object, then override the archive name.
  name   = var.archive_upload_name == null ? basename(var.source_archive) : var.archive_upload_name
  bucket = var.bucket
  source = var.source_archive

  depends_on = [var.module_depends_on]
}

resource "google_cloudfunctions_function" "function" {
  count = var.module_enabled ? 1 : 0

  project = var.project
  region  = var.region

  name          = var.name
  description   = var.description
  runtime       = var.runtime
  max_instances = var.max_instances
  timeout       = var.timeout

  available_memory_mb           = var.available_memory_mb
  environment_variables         = var.environment_variables
  build_environment_variables   = var.build_environment_variables
  source_archive_bucket         = var.bucket
  source_archive_object         = google_storage_bucket_object.archive[0].name
  trigger_http                  = var.trigger_http
  entry_point                   = var.entry_point
  ingress_settings              = var.ingress_settings
  vpc_connector                 = var.vpc_connector
  vpc_connector_egress_settings = var.vpc_connector_egress_settings

  labels                = var.labels
  service_account_email = var.service_account_email

  dynamic "event_trigger" {
    for_each = var.event_trigger != null ? [true] : []

    content {
      event_type = var.event_trigger.event_type
      resource   = var.event_trigger.resource

      failure_policy {
        retry = try(var.event_trigger.failure_policy.retry, false)
      }
    }
  }

  dynamic "source_repository" {
    for_each = var.source_repository != null ? [true] : []

    content {
      url = var.source_repository.url
    }
  }

  depends_on = [var.module_depends_on]
}
