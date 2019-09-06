variable "server_port" { 
  description = "The instance port"
  default = 8080
} 

variable "elb_port" {
  description = "The load balanacer port"
  default = 80
}

variable "elb_domain" {
  description = "The domain for the load balancer"
  default = "8lr.co.uk"
}

variable "elb_record" {
  description = "The record to be applied to domain"
  default = "edu"
}


