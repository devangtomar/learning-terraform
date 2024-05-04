variable "instance_type" {
  type        = string
  description = "EC2 instance type"
}

variable "tag" {
  type        = string
  description = "The tag for the EC2 instance"
}

variable "location" {
  type        = string
  description = "The project region"
  default     = "ap-south-1"
}

variable "availability_zone" {
  type        = string
  description = "The project availability zone"
  default     = "ap-south-1c"
}

variable "ami" {
  type        = string
  description = "The project region"
}

variable "region" {
  type        = string
  description = "Region for resource"
}