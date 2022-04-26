header {
  image = "https://raw.githubusercontent.com/mineiros-io/brand/3bffd30e8bdbbde32c143e2650b2faa55f1df3ea/mineiros-primary-logo.svg"
  url   = "https://mineiros.io/?ref=terraform-google-cloud-function"

  badge "build" {
    image = "https://github.com/mineiros-io/terraform-google-cloud-function/workflows/Tests/badge.svg"
    url   = "https://github.com/mineiros-io/terraform-google-cloud-function/actions"
    text  = "Build Status"
  }

  badge "semver" {
    image = "https://img.shields.io/github/v/tag/mineiros-io/terraform-google-cloud-function.svg?label=latest&sort=semver"
    url   = "https://github.com/mineiros-io/terraform-google-cloud-function/releases"
    text  = "GitHub tag (latest SemVer)"
  }

  badge "terraform" {
    image = "https://img.shields.io/badge/Terraform-1.x-623CE4.svg?logo=terraform"
    url   = "https://github.com/hashicorp/terraform/releases"
    text  = "Terraform Version"
  }

  badge "tf-gcp-provider" {
    image = "https://img.shields.io/badge/google-4-1A73E8.svg?logo=terraform"
    url   = "https://github.com/terraform-providers/terraform-provider-google/releases"
    text  = "Google Provider Version"
  }

  badge "slack" {
    image = "https://img.shields.io/badge/slack-@mineiros--community-f32752.svg?logo=slack"
    url   = "https://mineiros.io/slack"
    text  = "Join Slack"
  }
}

