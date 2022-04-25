[<img src="https://raw.githubusercontent.com/mineiros-io/brand/3bffd30e8bdbbde32c143e2650b2faa55f1df3ea/mineiros-primary-logo.svg" width="400"/>](https://mineiros.io/?ref=terraform-google-cloud-function)

[![Build Status](https://github.com/mineiros-io/terraform-google-cloud-function/workflows/Tests/badge.svg)](https://github.com/mineiros-io/terraform-google-cloud-function/actions)
[![GitHub tag (latest SemVer)](https://img.shields.io/github/v/tag/mineiros-io/terraform-google-cloud-function.svg?label=latest&sort=semver)](https://github.com/mineiros-io/terraform-google-cloud-function/releases)
[![Terraform Version](https://img.shields.io/badge/Terraform-1.x-623CE4.svg?logo=terraform)](https://github.com/hashicorp/terraform/releases)
[![Google Provider Version](https://img.shields.io/badge/google-4-1A73E8.svg?logo=terraform)](https://github.com/terraform-providers/terraform-provider-google/releases)
[![Join Slack](https://img.shields.io/badge/slack-@mineiros--community-f32752.svg?logo=slack)](https://mineiros.io/slack)

# terraform-google-cloud-function

A [Terraform](https://www.terraform.io) module to create a [Google Cloud Function](https://cloud.google.com/functions/docs) on [Google Cloud Services (GCP)](https://cloud.google.com/).

**_This module supports Terraform version 1
and is compatible with the Terraform Google Provider version 4._**

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
- [Module Outputs](#module-outputs)
- [External Documentation](#external-documentation)
  - [Google Documentation](#google-documentation)
  - [Terraform Google Provider Documentation](#terraform-google-provider-documentation)
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
and supports additional features of the following modules:

- [mineiros-io/terraform-google-cloud-function-iam](https://github.com/mineiros-io/terraform-google-cloud-function-iam)

## Getting Started

Most basic usage just setting required arguments:

```hcl
module "terraform-google-cloud-function" {
  source = "github.com/mineiros-io/terraform-google-cloud-function.git?ref=v0.0.2"

  project     = google_cloudfunctions_function.function.project
  region      = google_cloudfunctions_function.function.region
  name        = "function-test"
  description = "My function"
  runtime     = "nodejs14"
}
```

## Module Argument Reference

See [variables.tf] and [examples/] for details and use-cases.

### Top-level Arguments

#### Module Configuration

- [**`module_enabled`**](#var-module_enabled): *(Optional `bool`)*<a name="var-module_enabled"></a>

  Specifies whether resources in the module will be created.

  Default is `true`.

- [**`module_depends_on`**](#var-module_depends_on): *(Optional `list(dependency)`)*<a name="var-module_depends_on"></a>

  A list of dependencies. Any object can be _assigned_ to this list to define a hidden external dependency.

  Example:

  ```hcl
  module_depends_on = [
    google_network.network
  ]
  ```

#### Main Resource Configuration

- [**`region`**](#var-region): *(**Required** `string`)*<a name="var-region"></a>

  The region where the Cloud Function will be created.

- [**`project`**](#var-project): *(**Required** `string`)*<a name="var-project"></a>

  The ID of the project in which the resources belong.

- [**`name`**](#var-name): *(**Required** `string`)*<a name="var-name"></a>

  A user-defined name of the function. The function names must be unique globally.

- [**`runtime`**](#var-runtime): *(**Required** `string`)*<a name="var-runtime"></a>

  The runtime in which the function is going to run. Eg. `nodejs10`, `nodejs12`, `nodejs14`, `python37`, `python38`, `python39`, `dotnet3`, `go113`, `java11`, `ruby27`, etc.

- [**`source_repository`**](#var-source_repository): *(Optional `object(source_repository)`)*<a name="var-source_repository"></a>

  Represents parameters related to source repository where a function is hosted. Cannot be set alongside `source_archive`. For details please see <https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/cloudfunctions_function#source_repository>

  The `source_repository` object accepts the following attributes:

  - [**`url`**](#attr-source_repository-url): *(**Required** `string`)*<a name="attr-source_repository-url"></a>

    The URL pointing to the hosted repository where the function is defined. There are supported Cloud Source Repository URLs in the following formats:
    - To refer to a specific commit: `https://source.developers.google.com/projects/*/repos/*/revisions/*/paths/*`
    - To refer to a moveable alias (branch): `https://source.developers.google.com/projects/*/repos/*/moveable-aliases/*/paths/*`. To refer to HEAD, use the master moveable alias.
    - To refer to a specific fixed alias (tag): `https://source.developers.google.com/projects/*/repos/*/fixed-aliases/*/paths/*`

- [**`entry_point`**](#var-entry_point): *(Optional `string`)*<a name="var-entry_point"></a>

  Name of the function that will be executed when the Google Cloud Function is triggered.

- [**`event_trigger`**](#var-event_trigger): *(Optional `object(event_trigger)`)*<a name="var-event_trigger"></a>

  A source that fires events in response to a condition in another service. Structure is documented below. Cannot be used with `trigger_http`.

  The `event_trigger` object accepts the following attributes:

  - [**`event_type`**](#attr-event_trigger-event_type): *(**Required** `string`)*<a name="attr-event_trigger-event_type"></a>

    The type of event to observe. For example: `google.storage.object.finalize`. See the documentation on calling [Cloud Functions](https://cloud.google.com/functions/docs/calling/) for a full reference of accepted triggers.

  - [**`resource`**](#attr-event_trigger-resource): *(**Required** `string`)*<a name="attr-event_trigger-resource"></a>

    The name or partial URI of the resource from which to observe events. For example, `myBucket` or `projects/my-project/topics/my-topic`.

  - [**`failure_policy`**](#attr-event_trigger-failure_policy): *(Optional `object(failure_policy)`)*<a name="attr-event_trigger-failure_policy"></a>

    Specifies policy for failed executions.

    A `failure_policy` object can have the following field:

    The `failure_policy` object accepts the following attributes:

    - [**`retry`**](#attr-event_trigger-failure_policy-retry): *(**Required** `bool`)*<a name="attr-event_trigger-failure_policy-retry"></a>

      Whether the function should be retried on failure.

      Default is `false`.

- [**`trigger_http`**](#var-trigger_http): *(Optional `bool`)*<a name="var-trigger_http"></a>

  Boolean variable. Any HTTP request (of a supported type) to the endpoint will trigger function execution. Supported HTTP request types are: `POST`, `PUT`, `GET`, `DELETE`, and `OPTIONS`. Endpoint is returned as `https_trigger_url`. Cannot be used with `event_trigger`.

  Default is `false`.

- [**`description`**](#var-description): *(Optional `bool`)*<a name="var-description"></a>

  The description of the function.

- [**`timeout`**](#var-timeout): *(Optional `number`)*<a name="var-timeout"></a>

  (Optional) Timeout (in seconds) for the function. Cannot be more than `540` seconds.

  Default is `60`.

- [**`available_memory_mb`**](#var-available_memory_mb): *(Optional `number`)*<a name="var-available_memory_mb"></a>

  Memory (in MB), available to the function. Possible values include `128`, `256`, `512`, `1024`, etc.

  Default is `128`.

- [**`max_instances`**](#var-max_instances): *(Optional `number`)*<a name="var-max_instances"></a>

  The limit on the maximum number of function instances that may coexist at a given time. Setting maximum instances to `0` results in clearing existing maximum instances limits. Setting a `0` value does not pause your function.

- [**`ingress_settings`**](#var-ingress_settings): *(Optional `string`)*<a name="var-ingress_settings"></a>

  String value that controls what traffic can reach the function. Allowed values are `ALLOW_ALL`, `ALLOW_INTERNAL_AND_GCLB` and `ALLOW_INTERNAL_ONLY`. Changes to this field will recreate the cloud function.

  Default is `"ALLOW_INTERNAL_ONLY"`.

- [**`labels`**](#var-labels): *(Optional `map(string)`)*<a name="var-labels"></a>

  A set of key/value label pairs to assign to the function. Label keys must follow the requirements at <https://cloud.google.com/resource-manager/docs/creating-managing-labels#requirements>.

  Default is `{}`.

- [**`service_account_email`**](#var-service_account_email): *(Optional `string`)*<a name="var-service_account_email"></a>

  If defined, use the provided service account to run the function.

- [**`environment_variables`**](#var-environment_variables): *(Optional `map(string)`)*<a name="var-environment_variables"></a>

  A set of key/value environment variable pairs to assign to the function.

  Default is `{}`.

- [**`build_environment_variables`**](#var-build_environment_variables): *(Optional `map(string)`)*<a name="var-build_environment_variables"></a>

  A set of key/value environment variable pairs available during build time.

- [**`vpc_connector`**](#var-vpc_connector): *(Optional `string`)*<a name="var-vpc_connector"></a>

  The VPC Network Connector that this cloud function can connect to. It should be set up as fully-qualified URI. The format of this field is `projects/*/locations/*/connectors/*`.

- [**`vpc_connector_egress_settings`**](#var-vpc_connector_egress_settings): *(Optional `string`)*<a name="var-vpc_connector_egress_settings"></a>

  The egress settings for the connector, controlling what traffic is diverted through it. Allowed values are `ALL_TRAFFIC` and `PRIVATE_RANGES_ONLY`.

  Default is `"PRIVATE_RANGES_ONLY"`.

- [**`secret_environment_variables`**](#var-secret_environment_variables): *(Optional `object(secret_environment_variables)`)*<a name="var-secret_environment_variables"></a>

  Secret environment variables configuration.

  The `secret_environment_variables` object accepts the following attributes:

  - [**`key`**](#attr-secret_environment_variables-key): *(**Required** `string`)*<a name="attr-secret_environment_variables-key"></a>

    Name of the environment variable.

  - [**`project_id`**](#attr-secret_environment_variables-project_id): *(Optional `string`)*<a name="attr-secret_environment_variables-project_id"></a>

    Project identifier (due to a known limitation, only project number is supported by this field) of the project that contains the secret. If not set, it will be populated with the function's project, assuming that the secret exists in the same project as of the function.

  - [**`secret`**](#attr-secret_environment_variables-secret): *(**Required** `string`)*<a name="attr-secret_environment_variables-secret"></a>

    ID of the secret in secret manager (not the full resource name).

  - [**`version`**](#attr-secret_environment_variables-version): *(**Required** `string`)*<a name="attr-secret_environment_variables-version"></a>

    Version of the secret (version number or the string "latest"). It is recommended to use a numeric version for secret environment variables as any updates to the secret value is not reflected until new clones start.

#### Extended Resource Configuration

- [**`iam`**](#var-iam): *(Optional `list(iam)`)*<a name="var-iam"></a>

  A list of IAM access.

  Example:

  ```hcl
  iam = [{
    role          = "roles/secretmanager.admin"
    members       = ["user:member@example.com"]
    authoritative = false
  }]
  ```

  Each `iam` object in the list accepts the following attributes:

  - [**`members`**](#attr-iam-members): *(Optional `set(string)`)*<a name="attr-iam-members"></a>

    Identities that will be granted the privilege in role. Each entry can have one of the following values:
    - `allUsers`: A special identifier that represents anyone who is on the internet; with or without a Google account.
    - `allAuthenticatedUsers`: A special identifier that represents anyone who is authenticated with a Google account or a service account.
    - `user:{emailid}`: An email address that represents a specific Google account. For example, alice@example.com or joe@example.com.
    - `serviceAccount:{emailid}`: An email address that represents a service account. For example, my-other-app@appspot.gserviceaccount.com.
    - `group:{emailid}`: An email address that represents a Google group. For example, admins@example.com.
    - `domain:{domain}`: A G Suite domain (primary, instead of alias) name that represents all the users of that domain. For example, google.com or example.com.
    - `projectOwner:projectid`: Owners of the given project. For example, `projectOwner:my-example-project`
    - `projectEditor:projectid`: Editors of the given project. For example, `projectEditor:my-example-project`
    - `projectViewer:projectid`: Viewers of the given project. For example, `projectViewer:my-example-project`

    Default is `[]`.

  - [**`role`**](#attr-iam-role): *(Optional `string`)*<a name="attr-iam-role"></a>

    The role that should be applied. Note that custom roles must be of the format `[projects|organizations]/{parent-name}/roles/{role-name}`.

  - [**`authoritative`**](#attr-iam-authoritative): *(Optional `bool`)*<a name="attr-iam-authoritative"></a>

    Whether to exclusively set (authoritative mode) or add (non-authoritative/additive mode) members to the role.

    Default is `true`.

- [**`policy_bindings`**](#var-policy_bindings): *(Optional `list(policy_binding)`)*<a name="var-policy_bindings"></a>

  A list of IAM policy bindings.

  Example:

  ```hcl
  policy_bindings = [{
    role      = "roles/secretmanager.admin"
    members   = ["user:member@example.com"]
    condition = {
      title       = "expires_after_2021_12_31"
      description = "Expiring at midnight of 2021-12-31"
      expression  = "request.time < timestamp(\"2022-01-01T00:00:00Z\")"
    }
  }]
  ```

  Each `policy_binding` object in the list accepts the following attributes:

  - [**`role`**](#attr-policy_bindings-role): *(**Required** `string`)*<a name="attr-policy_bindings-role"></a>

    The role that should be applied.

  - [**`members`**](#attr-policy_bindings-members): *(Optional `set(string)`)*<a name="attr-policy_bindings-members"></a>

    Identities that will be granted the privilege in `role`.

    Default is `var.members`.

  - [**`condition`**](#attr-policy_bindings-condition): *(Optional `object(condition)`)*<a name="attr-policy_bindings-condition"></a>

    An IAM Condition for a given binding.

    Example:

    ```hcl
    condition = {
      expression = "request.time < timestamp(\"2022-01-01T00:00:00Z\")"
      title      = "expires_after_2021_12_31"
    }
    ```

    The `condition` object accepts the following attributes:

    - [**`expression`**](#attr-policy_bindings-condition-expression): *(**Required** `string`)*<a name="attr-policy_bindings-condition-expression"></a>

      Textual representation of an expression in Common Expression Language syntax.

    - [**`title`**](#attr-policy_bindings-condition-title): *(**Required** `string`)*<a name="attr-policy_bindings-condition-title"></a>

      A title for the expression, i.e. a short string describing its purpose.

    - [**`description`**](#attr-policy_bindings-condition-description): *(Optional `string`)*<a name="attr-policy_bindings-condition-description"></a>

      An optional description of the expression. This is a longer text which describes the expression, e.g. when hovered over it in a UI.

##### Google storage archive bucket object

- [**`bucket`**](#var-bucket): *(**Required** `string`)*<a name="var-bucket"></a>

  The URI of the bucket that the archive that contains the function and its dependencies will be uploaded to.

- [**`archive_upload_name`**](#var-archive_upload_name): *(Optional `string`)*<a name="var-archive_upload_name"></a>

  If provided, this value will overwrite the archive name on upload.  If a specific archive name is requested for the uploaded object, then override the archive name.

- [**`source_archive`**](#var-source_archive): *(**Required** `string`)*<a name="var-source_archive"></a>

  Path to the '.zip' archive that contains the source code of this Cloud Function.

## Module Outputs

The following attributes are exported in the outputs of the module:

- [**`module_enabled`**](#output-module_enabled): *(`bool`)*<a name="output-module_enabled"></a>

  Whether this module is enabled.

- [**`cloud_function`**](#output-cloud_function): *(`object(cloud_function)`)*<a name="output-cloud_function"></a>

  All outputs of the created `google_cloudfunctions_function` resource.

- [**`bucket_object`**](#output-bucket_object): *(`object(bucket_object)`)*<a name="output-bucket_object"></a>

  All outputs of the created `google_storage_bucket_object`
  resource.

- [**`iam`**](#output-iam): *(`list(iam)`)*<a name="output-iam"></a>

  The `iam` resource objects that define the access to the cloud function.

## External Documentation

### Google Documentation

- Cloud function: <https://cloud.google.com/functions/docs>
- Cloud function REST: <https://cloud.google.com/functions/docs/reference/rest/v1/projects.locations.functions>
- Storage bucket object: <https://cloud.google.com/storage/docs/key-terms#objects>

### Terraform Google Provider Documentation

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

Copyright &copy; 2020-2022 [Mineiros GmbH][homepage]


<!-- References -->

[homepage]: https://mineiros.io/?ref=terraform-google-cloud-function
[hello@mineiros.io]: mailto:hello@mineiros.io
[badge-build]: https://github.com/mineiros-io/terraform-google-cloud-function/workflows/Tests/badge.svg
[badge-semver]: https://img.shields.io/github/v/tag/mineiros-io/terraform-google-cloud-function.svg?label=latest&sort=semver
[badge-license]: https://img.shields.io/badge/license-Apache%202.0-brightgreen.svg
[badge-terraform]: https://img.shields.io/badge/Terraform-1.x-623CE4.svg?logo=terraform
[badge-slack]: https://img.shields.io/badge/slack-@mineiros--community-f32752.svg?logo=slack
[build-status]: https://github.com/mineiros-io/terraform-google-cloud-function/actions
[releases-github]: https://github.com/mineiros-io/terraform-google-cloud-function/releases
[releases-terraform]: https://github.com/hashicorp/terraform/releases
[badge-tf-gcp]: https://img.shields.io/badge/google-3.x-1A73E8.svg?logo=terraform
[releases-google-provider]: https://github.com/terraform-providers/terraform-provider-google/releases
[apache20]: https://opensource.org/licenses/Apache-2.0
[slack]: https://join.slack.com/t/mineiros-community/shared_invite/zt-ehidestg-aLGoIENLVs6tvwJ11w9WGg
[terraform]: https://www.terraform.io
[cloud-function]: https://cloud.google.com/functions
[gcp]: https://cloud.google.com/
[semantic versioning (semver)]: https://semver.org/
[variables.tf]: https://github.com/mineiros-io/terraform-google-cloud-function/blob/main/variables.tf
[examples/]: https://github.com/mineiros-io/terraform-google-cloud-function/blob/main/examples
[issues]: https://github.com/mineiros-io/terraform-google-cloud-function/issues
[license]: https://github.com/mineiros-io/terraform-google-cloud-function/blob/main/LICENSE
[makefile]: https://github.com/mineiros-io/terraform-google-cloud-function/blob/main/Makefile
[pull requests]: https://github.com/mineiros-io/terraform-google-cloud-function/pulls
[contribution guidelines]: https://github.com/mineiros-io/terraform-google-cloud-function/blob/main/CONTRIBUTING.md
