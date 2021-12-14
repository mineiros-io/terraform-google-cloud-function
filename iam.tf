locals {
  iam_map = var.policy_bindings == null ? { for iam in var.iam : iam.role => iam } : tomap({})

  policy_bindings = var.policy_bindings != null ? {
    iam_policy = {
      policy_bindings = var.policy_bindings
    }
  } : tomap({})
}

module "iam" {
  source = "github.com/mineiros-io/terraform-google-cloud-function-iam.git?ref=v0.0.2"

  for_each = var.policy_bindings != null ? local.policy_bindings : local.iam_map

  module_enabled    = var.module_enabled
  module_depends_on = var.module_depends_on

  cloud_function  = google_cloudfunctions_function.function[0].name
  region          = google_cloudfunctions_function.function[0].region
  project         = google_cloudfunctions_function.function[0].project
  role            = try(each.value.role, null)
  members         = try(each.value.members, null)
  authoritative   = try(each.value.authoritative, true)
  policy_bindings = try(each.value.policy_bindings, null)
}
