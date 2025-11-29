variable "instance_type" {
  type        = string
  description = "EC2 Instance Type"
}

variable "location" {
  type        = string
  description = "The Project region"
  default     = "ap-south-1"
}