variable "aws_region" {
  type        = string
  description = "AWS region to be used"
  default     = "eu-west-2"
}

variable "cluster_name" {
  type        = string
  description = "The name of the cluster"
  default     = "edu-cluster"
}

variable "server_port" {
  type        = number
  description = "The instance port"
  default     = 8080
} 

variable "elb_port" {
  type        = number
  description = "The load balanacer port"
  default     = 80
}

variable "elb_domain" {
  type        = string
  description = "The domain for the load balancer"
  default     = "8lr.co.uk"
}

variable "min_instance_count" {
  type        = number
  description = "Min instances provisioned by ASG"
  default     = "2"
}

variable "max_instance_count" {
  type        = number
  description = "Max instances provisioned by ASG"
  default     = "10"
}

