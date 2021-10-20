[<img src="https://raw.githubusercontent.com/mineiros-io/brand/3bffd30e8bdbbde32c143e2650b2faa55f1df3ea/mineiros-primary-logo.svg" width="400"/>][homepage]

[![Terraform Version][badge-terraform]][releases-terraform]
[![Google Provider Version][badge-tf-gcp]][releases-google-provider]
[![Join Slack][badge-slack]][slack]

# terraform-google-cloud-function

A [Terraform](https://www.terraform.io) module to create a [Google Cloud Function](https://cloud.google.com/functions/docs) on [Google Cloud Services (GCP)](https://cloud.google.com/).

**_This module supports Terraform version 1
and is compatible with the Terraform Google Provider version 3._**

This module is part of our Infrastructure as Code (IaC) framework
that enables our users and customers to easily deploy and manage reusable,
secure, and production-grade cloud infrastructure.

- [Module Features](#module-features)
- [Getting Started](#getting-started)
- [Module Argument Reference](#module-argument-reference)
  - [Top-level Arguments](#top-level-arguments)
    - [Module Configuration](#module-configuration)
    - [Main Resource Configuration](#main-resource-configuration)
    - [Extended Resource Configuration](#extended-resource-configuration)
      - [Google storage archive bucket object](#google-storage-archive-bucket-object)
- [Module Attributes Reference](#module-attributes-reference)
- [External Documentation](#external-documentation)
- [Module Versioning](#module-versioning)
  - [Backwards compatibility in `0.0.z` and `0.y.z` version](#backwards-compatibility-in-00z-and-0yz-version)
- [About Mineiros](#about-mineiros)
- [Reporting Issues](#reporting-issues)
- [Contributing](#contributing)
- [Makefile Targets](#makefile-targets)
- [License](#license)

## Module Features

A [Terraform] base module for creating a `google_cloudfunctions_function` resource that creates a new Cloud Function.

In addition to creation of resource this module creates an accompanying `google_storage_bucket_object` for archiving.

## Getting Started

Most basic usage just setting required arguments:

```hcl
module "terraform-google-cloud-function" {
  source = "github.com/mineiros-io/terraform-google-cloud-function.git?ref=v0.1.0"

  project        = google_cloudfunctions_function.function.project
  region         = google_cloudfunctions_function.function.region
  name           = "function-test"
  description    = "My function"
  runtime        = "nodejs14"
}
```

## Module Argument Reference

See [variables.tf] and [examples/] for details and use-cases.

### Top-level Arguments

#### Module Configuration

- **`module_enabled`**: _(Optional `bool`)_

  Specifies whether resources in the module will be created.
  Default is `true`.

- **`module_depends_on`**: _(Optional `list(dependencies)`)_

  A list of dependencies. Any object can be _assigned_ to this list to define a hidden external dependency.

  Example:
  ```hcl
  module_depends_on = [
    google_network.network
  ]
  ```

#### Main Resource Configuration

- **`region`**: **_(Required `string`)_**

  The region where the Cloud Function will be created.

- **`project`**: **_(Required `string`)_**

  The ID of the project in which the resources belong.

- **`name`**: **_(Required `string`)_**

  A user-defined name of the function. The function names must be unique globally.

- **`runtime`**: **_(Required `string`)_**

  The runtime in which the function is going to run. Eg. `nodejs10`, `nodejs12`, `nodejs14`, `python37`, `python38`, `python39`, `dotnet3`, `go113`, `java11`, `ruby27`, etc.

- **`source_repository`**: _(Optional `object({ url = string })`)_

  Represents parameters related to source repository where a function is hosted. Cannot be set alongside `source_archive`. For details please see <https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/cloudfunctions_function#source_repository>

- **`entry_point`**: _(Optional `string`)_

  Name of the function that will be executed when the Google Cloud Function is triggered.

- **`event_trigger`**: _(`object(event_trigger)`)_

  A source that fires events in response to a condition in another service. Structure is documented below. Cannot be used with `trigger_http`.

  Each `event_trigger` object can have the following fields:

  - **`event_type`**: **_(Required `string`)_**

    The type of event to observe. For example: "google.storage.object.finalize". See the documentation on calling [Cloud Functions](https://cloud.google.com/functions/docs/calling/) for a full reference of accepted triggers.

  - **`resource`**: **_(Required `string`)_**

    The name or partial URI of the resource from which to observe events. For example, "myBucket" or "projects/my-project/topics/my-topic".

  - **`failure_policy`**: _(Optional `object ({retry = optional(bool)})`)_

    Specifies policy for failed executions.

    A `failure_policy` object can have the following field:

    - **`retry`**: **_(Required `bool`)_**

      Whether the function should be retried on failure.
      Default is `false`

- **`trigger_http`**: _(Optional `bool`)_

  Boolean variable. Any HTTP request (of a supported type) to the endpoint will trigger function execution. Supported HTTP request types are: `POST`, `PUT`, `GET`, `DELETE`, and `OPTIONS`. Endpoint is returned as `https_trigger_url`. Cannot be used with `event_trigger`.
  Default is `false`.

- **`description`**: _(Optional `bool`)_

  The description of the function.

- **`available_memory_mb`**: _(Optional `number`)_

  Memory (in MB), available to the function. Possible values include `128`, `256`, `512`, `1024`, etc.
  Default is `128`.

- **`max_instances`**: _(Optional `number`)_

  The limit on the maximum number of function instances that may coexist at a given time. Setting maximum instances to `0` results in clearing existing maximum instances limits. Setting a `0` value does not pause your function.

- **`ingress_settings`**: _(Optional `string`)_

  String value that controls what traffic can reach the function. Allowed values are `ALLOW_ALL`, `ALLOW_INTERNAL_AND_GCLB` and `ALLOW_INTERNAL_ONLY`. Changes to this field will recreate the cloud function.
  Default is `ALLOW_INTERNAL_ONLY`.

- **`labels`**: _(Optional `map(string)`)_

  A set of key/value label pairs to assign to the function. Label keys must follow the requirements at <https://cloud.google.com/resource-manager/docs/creating-managing-labels#requirements>.
  Default is `{}`.

- **`service_account_email`**: _(Optional `string`)_

  If defined, use the provided service account to run the function.

- **`environment_variables`**: _(Optional `map(string)`)_

  A set of key/value environment variable pairs to assign to the function.
  Default is `{}`.

- **`build_environment_variables`**: _(Optional `map(string)`)_

  A set of key/value environment variable pairs available during build time.

- **`vpc_connector`**: _(Optional `string`)_

  The VPC Network Connector that this cloud function can connect to. It should be set up as fully-qualified URI. The format of this field is `projects/*/locations/*/connectors/*`.

- **`vpc_connector_egress_settings`**: _(Optional `string`)_

  The egress settings for the connector, controlling what traffic is diverted through it. Allowed values are `ALL_TRAFFIC` and `PRIVATE_RANGES_ONLY`.
  Default is `PRIVATE_RANGES_ONLY`.

#### Extended Resource Configuration

- **`iam`**: _(Optional `list(iam)`)_

  A list of IAM access.

  Example

  ```hcl
  iam = [{
    role = "roles/secretmanager.admin"
    members = ["user:member@example.com"]
    authoritative = false
  }]
  ```

  Each `iam` object accepts the following fields:

  - **`members`**: **_(Required `list(string)`)_**

    Identities that will be granted the privilege in role. Each entry can have one of the following values:
    - `allUsers`: A special identifier that represents anyone who is on the internet; with or without a Google account.
    - `allAuthenticatedUsers`: A special identifier that represents anyone who is authenticated with a Google account or a service account.
    - `user:{emailid}`: An email address that represents a specific Google account. For example, alice@gmail.com or joe@example.com.
    - `serviceAccount:{emailid}`: An email address that represents a service account. For example, my-other-app@appspot.gserviceaccount.com.
    - `group:{emailid}`: An email address that represents a Google group. For example, admins@example.com.
    - `domain:{domain}`: A G Suite domain (primary, instead of alias) name that represents all the users of that domain. For example, google.com or example.com.

    Default is `[]`.

  - **`role`**: **_(Required `string`)_**

    The role that should be applied. Note that custom roles must be of the format `[projects|organizations]/{parent-name}/roles/{role-name}`.

  - **`authoritative`**: _(Optional `bool`)_

    Whether to exclusively set (authoritative mode) or add (non-authoritative/additive mode) members to the role.

    Default is `true`.

- **`policy_bindings`**: _(Optional `list(policy_bindings)`)_

  A list of IAM policy bindings.

  Example

  ```hcl
  policy_bindings = [{
    role    = "roles/secretmanager.admin"
    members = ["user:member@example.com"]
    condition = {
      title       = "expires_after_2021_12_31"
      description = "Expiring at midnight of 2021-12-31"
      expression  = "request.time < timestamp(\"2022-01-01T00:00:00Z\")"
    }
  }]
  ```

  Each `policy_bindings` object accepts the following fields:

  - **`role`**: **_(Required `string`)_**

    The role that should be applied.

  - **`members`**: **_(Required `string`)_**

    Identities that will be granted the privilege in `role`.

    Default is `var.members`.

  - **`condition`**: _(Optional `object(condition)`)_

    An IAM Condition for a given binding.

    Example

    ```hcl
    condition = {
      expression = "request.time < timestamp(\"2022-01-01T00:00:00Z\")"
      title      = "expires_after_2021_12_31"
    }
    ```

    A `condition` object accepts the following fields:

    - **`expression`**: **_(Required `string`)_**

      Textual representation of an expression in Common Expression Language syntax.

    - **`title`**: **_(Required `string`)_**

      A title for the expression, i.e. a short string describing its purpose.

    - **`description`**: _(Optional `string`)_

      An optional description of the expression. This is a longer text which describes the expression, e.g. when hovered over it in a UI.

##### Google storage archive bucket object

- **`bucket`**: _(Optional `string`)_

  The URI of the bucket that the archive that contains the function and its dependencies will be uploaded to.

- **`archive_upload_name`**: _(Optional `string`)_

  If provided, this value will overwrite the archive name on upload.  If a specific archive name is requested for the uploaded object, then override the archive name.

- **`source_archive`**: _(Optional `string`)_

  Path to the '.zip' archive that contains the source code of this Cloud Function.

## Module Attributes Reference

The following attributes are exported in the outputs of the module:

- **`module_enabled`**

  Whether this module is enabled.

- **`cloud_function`**

  All outputs of the created `\google_cloudfunctions_function\` resource.

- **`bucket_object`**

  All outputs of the created `\google_storage_bucket_object.archive\` resource.

## External Documentation

- Google Documentation:
  - Cloud function: <https://cloud.google.com/functions/docs>
  - Cloud function REST: <https://cloud.google.com/functions/docs/reference/rest/v1/projects.locations.functions>
  - Storage bucket object: <https://cloud.google.com/storage/docs/key-terms#objects>

- Terraform Google Provider Documentation:
  - <https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/cloudfunctions_function>
  - <https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket_object>

## Module Versioning

This Module follows the principles of [Semantic Versioning (SemVer)].

Given a version number `MAJOR.MINOR.PATCH`, we increment the:

1. `MAJOR` version when we make incompatible changes,
2. `MINOR` version when we add functionality in a backwards compatible manner, and
3. `PATCH` version when we make backwards compatible bug fixes.

### Backwards compatibility in `0.0.z` and `0.y.z` version

- Backwards compatibility in versions `0.0.z` is **not guaranteed** when `z` is increased. (Initial development)
- Backwards compatibility in versions `0.y.z` is **not guaranteed** when `y` is increased. (Pre-release)

## About Mineiros

[Mineiros][homepage] is a remote-first company headquartered in Berlin, Germany
that solves development, automation and security challenges in cloud infrastructure.

Our vision is to massively reduce time and overhead for teams to manage and
deploy production-grade and secure cloud infrastructure.

We offer commercial support for all of our modules and encourage you to reach out
if you have any questions or need help. Feel free to email us at [hello@mineiros.io] or join our
[Community Slack channel][slack].

## Reporting Issues

We use GitHub [Issues] to track community reported issues and missing features.

## Contributing

Contributions are always encouraged and welcome! For the process of accepting changes, we use
[Pull Requests]. If you'd like more information, please see our [Contribution Guidelines].

## Makefile Targets

This repository comes with a handy [Makefile].
Run `make help` to see details on each available target.

## License

[![license][badge-license]][apache20]

This module is licensed under the Apache License Version 2.0, January 2004.
Please see [LICENSE] for full details.

Copyright &copy; 2020-2021 [Mineiros GmbH][homepage]


<!-- References -->

[homepage]: https://mineiros.io/?ref=terraform-google-cloud-function
[hello@mineiros.io]: mailto:hello@mineiros.io

<!-- markdown-link-check-disable -->

[badge-build]: https://github.com/mineiros-io/terraform-google-cloud-function/workflows/Tests/badge.svg

<!-- markdown-link-check-enable -->

[badge-semver]: https://img.shields.io/github/v/tag/mineiros-io/terraform-google-cloud-function.svg?label=latest&sort=semver
[badge-license]: https://img.shields.io/badge/license-Apache%202.0-brightgreen.svg
[badge-terraform]: https://img.shields.io/badge/Terraform-1.x-623CE4.svg?logo=terraform
[badge-slack]: https://img.shields.io/badge/slack-@mineiros--community-f32752.svg?logo=slack

<!-- markdown-link-check-disable -->

[build-status]: https://github.com/mineiros-io/terraform-google-cloud-function/actions
[releases-github]: https://github.com/mineiros-io/terraform-google-cloud-function/releases

<!-- markdown-link-check-enable -->

[releases-terraform]: https://github.com/hashicorp/terraform/releases
[badge-tf-gcp]: https://img.shields.io/badge/google-3.x-1A73E8.svg?logo=terraform
[releases-google-provider]: https://github.com/terraform-providers/terraform-provider-google/releases
[apache20]: https://opensource.org/licenses/Apache-2.0
[slack]: https://join.slack.com/t/mineiros-community/shared_invite/zt-ehidestg-aLGoIENLVs6tvwJ11w9WGg
[terraform]: https://www.terraform.io
[cloud-function]: https://cloud.google.com/functions
[gcp]: https://cloud.google.com/
[semantic versioning (semver)]: https://semver.org/

<!-- markdown-link-check-disable -->

[variables.tf]: https://github.com/mineiros-io/terraform-google-cloud-function/blob/main/variables.tf
[examples/]: https://github.com/mineiros-io/terraform-google-cloud-function/blob/main/examples
[issues]: https://github.com/mineiros-io/terraform-google-cloud-function/issues
[license]: https://github.com/mineiros-io/terraform-google-cloud-function/blob/main/LICENSE
[makefile]: https://github.com/mineiros-io/terraform-google-cloud-function/blob/main/Makefile
[pull requests]: https://github.com/mineiros-io/terraform-google-cloud-function/pulls
[contribution guidelines]: https://github.com/mineiros-io/terraform-google-cloud-function/blob/main/CONTRIBUTING.md

<!-- markdown-link-check-enable -->