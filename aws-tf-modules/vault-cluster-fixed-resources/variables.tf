#####=================Global Variables==============#####
variable "default_region" {
  type        = string
  description = "AWS region to deploy our resources"
}

variable "environment" {
  type        = string
  description = "Environment to be configured 'dev', 'qa', 'prod'"
}

variable "owner_team" {
  type        = string
  description = "Name of owner team"
}

variable "component_name" {
  type        = string
  description = "Component name for resources"
}

#####======================DynamoDB Table Variables=========================#####
variable "read_capacity" {
  type = number
  description = "RCU for dynamoDB table"
}

variable "write_capacity" {
  type = number
  description = "RCU for dynamoDB table"
}

#####==============Local variables======================#####
locals {
  common_tags = {
    Team        = var.owner_team
    Environment = var.environment
    Component   = var.component_name
  }
}
