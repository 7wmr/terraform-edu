variable "aws_region" {
  type        = string
  description = "AWS region to be used"
  default     = "eu-west-2"
}

variable "mysql" {
  type        = any
  description = "MySQL database arguments"
  default     = {
    name      = "mysqldbs"
    username  = "admin"
    password  = "Pa$$w0rd" 
    port      = 3306
  }
}

variable "cluster_name" {
  type        = string
  description = "The name of the cluster"
  default     = "edu-cluster"
}




