variable "project_main_prefix" {


}

variable "codestar_connection_arn" {

}

variable "account_id" {

}

variable "region" {

}

variable "environment" {

}


variable "crossaccount_roles" {
  type        = list(string)
  description = "List of cross account roles to be assume by main role"
  default     = []
}