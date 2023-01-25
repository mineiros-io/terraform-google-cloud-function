module "test" {
  source = "../.."

  # add only required arguments and no optional arguments

  region = "europe-west3"

  project = local.project_id

  name = "test-${local.random_suffix}"

  runtime = "nodejs10"

  source_archive = "/tmp/source-archive.zip"

  bucket = "storage_bucket"

}
