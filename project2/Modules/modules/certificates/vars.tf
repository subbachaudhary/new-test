variable "env" {}
variable "project_name" {}
variable "domain_name" {
    description = "define domain name"
    type        = string
}
variable "zone_name" {
    description = "this is for the zone name"
    type        = string
}
variable "subject_alternative_names" {}