section {
  title   = "terraform-google-cloud-function"
  toc     = true
  content = <<-END
    A [Terraform](https://www.terraform.io) module to create a [Google Cloud Function](https://cloud.google.com/functions/docs) on [Google Cloud Services (GCP)](https://cloud.google.com/).

    **_This module supports Terraform version 1
    and is compatible with the Terraform Google Provider version 4._**

    This module is part of our Infrastructure as Code (IaC) framework
    that enables our users and customers to easily deploy and manage reusable,
    secure, and production-grade cloud infrastructure.
  END

  section {
    title   = "Module Features"
    content = <<-END
      A [Terraform] base module for creating a `google_cloudfunctions_function` resource that creates a new Cloud Function.

      In addition to creation of resource this module creates an accompanying `google_storage_bucket_object` for archiving.
      and supports additional features of the following modules:

      - [mineiros-io/terraform-google-cloud-function-iam](https://github.com/mineiros-io/terraform-google-cloud-function-iam)
    END
  }

  section {
    title   = "Getting Started"
    content = <<-END
      Most basic usage just setting required arguments:

      ```hcl
      module "terraform-google-cloud-function" {
        source = "github.com/mineiros-io/terraform-google-cloud-function.git?ref=v0.1.1"

        project     = "my-project"
        region      = "europe-west3"
        name        = "function-test"
        description = "My function"
        runtime     = "nodejs14"
      }
      ```
    END
  }

  section {
    title   = "Module Argument Reference"
    content = <<-END
      See [variables.tf] and [examples/] for details and use-cases.
    END

    section {
      title = "Top-level Arguments"

      section {
        title = "Module Configuration"

        variable "module_enabled" {
          type        = bool
          default     = true
          description = <<-END
            Specifies whether resources in the module will be created.
          END
        }

        variable "module_depends_on" {
          type           = list(dependency)
          description    = <<-END
            A list of dependencies. Any object can be _assigned_ to this list to define a hidden external dependency.
          END
          readme_example = <<-END
            module_depends_on = [
              google_network.network
            ]
          END
        }
      }

      section {
        title = "Main Resource Configuration"

        variable "region" {
          required    = true
          type        = string
          description = <<-END
            The region where the Cloud Function will be created.
          END
        }

        variable "project" {
          required    = true
          type        = string
          description = <<-END
            The ID of the project in which the resources belong.
          END
        }

        variable "name" {
          required    = true
          type        = string
          description = <<-END
            A user-defined name of the function. The function names must be unique globally.
          END
        }

        variable "runtime" {
          required    = true
          type        = string
          description = <<-END
            The runtime in which the function is going to run. Eg. `nodejs10`, `nodejs12`, `nodejs14`, `python37`, `python38`, `python39`, `dotnet3`, `go113`, `java11`, `ruby27`, etc.
          END
        }

        variable "source_repository" {
          type        = object(source_repository)
          description = <<-END
            Represents parameters related to source repository where a function is hosted. Cannot be set alongside `source_archive`. For details please see <https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/cloudfunctions_function#source_repository>
          END

          attribute "url" {
            required    = true
            type        = string
            description = <<-END
              The URL pointing to the hosted repository where the function is defined. There are supported Cloud Source Repository URLs in the following formats:
              - To refer to a specific commit: `https://source.developers.google.com/projects/*/repos/*/revisions/*/paths/*`
              - To refer to a moveable alias (branch): `https://source.developers.google.com/projects/*/repos/*/moveable-aliases/*/paths/*`. To refer to HEAD, use the master moveable alias.
              - To refer to a specific fixed alias (tag): `https://source.developers.google.com/projects/*/repos/*/fixed-aliases/*/paths/*`
            END
          }
        }

        variable "entry_point" {
          type        = string
          description = <<-END
            Name of the function that will be executed when the Google Cloud Function is triggered.
          END
        }

        variable "event_trigger" {
          type        = object(event_trigger)
          description = <<-END
            A source that fires events in response to a condition in another service. Structure is documented below. Cannot be used with `trigger_http`.
          END

          attribute "event_type" {
            required    = true
            type        = string
            description = <<-END
              The type of event to observe. For example: `google.storage.object.finalize`. See the documentation on calling [Cloud Functions](https://cloud.google.com/functions/docs/calling/) for a full reference of accepted triggers.
            END
          }

          attribute "resource" {
            required    = true
            type        = string
            description = <<-END
              The name or partial URI of the resource from which to observe events. For example, `myBucket` or `projects/my-project/topics/my-topic`.
            END
          }

          attribute "failure_policy" {
            type        = object(failure_policy)
            description = <<-END
              Specifies policy for failed executions.

              A `failure_policy` object can have the following field:
            END

            attribute "retry" {
              required    = true
              type        = bool
              default     = false
              description = <<-END
                Whether the function should be retried on failure.
              END
            }
          }
        }

        variable "trigger_http" {
          type        = bool
          default     = false
          description = <<-END
            Boolean variable. Any HTTP request (of a supported type) to the endpoint will trigger function execution. Supported HTTP request types are: `POST`, `PUT`, `GET`, `DELETE`, and `OPTIONS`. Endpoint is returned as `https_trigger_url`. Cannot be used with `event_trigger`.
          END
        }

        variable "description" {
          type        = bool
          description = <<-END
            The description of the function.
          END
        }

        variable "timeout" {
          type        = number
          default     = 60
          description = <<-END
            (Optional) Timeout (in seconds) for the function. Cannot be more than `540` seconds.
          END
        }

        variable "available_memory_mb" {
          type        = number
          default     = 128
          description = <<-END
            Memory (in MB), available to the function. Possible values include `128`, `256`, `512`, `1024`, etc.
          END
        }

        variable "max_instances" {
          type        = number
          description = <<-END
            The limit on the maximum number of function instances that may coexist at a given time. Setting maximum instances to `0` results in clearing existing maximum instances limits. Setting a `0` value does not pause your function.
          END
        }

        variable "ingress_settings" {
          type        = string
          default     = "ALLOW_INTERNAL_ONLY"
          description = <<-END
            String value that controls what traffic can reach the function. Allowed values are `ALLOW_ALL`, `ALLOW_INTERNAL_AND_GCLB` and `ALLOW_INTERNAL_ONLY`. Changes to this field will recreate the cloud function.
          END
        }

        variable "labels" {
          type        = map(string)
          default     = {}
          description = <<-END
            A set of key/value label pairs to assign to the function. Label keys must follow the requirements at <https://cloud.google.com/resource-manager/docs/creating-managing-labels#requirements>.
          END
        }

        variable "service_account_email" {
          type        = string
          description = <<-END
            If defined, use the provided service account to run the function.
          END
        }

        variable "environment_variables" {
          type        = map(string)
          default     = {}
          description = <<-END
            A set of key/value environment variable pairs to assign to the function.
          END
        }

        variable "build_environment_variables" {
          type        = map(string)
          description = <<-END
            A set of key/value environment variable pairs available during build time.
          END
        }

        variable "vpc_connector" {
          type        = string
          description = <<-END
            The VPC Network Connector that this cloud function can connect to. It should be set up as fully-qualified URI. The format of this field is `projects/*/locations/*/connectors/*`.
          END
        }

        variable "vpc_connector_egress_settings" {
          type        = string
          default     = "PRIVATE_RANGES_ONLY"
          description = <<-END
            The egress settings for the connector, controlling what traffic is diverted through it. Allowed values are `ALL_TRAFFIC` and `PRIVATE_RANGES_ONLY`.
          END
        }

        variable "secret_environment_variables" {
          type           = list(secret_environment_variables)
          description    = <<-END
            Secret environment variables configuration.
          END
          readme_example = <<-END
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
          END

          attribute "key" {
            required    = true
            type        = string
            description = <<-END
              Name of the environment variable.
            END
          }

          attribute "project_id" {
            required    = false
            type        = string
            description = <<-END
              Project identifier (due to a known limitation, only project number is supported by this field) of the project that contains the secret. If not set, it will be populated with the function's project, assuming that the secret exists in the same project as of the function.
            END
          }

          attribute "secret" {
            required    = true
            type        = string
            description = <<-END
              ID of the secret in secret manager (not the full resource name).
            END
          }

          attribute "version" {
            required    = true
            type        = string
            description = <<-END
              Version of the secret (version number or the string "latest"). It is recommended to use a numeric version for secret environment variables as any updates to the secret value is not reflected until new clones start.
            END
          }
        }
      }

      section {
        title = "Extended Resource Configuration"

        variable "iam" {
          type           = list(iam)
          description    = <<-END
            A list of IAM access.
          END
          readme_example = <<-END
            iam = [{
              role          = "roles/secretmanager.admin"
              members       = ["user:member@example.com"]
              authoritative = false
            }]
          END

          attribute "members" {
            type        = set(string)
            default     = []
            description = <<-END
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
            END
          }

          attribute "role" {
            type        = string
            description = <<-END
              The role that should be applied. Note that custom roles must be of the format `[projects|organizations]/{parent-name}/roles/{role-name}`.
            END
          }

          attribute "authoritative" {
            type        = bool
            default     = true
            description = <<-END
              Whether to exclusively set (authoritative mode) or add (non-authoritative/additive mode) members to the role.
            END
          }
        }

        variable "policy_bindings" {
          type           = list(policy_binding)
          description    = <<-END
            A list of IAM policy bindings.
          END
          readme_example = <<-END
            policy_bindings = [{
              role      = "roles/secretmanager.admin"
              members   = ["user:member@example.com"]
              condition = {
                title       = "expires_after_2021_12_31"
                description = "Expiring at midnight of 2021-12-31"
                expression  = "request.time < timestamp(\"2022-01-01T00:00:00Z\")"
              }
            }]
          END

          attribute "role" {
            required    = true
            type        = string
            description = <<-END
              The role that should be applied.
            END
          }

          attribute "members" {
            type        = set(string)
            default     = var.members
            description = <<-END
              Identities that will be granted the privilege in `role`.
            END
          }

          attribute "condition" {
            type           = object(condition)
            description    = <<-END
              An IAM Condition for a given binding.
            END
            readme_example = <<-END
              condition = {
                expression = "request.time < timestamp(\"2022-01-01T00:00:00Z\")"
                title      = "expires_after_2021_12_31"
              }
            END

            attribute "expression" {
              required    = true
              type        = string
              description = <<-END
                Textual representation of an expression in Common Expression Language syntax.
              END
            }

            attribute "title" {
              required    = true
              type        = string
              description = <<-END
                A title for the expression, i.e. a short string describing its purpose.
              END
            }

            attribute "description" {
              type        = string
              description = <<-END
                An optional description of the expression. This is a longer text which describes the expression, e.g. when hovered over it in a UI.
              END
            }
          }
        }

        section {
          title = "Google storage archive bucket object"

          variable "bucket" {
            type        = string
            required    = true
            description = <<-END
              The URI of the bucket that the archive that contains the function and its dependencies will be uploaded to.
            END
          }

          variable "archive_upload_name" {
            type        = string
            description = <<-END
              If provided, this value will overwrite the archive name on upload.  If a specific archive name is requested for the uploaded object, then override the archive name.
            END
          }

          variable "source_archive" {
            type        = string
            required    = true
            description = <<-END
              Path to the '.zip' archive that contains the source code of this Cloud Function.
            END
          }
        }
      }
    }
  }

  section {
    title   = "Module Outputs"
    content = <<-END
      The following attributes are exported in the outputs of the module:
    END

    output "module_enabled" {
      type        = bool
      description = <<-END
        Whether this module is enabled.
      END
    }

    output "cloud_function" {
      type        = object(cloud_function)
      description = <<-END
        All outputs of the created `google_cloudfunctions_function` resource.
      END
    }

    output "bucket_object" {
      type        = object(bucket_object)
      description = <<-END
        All outputs of the created `google_storage_bucket_object`
        resource.
      END
    }

    output "iam" {
      type        = list(iam)
      description = <<-END
        The `iam` resource objects that define the access to the cloud function.
      END
    }
  }

  section {
    title = "External Documentation"

    section {
      title   = "Google Documentation"
      content = <<-END
        - Cloud function: <https://cloud.google.com/functions/docs>
        - Cloud function REST: <https://cloud.google.com/functions/docs/reference/rest/v1/projects.locations.functions>
        - Storage bucket object: <https://cloud.google.com/storage/docs/key-terms#objects>
      END
    }

    section {
      title   = "Terraform Google Provider Documentation"
      content = <<-END
        - <https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/cloudfunctions_function>
        - <https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket_object>
      END
    }
  }

  section {
    title   = "Module Versioning"
    content = <<-END
      This Module follows the principles of [Semantic Versioning (SemVer)].

      Given a version number `MAJOR.MINOR.PATCH`, we increment the:

      1. `MAJOR` version when we make incompatible changes,
      2. `MINOR` version when we add functionality in a backwards compatible manner, and
      3. `PATCH` version when we make backwards compatible bug fixes.
    END

    section {
      title   = "Backwards compatibility in `0.0.z` and `0.y.z` version"
      content = <<-END
        - Backwards compatibility in versions `0.0.z` is **not guaranteed** when `z` is increased. (Initial development)
        - Backwards compatibility in versions `0.y.z` is **not guaranteed** when `y` is increased. (Pre-release)
      END
    }
  }

  section {
    title   = "About Mineiros"
    content = <<-END
      [Mineiros][homepage] is a remote-first company headquartered in Berlin, Germany
      that solves development, automation and security challenges in cloud infrastructure.

      Our vision is to massively reduce time and overhead for teams to manage and
      deploy production-grade and secure cloud infrastructure.

      We offer commercial support for all of our modules and encourage you to reach out
      if you have any questions or need help. Feel free to email us at [hello@mineiros.io] or join our
      [Community Slack channel][slack].
    END
  }

  section {
    title   = "Reporting Issues"
    content = <<-END
      We use GitHub [Issues] to track community reported issues and missing features.
    END
  }

  section {
    title   = "Contributing"
    content = <<-END
      Contributions are always encouraged and welcome! For the process of accepting changes, we use
      [Pull Requests]. If you'd like more information, please see our [Contribution Guidelines].
    END
  }

  section {
    title   = "Makefile Targets"
    content = <<-END
      This repository comes with a handy [Makefile].
      Run `make help` to see details on each available target.
    END
  }

  section {
    title   = "License"
    content = <<-END
      [![license][badge-license]][apache20]

      This module is licensed under the Apache License Version 2.0, January 2004.
      Please see [LICENSE] for full details.

      Copyright &copy; 2020-2022 [Mineiros GmbH][homepage]
    END
  }
}

references {
  ref "homepage" {
    value = "https://mineiros.io/?ref=terraform-google-cloud-function"
  }
  ref "hello@mineiros.io" {
    value = "mailto:hello@mineiros.io"
  }
  ref "badge-build" {
    value = "https://github.com/mineiros-io/terraform-google-cloud-function/workflows/Tests/badge.svg"
  }
  ref "badge-semver" {
    value = "https://img.shields.io/github/v/tag/mineiros-io/terraform-google-cloud-function.svg?label=latest&sort=semver"
  }
  ref "badge-license" {
    value = "https://img.shields.io/badge/license-Apache%202.0-brightgreen.svg"
  }
  ref "badge-terraform" {
    value = "https://img.shields.io/badge/Terraform-1.x-623CE4.svg?logo=terraform"
  }
  ref "badge-slack" {
    value = "https://img.shields.io/badge/slack-@mineiros--community-f32752.svg?logo=slack"
  }
  ref "build-status" {
    value = "https://github.com/mineiros-io/terraform-google-cloud-function/actions"
  }
  ref "releases-github" {
    value = "https://github.com/mineiros-io/terraform-google-cloud-function/releases"
  }
  ref "releases-terraform" {
    value = "https://github.com/hashicorp/terraform/releases"
  }
  ref "badge-tf-gcp" {
    value = "https://img.shields.io/badge/google-3.x-1A73E8.svg?logo=terraform"
  }
  ref "releases-google-provider" {
    value = "https://github.com/terraform-providers/terraform-provider-google/releases"
  }
  ref "apache20" {
    value = "https://opensource.org/licenses/Apache-2.0"
  }
  ref "slack" {
    value = "https://join.slack.com/t/mineiros-community/shared_invite/zt-ehidestg-aLGoIENLVs6tvwJ11w9WGg"
  }
  ref "terraform" {
    value = "https://www.terraform.io"
  }
  ref "cloud-function" {
    value = "https://cloud.google.com/functions"
  }
  ref "gcp" {
    value = "https://cloud.google.com/"
  }
  ref "semantic versioning (semver)" {
    value = "https://semver.org/"
  }
  ref "variables.tf" {
    value = "https://github.com/mineiros-io/terraform-google-cloud-function/blob/main/variables.tf"
  }
  ref "examples/" {
    value = "https://github.com/mineiros-io/terraform-google-cloud-function/blob/main/examples"
  }
  ref "issues" {
    value = "https://github.com/mineiros-io/terraform-google-cloud-function/issues"
  }
  ref "license" {
    value = "https://github.com/mineiros-io/terraform-google-cloud-function/blob/main/LICENSE"
  }
  ref "makefile" {
    value = "https://github.com/mineiros-io/terraform-google-cloud-function/blob/main/Makefile"
  }
  ref "pull requests" {
    value = "https://github.com/mineiros-io/terraform-google-cloud-function/pulls"
  }
  ref "contribution guidelines" {
    value = "https://github.com/mineiros-io/terraform-google-cloud-function/blob/main/CONTRIBUTING.md"
  }
}
