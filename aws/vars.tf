variable "aws_region" {
  type        = string
  description = "AWS region to be used"
  default     = "eu-west-2"
}

variable "key_name" {
  type        = string
  description = "SSH key name"
  default     = "contino-macbook"
}

variable "web_app" {
  type        = any 
  description = "Web application configuration"
  default     = {
    release   = "v1.4.0"
    name      = "web"
    port      = 8080
  }
}

variable "web_elb" {
  type        = any
  description = "Web load balancer configuration"
  default     = {
    port      = 443
    domain    = "8lr.co.uk"
  }
}

variable "web_asg" {
  type         = any
  description  = "Web auto scaling group configuration"
  default      = {
    min_size   = 2
    max_size   = 10
    enabled    = true
  }
}

variable "run_app" {
  type        = any 
  description = "Run application configuration"
  default     = {
    release   = "v1.2.2"
    name      = "run"
  }
}

variable "mysql" {
  type        = any
  description = "MySQL database arguments"
  default     = {
    name      = "dbs"
    username  = "admin"
    password  = "Pa$$w0rd"
    port      = 3306
  }
}

variable "rabbitmq" {
  type         = any
  description  = "RabbitMQ configuration"
  default      = {
    name       = "msg"
    username   = "admin"
    password   = "Pa$$w0rd"
    domain     = "8lr.co.uk"
  }
}
