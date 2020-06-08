variable "project_id" {
  type = string
}

variable "region" {
  type = string
}

variable "environment" {
  type = string
}

variable "build_number" {
  type = string
}

variable "database_connection_string" {
  type = string
}

variable "domain_name" {
  type = string
}

variable "zone_name" {
  type = string
}

variable "subdomain" {
  type = string
}

variable "image_name"{
  type = string
}

variable "log_level"{
  type = string
  default = "debug"
}