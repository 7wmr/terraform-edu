variable "web_port" { 
  description = "The instance port"
  default = 8080
} 

variable "elb_port" {
  description = "The load balanacer port"
  default = 80
}
