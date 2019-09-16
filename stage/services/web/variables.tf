variable "aws_region" {
  type        = string
  description = "AWS region to be used"
  default     = "eu-west-2"
}

variable "key_name" {
  type        = string
  description = "SSH key name"
  default     = "home-macbook"
}

variable "cluster_name" {
  type        = string
  description = "The name of the cluster"
  default     = "edu-cluster"
}

variable "app_version" {
  type        = string
  description = "The application version number e.g. v1.0.0"
  default     = "v1.2.0"
}

variable "app_port" {
  type        = number
  description = "The application web port"
  default     = 8080
} 

variable "elb" {
  type        = any
  description = "Load balancer configuration"
  default     = {
    port      = 80
    domain    = "8lr.co.uk"
  }
}

variable "asg" {
  type         = any
  description  = "Auto scaling group configuration"
  default      = {
    min_size   = 2
    max_size   = 10
  }
}

