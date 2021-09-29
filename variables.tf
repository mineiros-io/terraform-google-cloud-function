# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED VARIABLES
# These variables must be set when using this module.
# ---------------------------------------------------------------------------------------------------------------------

variable "region" {
  description = "(Required) The region where the Cloud Function will be created."
  type        = string
}

variable "project" {
  description = "(Required) The ID of the project in which the resources belong."
  type        = string
}

variable "name" {
  description = "(Required) A user-defined name of the function. The function names must be unique globally."
  type        = string
}

variable "runtime" {
  description = "(Required) The runtime in which the function is going to run. Eg. 'nodejs10', 'nodejs12', 'nodejs14', 'python37', 'python38', 'python39', 'dotnet3', 'go113', 'java11', 'ruby27', etc."
  type        = string
}

# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL VARIABLES
# These variables have defaults, but may be overridden.
# ---------------------------------------------------------------------------------------------------------------------

variable "source_archive" {
  description = "(Optional) Path to the '.zip' archive that contains the source code of this Cloud Function."
  default     = null
}

variable "archive_upload_name" {
  description = "(Optional) If provided, this value will overwrite the archive name on upload."
  default     = null
}

variable "source_repository" {
  description = "(Optional) Represents parameters related to source repository where a function is hosted. Cannot be set alongside 'source_archive'. For details please see https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/cloudfunctions_function#source_repository"
  type        = object({ url = string })
  default     = null
}

variable "bucket" {
  description = "(Optional) The URI of the bucket that the archive that contains the function and its dependencies will be uploaded to."
  type        = string
  default     = null
}

variable "entry_point" {
  description = "(Optional) Name of the function that will be executed when the Google Cloud Function is triggered."
  type        = string
  default     = null
}

variable "event_trigger" {
  description = "(Optional) A source that fires events in response to a condition in another service. Structure is documented below. Cannot be used with 'trigger_http'."
  type        = any
  # object({
  #   event_type = string
  #   resource   = string
  #   failure_policy = object({
  #     retry = optional(bool)
  #   })
  # })
  default = null
}

variable "description" {
  description = "(Optional) The description of the function."
  default     = null
}

variable "available_memory_mb" {
  description = "(Optional) Memory (in MB), available to the function. Possible values include 128, 256, 512, 1024, etc."
  default     = 128
}

variable "timeout" {
  description = "(Optional) Timeout (in seconds) for the function. Cannot be more than 540 seconds."
  type        = number
  default     = 60
}

variable "max_instances" {
  description = "(Optional) The limit on the maximum number of function instances that may coexist at a given time."
  type        = number
  default     = null
}

variable "trigger_http" {
  description = "(Optional) Boolean variable. Any HTTP request (of a supported type) to the endpoint will trigger function execution. Supported HTTP request types are: POST, PUT, GET, DELETE, and OPTIONS. Endpoint is returned as 'https_trigger_url'. Cannot be used with 'trigger_bucket' and 'trigger_topic'."
  type        = bool
  default     = false
}

variable "ingress_settings" {
  description = "(Optional) String value that controls what traffic can reach the function. Allowed values are 'ALLOW_ALL', 'ALLOW_INTERNAL_AND_GCLB' and 'ALLOW_INTERNAL_ONLY'. Changes to this field will recreate the cloud function."
  type        = string
  default     = "ALLOW_INTERNAL_ONLY"
}

variable "labels" {
  description = "(Optional) A set of key/value label pairs to assign to the function. Label keys must follow the requirements at https://cloud.google.com/resource-manager/docs/creating-managing-labels#requirements."
  type        = map(string)
  default     = {}
}

variable "service_account_email" {
  description = "(Optional) If defined, use the provided service account to run the function."
  type        = string
  default     = null
}

variable "environment_variables" {
  description = "(Optional) A set of key/value environment variable pairs to assign to the function."
  type        = map(string)
  default     = {}
}

variable "build_environment_variables" {
  description = "(Optional) A set of key/value environment variable pairs available during build time."
  type        = map(string)
  default     = null
}

variable "vpc_connector" {
  description = "(Optional) The VPC Network Connector that this cloud function can connect to. It should be set up as fully-qualified URI. The format of this field is 'projects/*/locations/*/connectors/*'."
  type        = string
  default     = null
}

variable "vpc_connector_egress_settings" {
  description = "(Optional) The egress settings for the connector, controlling what traffic is diverted through it. Allowed values are 'ALL_TRAFFIC' and 'PRIVATE_RANGES_ONLY'."
  type        = string
  default     = "PRIVATE_RANGES_ONLY"
}

# ------------------------------------------------------------------------------
# MODULE CONFIGURATION PARAMETERS
# These variables are used to configure the module.
# ------------------------------------------------------------------------------

variable "module_enabled" {
  type        = bool
  description = "(Optional) Whether to create resources within the module or not. Default is 'true'."
  default     = true
}

variable "module_depends_on" {
  type        = any
  description = "(Optional) A list of external resources the module depends_on. Default is '[]'."
  default     = []
}
