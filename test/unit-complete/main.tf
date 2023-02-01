module "test-sa" {
  source = "github.com/mineiros-io/terraform-google-service-account?ref=v0.1.1"

  account_id = "service-account-id-${local.random_suffix}"
}


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

  iam = [
    {
      role    = "roles/viewer"
      members = ["user:member@example.com"]
    },
    {
      role          = "roles/cloudfunctions.developer"
      members       = ["user:member@example.com"]
      authoritative = false
    },
    {
      roles   = ["roles/editor", "roles/browser"]
      members = ["computed:myserviceaccount"]
    }

  ]

  computed_members_map = {
    myserviceaccount = "serviceAccount:${module.test-sa.service_account.email}"
  }

  vpc_connector = "some-connector"

  secret_environment_variables = [
    {
      key        = "var_a"
      project_id = "my-project"
      secret     = "my-secret"
      version    = "3"
    },
    {
      key     = "var_b"
      secret  = "my-other-secret"
      version = "3"
    }
  ]

  module_depends_on = ["nothing"]

  # add most/all other optional arguments
}


module "test2" {
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

  policy_bindings = [
    {
      role = "roles/viewer"
      members = [
        "user:member@example.com",
        "computed:myserviceaccount",
      ]
    },
    {
      role = "roles/browser"
      members = [
        "user:member@example.com",
      ]
      condition = {
        expression = "request.time < timestamp(\"2023-01-01T00:00:00Z\")"
        title      = "expires_after_2023_12_31"
      }
    }
  ]

  vpc_connector = "some-connector"

  secret_environment_variables = [
    {
      key        = "var_a"
      project_id = "my-project"
      secret     = "my-secret"
      version    = "3"
    },
    {
      key     = "var_b"
      secret  = "my-other-secret"
      version = "3"
    }
  ]

  module_depends_on = ["nothing"]

  # add most/all other optional arguments
}
