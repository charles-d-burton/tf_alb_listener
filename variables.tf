#Load balancer Health check configurations

variable "health_check_interval" {
  default = 30
}

variable "health_check_path" {
  default = "/"
}

variable "health_check_port" {
  default = "traffic-port"
}

variable "health_check_protocol" {
  default = "HTTP"
}

variable "health_check_timeout" {
  default = 5
}

variable "health_check_healthy_threshold" {
  default = 5
}

variable "health_check_unhealthy_threshold" {
  default = 2
}

variable "health_check_matcher" {
  default = 200
}

#Network variables
variable "inbound_cidr_blocks" {
  description = "The cidr blocks to allow inbound"
  type        = "list"
  default     = ["0.0.0.0/0"]
}

variable "vpc_id" {
  description = "The VPC to use to place the lister in"
  type        = "string"
}

#Target group configurations
variable "connection_draining_delay" {
  description = "How long the load balancer will allow connections to drain"
  default     = 60
}

variable "target_port" {
  description = "The port listening port of the service to send to, containers are configured to be dynamic"
  default     = "traffic-port"
}

variable "cookie_duration" {
  description = "Cookie stickiness lifetime, defaults to a day"
  default     = 86400
}

variable "stickiness_enabled" {
  description = "Setup cookie based stickiness"
  default     = false
}

#Ingress/Egress Security group configurations
variable "security_group_id" {
  description = "The passed in security group"
}

#ALB Configurations
variable "alb_arn" {
  description = "The arn of the load balancer to connect to"
}

variable "ssl_certificat_id" {
  description = "The ARN of the ACM managed SSL Cert"
}

variable "use_https" {
  description = "Enable or disable https"
  default     = true
}

variable "use_http" {
  description = "Enable or disable plain http"
  default     = true
}

variable "http_port" {
  type        = "string"
  description = "The port to listen on for http traffice"
}

variable "https_port" {
  type        = "string"
  description = "The https port to listen on"
}

#Listener rule configurations
variable "https_path_rule_enabled" {
  description = "Enable path based routing rule"
  default     = false
}

variable "https_host_rule_enabled" {
  description = "Enable host based routing rule"
  default     = false
}

variable "http_path_rule_enabled" {
  description = "Enable path based routing rule"
  default     = false
}

variable "http_host_rule_enabled" {
  description = "Enable host based routing rule"
  default     = false
}

variable "path_list" {
  description = "The path patterns to match"
  type        = "list"
  default     = []
}

variable "host_host" {
  description = "The list of hosts to match"
  type        = "list"
  default     = []
}
