variable "number_example" {
  description = "An example of a number variable in terraform"
  type        = number
  default     = 4
}

variable "list_example" {
  type    = list(number)
  default = [1, 2, 3]
}

variable "string_example" {
  type    = string
  default = "value"
}

variable "map_example" {
  type = map(string)
  default = {
    "fdfd" = "value"
  }
}

variable "object_example" {
  type = object({
    name = string
    age  = number
  })
  default = {
    name = "devang"
    age  = 3
  }
}

variable "server_port" {
  description = "The port the server will use for HTTP requests"
  type        = number
  default     = 8080
}
