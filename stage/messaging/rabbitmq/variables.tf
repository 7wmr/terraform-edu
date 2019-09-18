variable "key_name" {
  type        = string
  description = "SSH key name"
  default     = "ipsoft-macbook"
}

variable "rabbitmq_name" {
  type        = string
  description = "Name of rabbitmq instance to be created."
  default     = "edu-rabbitmq"  
}

variable "aws_region" {
  type        = string
  description = "AWS region to be used"
  default     = "eu-west-2"
}

variable "domain_name" {
  type        = string
  description = "Domain name to be used."
  default     = "8lr.co.uk"
}

variable "rabbitmq" {
  type         = any
  description  = "RabbitMQ arguments"
  default      = {
    username   = "admin"
    password   = "Pa$$w0rd"
  }
}


