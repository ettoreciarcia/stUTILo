variable "cluster_name" {
  type        = string
  description = "The name of the EKS cluster"
}

variable "env_name" {
  type        = string
  description = "The name of the environment"
}

variable "region" {
  type        = string
  description = "The AWS region"

}

# variable "nodegroup_names" {
#   type        = list(string)
#   description = "The names of the EKS nodegroups"
# }

variable "scale_down_schedule" {
  type        = string
  description = "The schedule for scaling down the EKS cluster"
  default     = "cron(0 19 * * ? *)"
}

variable "scale_up_schedule" {
  type        = string
  description = "The schedule for scaling up the EKS cluster"
  default     = "cron(0 8 * * ? *)"
}

#I tried to get this information from the resource inside AWS, but it's too risky to use for the scale up function
variable "autoscaling_groups_info" {
  type = list(object({
    name             = string
    desired_capacity = number
    min_size         = number
    max_size         = number
  }))
}
