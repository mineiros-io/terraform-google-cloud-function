module "test" {
  source = "../.."

  module_enabled = false

  # add all required arguments

  region = "europe-west3"

  project = local.project_id

  name = "test-${local.random_suffix}"

  runtime = "nodejs10"

  source_archive = "/tmp/source-archive.zip"

  bucket = "storage_bucket"

  # add all optional arguments that create additional/extended resources
}
