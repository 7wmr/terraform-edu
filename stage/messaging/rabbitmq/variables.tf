variable "key_name" {
  type        = string
  description = "SSH key name"
  default     = "ipsoft-macbook"
}

variable "cluster_name" {
  type        = string
  description = "Name of cluster to be created."
  default     = "edu-cluster"  
}

variable "aws_region" {
  type        = string
  description = "AWS region to be used"
  default     = "eu-west-2"
}

variable "rabbitmq" {
  type         = any
  description  = "RabbitMQ arguments"
  default      = {
    username   = "admin"
    password   = "Pa$$w0rd"
  }
}


