module "test" {
  source = "../.."

  # add all required arguments

  region = "europe-west3"

  project = local.project_id

  name = "test-${local.random_suffix}"

  runtime = "nodejs10"

  source_archive = "/tmp/source-archive.zip"

  bucket = "storage_bucket"

  # add all optional arguments that create additional/extended resources

  archive_upload_name = "name-changed-on-upload.zip"

  entry_point = "server.js"

  trigger_http = null

  event_trigger = {
    event_type = "event-type"
    resource   = "resource-name"
    failure_policy = {
      retry = true
    }
  }

  description = "Some cloud function description text"

  available_memory_mb = 64

  timeout = 30

  max_instances = 1

  ingress_settings = "ALLOW_INTERNAL_ONLY"

  labels = {
    test  = "true"
    other = 32
  }

  service_account_email = "foo@example.com"

  environment_variables = {
    test  = "true"
    other = 32
  }

  build_environment_variables = {
    test  = "true"
    other = 32
  }

  vpc_connector = "some-connector"

  secret_environment_variables = {
    key        = "some-key"
    project_id = "012345"
    secret     = "some-secret"
    version    = "3"
  }

  # add most/all other optional arguments
}
